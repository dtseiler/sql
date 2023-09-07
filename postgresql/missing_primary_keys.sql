SELECT
    n.nspname as schema,
    c.relname as table
FROM
    pg_class c
JOIN
    pg_namespace n
    ON n.oid = c.relnamespace
WHERE
    c.relkind = 'r'
    AND NOT EXISTS (
        SELECT 1
        FROM pg_constraint con
        WHERE con.conrelid = c.oid
        AND con.contype = 'p'
    )
    AND n.nspname <> ALL (
        ARRAY [
            'pg_catalog',
            'sys',
            'dbo',
            'information_schema'
        ]
    )
ORDER BY 1, 2;

/* vim: set expandtab:ts=4:sw=4 */
