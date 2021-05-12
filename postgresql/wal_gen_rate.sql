-- Useful for checkpoint tuning
do $$
declare
    start_lsn pg_lsn;
    end_lsn pg_lsn;
    lsn_diff text;
begin
    select pg_current_wal_insert_lsn() into start_lsn;
    raise notice 'start_lsn is %', start_lsn;
    perform pg_sleep(300);
    select pg_current_wal_insert_lsn() into end_lsn;
    raise notice 'end_lsn is %', end_lsn;
    select pg_size_pretty(pg_wal_lsn_diff(end_lsn, start_lsn)) into lsn_diff;

    raise notice 'DB used % in 5 minutes.', lsn_diff;
end $$;
