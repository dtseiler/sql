-- check for FKs where there is no matching index on the referencing side or a bad index
-- jberkus http://www.databasesoup.com/2014/11/finding-foreign-keys-with-no-indexes.html
WITH fk_actions (
    code,
    ACTION
) AS (
    VALUES
        (
            'a',
            'error'
        ),
        (
            'r',
            'restrict'
        ),
        (
            'c',
            'cascade'
        ),
        (
            'n',
            'set null'
        ),
        (
            'd',
            'set default'
        )
),
fk_list AS (
    SELECT
        pg_constraint.oid AS fkoid,
        conrelid,
        confrelid AS parentid,
        conname,
        relname,
        nspname,
        fk_actions_update.action AS update_action,
        fk_actions_delete.action AS delete_action,
        conkey AS key_cols
    FROM
        pg_constraint
        JOIN pg_class ON conrelid = pg_class.oid
        JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
        JOIN fk_actions AS fk_actions_update ON confupdtype = fk_actions_update.code
        JOIN fk_actions AS fk_actions_delete ON confdeltype = fk_actions_delete.code
    WHERE
        contype = 'f'
),
fk_attributes AS (
    SELECT
        fkoid,
        conrelid,
        attname,
        attnum
    FROM
        fk_list
    JOIN pg_attribute ON conrelid = attrelid
    AND attnum = ANY (
        key_cols
    )
    ORDER BY
        fkoid,
        attnum
),
fk_cols_list AS (
    SELECT
        fkoid,
        array_agg (
            attname
        ) AS cols_list
    FROM
        fk_attributes
    GROUP BY
        fkoid
),
index_list AS (
    SELECT
        indexrelid AS indexid,
        pg_class.relname AS indexname,
        indrelid,
        indkey,
        indpred IS NOT NULL AS has_predicate,
        pg_get_indexdef (
            indexrelid
        ) AS indexdef
    FROM
        pg_index
    JOIN pg_class ON indexrelid = pg_class.oid
    WHERE
        indisvalid
),
fk_index_match AS (
    SELECT
        fk_list.*,
        indexid,
        indexname,
        indkey::int [ ] AS indexatts,
        has_predicate,
        indexdef,
        array_length (
            key_cols,
            1
        ) AS fk_colcount,
        array_length (
            indkey,
            1
        ) AS index_colcount,
        round (
            pg_relation_size (
                conrelid
            )
            / (
                1024 ^ 2
            ) ::numeric
        ) AS table_mb,
        cols_list
    FROM
        fk_list
    JOIN fk_cols_list USING (
        fkoid
    )
    LEFT OUTER JOIN index_list ON conrelid = indrelid
    AND (
        indkey::int2 [ ]
    )
    [ 0: (
        array_length (
            key_cols,
            1
        )
        - 1
    )
    ] @> key_cols
),
fk_perfect_match AS (
    SELECT
        fkoid
    FROM
        fk_index_match
    WHERE (
        index_colcount - 1
    )
    <= fk_colcount
    AND NOT has_predicate
    AND indexdef LIKE '%USING btree%'
),
fk_index_check AS (
    SELECT
        'no index' AS issue,
        *,
        1 AS issue_sort
    FROM
        fk_index_match
    WHERE
        indexid IS NULL
    UNION ALL
    SELECT
        'questionable index' AS issue,
        *,
        2
    FROM
        fk_index_match
    WHERE
        indexid IS NOT NULL
        AND fkoid NOT IN (
            SELECT
                fkoid
            FROM
                fk_perfect_match
        )
),
parent_table_stats AS (
    SELECT
        fkoid,
        tabstats.relname AS parent_name,
        (
            n_tup_ins +
            n_tup_upd +
            n_tup_del +
            n_tup_hot_upd
        ) AS parent_writes,
        round (
            pg_relation_size (
                parentid
            )
            / (
                1024 ^ 2
            ) ::numeric
        ) AS parent_mb
    FROM
        pg_stat_user_tables AS tabstats
    JOIN fk_list ON relid = parentid
),
fk_table_stats AS (
    SELECT
        fkoid,
        (
            n_tup_ins +
            n_tup_upd +
            n_tup_del +
            n_tup_hot_upd
        ) AS writes,
        seq_scan AS table_scans
    FROM
        pg_stat_user_tables AS tabstats
    JOIN fk_list ON relid = conrelid
)
SELECT
    nspname AS schema_name,
    relname AS table_name,
    conname AS fk_name,
    issue,
    table_mb,
    writes,
    table_scans,
    parent_name,
    parent_mb,
    parent_writes,
    cols_list,
    indexdef
FROM
    fk_index_check
    JOIN parent_table_stats USING (
        fkoid
    )
    JOIN fk_table_stats USING (
        fkoid
    )
WHERE
    table_mb > 9
    AND (
        writes > 1000
        OR parent_writes > 1000
        OR parent_mb > 10
    )
ORDER BY
    issue_sort,
    table_mb DESC,
    table_name,
    fk_name;

/* vim: set expandtab:ts=4:sw=4 */
