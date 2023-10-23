SELECT 'GRANT "'||b.rolname||'" TO "'||r.rolname||'";'
FROM pg_roles r JOIN pg_auth_members m
        ON r.oid=m.member
        JOIN pg_roles b
        ON m.roleid=b.oid
WHERE r.rolname in (
        SELECT x.rolname
        FROM pg_roles x
            JOIN pg_shadow s
            ON x.rolname=s.usename
        WHERE x.rolcanlogin
        AND s.passwd is not null
);
