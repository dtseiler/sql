select datname, application_name, count(*)
from pg_stat_activity
where client_addr is not null
group by datname, application_name
order by datname, application_name;
