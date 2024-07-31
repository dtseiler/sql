-- List all sequences and their associated tables in a database
SELECT N.nspname, S.relname, T.relname AS table_name
FROM pg_class S
LEFT JOIN pg_depend D ON (S.oid = D.objid)
LEFT JOIN pg_class T ON (D.refobjid = T.oid)
LEFT JOIN pg_namespace N ON (N.oid = S.relnamespace)
WHERE S.relkind = 'S' AND D.deptype = 'a'
ORDER BY 1,2;
