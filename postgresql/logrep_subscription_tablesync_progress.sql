-- via https://gorthx.wordpress.com/2023/02/10/quick-logical-replication-checklist/

/* When replication is caught up, pg_subscription_rel.srsubstate will be 'r' for all tables */
SELECT srrelid::regclass, srsubstate, srsublsn
FROM pg_subscription_rel 
ORDER BY srsubstate;

/*
srsubstate key:
i = initialize
d = data is being copied
f = finished table copy
s = synchronized
r = ready (normal replication)
*/


