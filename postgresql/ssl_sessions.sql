-- Check which **remote** DB sessions are using SSL
-- From https://dba.stackexchange.com/questions/225872/how-to-verify-ssl-always-being-used-on-postgresql-9-6
--   with some customizations
SELECT s.pid, a.datname, a.usename, a.client_addr, a.application_name, s.ssl::text
  FROM pg_stat_ssl s
  JOIN pg_stat_activity a
    ON s.pid = a.pid
 WHERE a.client_addr is not null;
