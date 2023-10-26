-- via Phil the Thrill Vacca
WITH dupes AS (
    SELECT MIN(ctid) as ctid, foo_id, first_name, last_name
    FROM foo
    GROUP BY (foo_id, first_name, last_name) HAVING COUNT(*) > 1
)
DELETE
FROM foo AS a
WHERE EXISTS (
    SELECT FROM dupes WHERE foo_id = a.foo_id
        AND first_name = a.first_name
        AND last_name = a.last_name
        AND ctid <> a.ctid
);
