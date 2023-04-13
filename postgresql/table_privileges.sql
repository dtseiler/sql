select grantee, privilege_type
from information_schema.role_table_grants
where table_schema='foo'
and table_name='bar'
order by grantee, privilege_type;
