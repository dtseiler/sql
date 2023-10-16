/* 
 * c = check constraint
 * f = foreign key constraint
 * p = primary key constraint
 * u = unique constraint
 * t = constraint trigger
 * x = exclusion constraint
 */
select t.relname as table_name, c.conname as constraint_name, c.contype as constraint_type
from pg_constraint c
    join pg_class t
        on c.conrelid=t.oid
where c.convalidated = false;
