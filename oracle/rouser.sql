set lines 256 head off feed off pages 0 trimspool on
spool grant.sql

select 'set echo on' from dual;
select 'spool grant.log' from dual;

select 'GRANT SELECT ON '||owner||'.'||object_name||' TO new_user;'
from all_objects
where owner = old_user
and object_type in ('SEQUENCE','TABLE','VIEW','MATERIALIZED VIEW')
order by owner, object_name;

select 'spool off' from dual;
select 'exit' from dual;

spool off
exit
