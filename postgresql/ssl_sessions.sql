-- Check which DB sessions are using SSL
-- From https://dba.stackexchange.com/questions/225872/how-to-verify-ssl-always-being-used-on-postgresql-9-6
SELECT datname,usename, ssl, client_addr 
  FROM pg_stat_ssl
  JOIN pg_stat_activity
    ON pg_stat_ssl.pid = pg_stat_activity.pid;
