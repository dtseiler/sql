select i.*, a.query_start, age(now(), a.query_start), a.query
from pg_stat_progress_create_index i
join pg_stat_activity a
on i.pid=a.pid;
