select v.*, a.query_start, age(now(), a.query_start), a.query
from pg_stat_progress_vacuum v
join pg_stat_activity a
on v.pid=a.pid;
