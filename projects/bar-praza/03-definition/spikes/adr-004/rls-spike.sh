#!/bin/bash
# ADR-004 spike, database half: row-level security mechanics (Postgres 16). Not codebase code.
PSQL="psql -h /tmp -p 54329 -X -q -At -v ON_ERROR_STOP=0"
A=11111111-1111-1111-1111-111111111111
B=22222222-2222-2222-2222-222222222222
PASS=0; FAIL=0
check(){ # name expected actual
  if [ "$2" == "$3" ]; then echo "PASS  $1  (got: $3)"; PASS=$((PASS+1)); else echo "FAIL  $1  (expected: $2, got: $3)"; FAIL=$((FAIL+1)); fi; }
adm(){ $PSQL -U postgres -d spike "$@"; }
app(){ $PSQL -U app_user -d spike "$@"; }

$PSQL -U postgres -d postgres -c "drop database if exists spike" -c "create database spike" 
$PSQL -U postgres -d postgres -c "drop role if exists app_user" -c "drop role if exists owner_role" 
adm <<SQL
create role platform_operator login bypassrls;   -- used only by the operator command (F1-02), never by the API
create role owner_role login;                       -- migration owner (owns tables)
create role app_user login nosuperuser nobypassrls; -- runtime role used by the API
grant usage on schema public to app_user; grant create on schema public to owner_role;
SQL
$PSQL -U owner_role -d spike <<SQL
create table restaurants(id uuid primary key, name text not null);
create table staff(id uuid primary key default gen_random_uuid(), restaurant_id uuid not null references restaurants(id), name text not null, pin_hash text not null);
create table products(id uuid primary key default gen_random_uuid(), restaurant_id uuid not null references restaurants(id), name text not null, unique(restaurant_id,name));
create table variants(id uuid primary key default gen_random_uuid(), restaurant_id uuid not null references restaurants(id), product_id uuid not null references products(id), label text not null, price_cents int not null);
create index on products(restaurant_id); create index on variants(restaurant_id);
create function app_tenant() returns uuid language sql stable as \$\$ select nullif(current_setting('app.restaurant_id', true), '')::uuid \$\$;
do \$\$ declare t text; begin
  foreach t in array array['staff','products','variants'] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy tenant_isolation on %I using (restaurant_id = app_tenant()) with check (restaurant_id = app_tenant())', t);
  end loop; end \$\$;
alter table restaurants enable row level security;
create policy own_restaurant on restaurants using (id = app_tenant()) with check (id = app_tenant());
grant select,insert,update,delete on all tables in schema public to app_user;
grant select,insert on restaurants, staff to platform_operator;
grant execute on function app_tenant() to app_user;
revoke insert,update,delete on restaurants from app_user;   -- runtime role may only read its own restaurant
insert into restaurants values ('$A','Bar Praza'),('$B','Other Bar');
insert into staff(restaurant_id,name,pin_hash) values ('$A','Ana','hashA'),('$B','Beto','hashB');
insert into products(restaurant_id,name) values ('$A','Pulpo'),('$A','Tortilla'),('$B','Paella');
insert into variants(restaurant_id,product_id,label,price_cents) select p.restaurant_id,p.id,'Ración',1200 from products p;
SQL

# T1 own rows only
check "T1 A sees only its 2 products" 2 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from products; commit;" | tail -1)"
# T2 cross-tenant by id
BID=$(adm -c "select id from products where restaurant_id='$B'")
check "T2 A cannot read B product by id" 0 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from products where id='$BID'; commit;" | tail -1)"
# T3 insert into other tenant
OUT=$(app -c "begin; select set_config('app.restaurant_id','$A',true); insert into products(restaurant_id,name) values ('$B','Hack');" 2>&1 | grep -c "row-level security")
check "T3 A cannot insert a row for B (WITH CHECK)" 1 "$OUT"
# T4 update/delete cross tenant
check "T4a A update of B rows touches 0" 0 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); with u as (update products set name='x' where restaurant_id='$B' returning 1) select count(*) from u; commit;" | tail -1)"
check "T4b A delete of B rows touches 0" 0 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); with d as (delete from products where restaurant_id='$B' returning 1) select count(*) from d; commit;" | tail -1)"
# T4c move own row to B (UPDATE WITH CHECK)
OUT=$(app -c "begin; select set_config('app.restaurant_id','$A',true); update products set restaurant_id='$B' where name='Pulpo';" 2>&1 | grep -c "row-level security")
check "T4c A cannot re-assign its row to B" 1 "$OUT"
# T5 fail closed without context
check "T5 no tenant context -> 0 rows" 0 "$(app -c "select count(*) from products")"
# T5b: the same pooled connection after a request: context reverts to '' (not NULL); naive ::uuid cast would error
OUT=$(app <<SQL | tail -1
begin; select set_config('app.restaurant_id','$A',true); commit;
select count(*) from products;
SQL
)
check "T5b after commit on same connection -> 0 rows (is_local reverted, nullif guard works)" 0 "$OUT"
NAIVE=$(adm -c "select current_setting('app.restaurant_id',true)::uuid" 2>&1 | grep -c "invalid input syntax"); 
OUT=$(app <<SQL 2>&1 | grep -c "invalid input syntax for type uuid"
begin; select set_config('app.restaurant_id','$A',true); commit;
select '' || coalesce(nullif(current_setting('app.restaurant_id', true),''),'') ;
select current_setting('app.restaurant_id', true)::uuid;
SQL
)
check "T5c GOTCHA: naive ::uuid cast on a reused connection raises an error (so keep the nullif guard)" 1 "$OUT"
# T6 pooled connection: SET LOCAL per request never leaks to the next request
OUT=$(app <<SQL | tail -1
begin; select set_config('app.restaurant_id','$A',true); select count(*) from products; commit;
begin; select set_config('app.restaurant_id','$B',true); select count(*) from products; commit;
begin; select count(*) from products; commit;
SQL
)
check "T6 request 3 with no context on a reused connection sees 0 rows" 0 "$OUT"
# T7 session-level set leaks
OUT=$(app <<SQL | tail -1
select set_config('app.restaurant_id','$A',false);
begin; select count(*) from products; commit;
SQL
)
check "T7 ANTI-PATTERN: session-level set persists across requests (A rows visible with no per-request context)" 2 "$OUT"
# T8 owner bypass without FORCE
check "T8a table owner bypasses RLS without FORCE" 3 "$($PSQL -U owner_role -d spike -c "select count(*) from products")"
$PSQL -U owner_role -d spike -c "alter table products force row level security; alter table staff force row level security; alter table variants force row level security;" >/dev/null
check "T8b with FORCE the owner is filtered too" 0 "$($PSQL -U owner_role -d spike -c "select count(*) from products")"
check "T8c superuser still bypasses (tests must connect as app_user)" 3 "$(adm -c "select count(*) from products")"
# T9 global unique constraint leaks existence across tenants
$PSQL -U owner_role -d spike -c "create unique index staff_pin_global on staff(pin_hash)" >/dev/null
OUT=$(app -c "begin; select set_config('app.restaurant_id','$A',true); insert into staff(restaurant_id,name,pin_hash) values ('$A','Eve','hashB');" 2>&1 | grep -c "duplicate key")
check "T9 LEAK: global unique(pin_hash) reveals that B has this PIN hash (must be unique(restaurant_id,...))" 1 "$OUT"
$PSQL -U owner_role -d spike -c "drop index staff_pin_global; create unique index staff_pin_per_tenant on staff(restaurant_id,pin_hash)" >/dev/null
OUT=$(app -c "begin; select set_config('app.restaurant_id','$A',true); insert into staff(restaurant_id,name,pin_hash) values ('$A','Eve','hashB'); commit;" 2>&1 | grep -c -i "error")
OUT=$([ "$OUT" == "0" ] && echo 1 || echo 0)
check "T9b per-tenant unique allows the same value in another tenant" 1 "$OUT"
# T10 join across tenant tables
check "T10 join products x variants returns only A rows" 2 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from products p join variants v on v.product_id=p.id; commit;" | tail -1)"
# T11 views
$PSQL -U owner_role -d spike -c "create view v_products_plain as select * from products; create view v_products_invoker with (security_invoker=true) as select * from products; grant select on v_products_plain, v_products_invoker to app_user;" >/dev/null
check "T11a plain view (runs as owner) with FORCE RLS and no context" 0 "$(app -c "select count(*) from v_products_plain")"
check "T11b security_invoker view respects the caller's tenant" 2 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from v_products_invoker; commit;" | tail -1)"
# T12 SECURITY DEFINER function bypass check (what NOT to expose)
$PSQL -U owner_role -d spike -c "create function all_products_count() returns bigint language sql security definer as \$\$ select count(*) from products \$\$; grant execute on function all_products_count() to app_user;" >/dev/null
check "T12 SECURITY DEFINER function owned by a FORCE-RLS owner is still filtered (0 with no context)" 0 "$(app -c "select all_products_count()")"
# T13 platform table
check "T13 A sees only its own restaurant row" 1 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from restaurants; commit;" | tail -1)"
# T15/T16 restaurant creation (F1-02): runtime role cannot create restaurants; operator role can, and isolation holds afterwards
OUT=$(app -c "begin; select set_config('app.restaurant_id','$A',true); insert into restaurants values (gen_random_uuid(),'Evil Bar');" 2>&1 | grep -c "permission denied")
check "T15 runtime role cannot create a restaurant (no INSERT grant)" 1 "$OUT"
C=33333333-3333-3333-3333-333333333333
$PSQL -U platform_operator -d spike -c "begin; insert into restaurants values ('$C','New Bar'); insert into staff(restaurant_id,name,pin_hash) values ('$C','First Encargado','hashC'); commit;" >/dev/null
check "T16a operator-created restaurant C is visible to C with its first staff member" 1 "$(app -c "begin; select set_config('app.restaurant_id','$C',true); select count(*) from staff; commit;" | tail -1)"
check "T16b restaurant A still sees none of C" 0 "$(app -c "begin; select set_config('app.restaurant_id','$A',true); select count(*) from staff where restaurant_id='$C'; commit;" | tail -1)"
# T14 performance sanity
adm -c "alter role owner_role bypassrls" >/dev/null
$PSQL -U owner_role -d spike -c "insert into restaurants select gen_random_uuid(), 'r'||g from generate_series(1,50) g on conflict do nothing; insert into products(restaurant_id,name) select r.id, 'p'||g from restaurants r, generate_series(1,4000) g where r.name like 'r%'; analyze products;" >/dev/null
RID=$(adm -c "select id from restaurants where name='r7'")
bench(){ # role ctx(0/1) sql ; 300 repetitions in one session, ms per query
  app -c "do \$\$ declare t0 timestamptz; i int; n bigint; begin
    perform set_config('app.restaurant_id','$RID',true); t0:=clock_timestamp();
    for i in 1..300 loop select count(*) into n from products where restaurant_id='$RID' and name like 'p39%'; end loop;
    raise notice 'EXPLICIT-WHERE %', round(extract(epoch from clock_timestamp()-t0)*1000/300,3);
    t0:=clock_timestamp();
    for i in 1..300 loop select count(*) into n from products where name like 'p39%'; end loop;
    raise notice 'RLS-ONLY %', round(extract(epoch from clock_timestamp()-t0)*1000/300,3);
  end \$\$;" 2>&1 | grep -i "notice"; }
echo "INFO  T14 ms per query, app_user, 200k rows / 51 tenants:"; bench
echo "INFO  T14 plan with RLS:"; app -c "begin; select set_config('app.restaurant_id','$RID',true); explain select * from products where name='p5'; commit;" | sed -n 2,6p
echo; echo "RESULT: $PASS passed, $FAIL failed"
