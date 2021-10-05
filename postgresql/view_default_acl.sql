-- From https://www.dba-ninja.com/2020/06/how-to-find-default-access-privileges-on-postgresql-with-pg_default_acl.html
select pg_get_userbyid(d.defaclrole) as user, 
    n.nspname as schema, 
    case d.defaclobjtype when 'r' then 'tables' when 'f' then 'functions' end as object_type,
    array_to_string(d.defaclacl, ' + ')  as default_privileges 
from pg_catalog.pg_default_acl d left join pg_catalog.pg_namespace n 
    on n.oid = d.defaclnamespace;
