-- from @gorthx
-- "what's running most frequently and who's doing it"
SELECT pgr.rolname
, pss.queryid
, pss.calls
, pss.mean_plan_time
, pss.mean_exec_time
, left(pss.query, 100)  -- shorter for readability
FROM pg_stat_statements pss
JOIN pg_roles pgr ON pss.userid = pgr.oid
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
ORDER BY calls DESC
LIMIT 10;


-- from https://supabase.com/docs/guides/database/extensions/pg_stat_statements#inspecting-activity
-- identify frequently executed and slow queries against a given table.
select
	calls,
	mean_exec_time,
	max_exec_time,
	total_exec_time,
	stddev_exec_time,
	query
from
	pg_stat_statements
where
    calls > 50                   -- at least 50 calls
    and mean_exec_time > 2.0     -- averaging at least 2ms/call
    and total_exec_time > 60000  -- at least one minute total server time spent
    and query ilike '%user_in_organization%' -- filter to queries that touch the user_in_organization table
order by
	calls desc;
