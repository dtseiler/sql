SELECT
    indrelid::regclass AS TABLE,
    indkey AS column_numbers,
    array_agg (
        indexrelid::regclass
    ) AS indexes,
    pg_catalog.pg_get_expr (
        indpred,
        indrelid,
        TRUE
    ) AS expression
FROM
    pg_index
GROUP BY
    indrelid,
    indkey,
    pg_catalog.pg_get_expr (
        indpred,
        indrelid,
        TRUE
    )
HAVING
    COUNT (
        *
    )
    > 1;

/* vim: set expandtab:ts=4:sw=4 */
