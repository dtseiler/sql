-- query non-catalog/info tables that are not part of a publication
select a.schemaname, a.tablename
from pg_tables a
where a.schemaname not in ('pg_catalog','information_schema','partman')
and not exists (
    select 1 from pg_publication_tables b
    where b.schemaname=a.schemaname
    and b.tablename=a.tablename
)
order by 1,2;
