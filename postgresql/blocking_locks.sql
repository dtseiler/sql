-- From https://github.com/heroku/heroku-pg-extras
select 
    bl.pid as blocked_pid, 
    ka.query as blocking_statement, 
    now() - ka.query_start as blocking_duration, 
    kl.pid as blocking_pid, 
    a.query as blocked_statement, 
    now() - a.query_start as blocked_duration 
from pg_catalog.pg_locks bl 
join pg_catalog.pg_stat_activity a 
    on bl.pid = a.pid 
join pg_catalog.pg_locks kl 
join pg_catalog.pg_stat_activity ka 
    on kl.pid = ka.pid 
    on bl.transactionid = kl.transactionid 
        and bl.pid != kl.pid where not bl.granted;
