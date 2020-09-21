select pg_is_in_recovery(),pg_is_wal_replay_paused(), pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn(), 
    pg_last_xact_replay_timestamp(), now(), age(now(), pg_last_xact_replay_timestamp());
