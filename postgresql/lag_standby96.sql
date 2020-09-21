select pg_is_in_recovery(), pg_last_xlog_receive_location(), pg_last_xlog_replay_location(), 
    pg_last_xact_replay_timestamp(), now(), age(now(), pg_last_xact_replay_timestamp());
