-- from https://dataedo.com/kb/query/postgresql/find-tables-without-primary-keys
select tab.table_schema,
       tab.table_name
from information_schema.tables tab
left join information_schema.table_constraints tco 
          on tab.table_schema = tco.table_schema
          and tab.table_name = tco.table_name 
          and tco.constraint_type = 'PRIMARY KEY'
where tab.table_type = 'BASE TABLE'
      and tab.table_schema not in ('pg_catalog', 'information_schema')
      and tco.constraint_name is null
order by table_schema,
         table_name;
