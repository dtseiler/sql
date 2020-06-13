SELECT
    pg_namespace.nspname AS schema_name,
    reltable.relname AS table_name,
    relindex.relname AS index_name,
    collname AS collation_name
FROM
    pg_index
JOIN
    pg_class AS reltable ON indrelid = reltable.oid
JOIN
    pg_class AS relindex ON indexrelid = relindex.oid
JOIN
    pg_collation ON indcollation[0] = pg_collation.oid
JOIN
    pg_namespace ON reltable.relnamespace = pg_namespace.oid
WHERE
    indkey[0] > 0
AND
    collcollate NOT IN (
        'C',
        'POSIX',
        'C.UTF-8'
    )
AND collname <> 'default'
ORDER BY
    schema_name,
    table_name,
    index_name
;

/* vim: set expandtab:ts=4:sw=4 */
