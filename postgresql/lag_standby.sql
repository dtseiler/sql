select pg_is_in_recovery(),pg_is_wal_replay_paused(),
  pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn(),
  (pg_wal_lsn_diff(pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn())/1024)::bigint as lsn_diff_kb,
  pg_last_xact_replay_timestamp(), now(), age(now(), pg_last_xact_replay_timestamp()) as lag,
  extract(epoch from now() - pg_last_xact_replay_timestamp())::int as lag_seconds;
