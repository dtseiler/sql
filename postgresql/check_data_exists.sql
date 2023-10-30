-- quickly check if a given table has any data at all
-- via https://dba.stackexchange.com/questions/323477/quickest-way-to-test-it-a-postgres-table-has-any-data-in-it
select exists (select * from table_name limit 1) as has_data;
