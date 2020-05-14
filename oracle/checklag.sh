#!/bin/ksh

#
# Standby lag monitor script
# Don Seiler, don@seiler.us
#

if [[ $# -eq 0 ]];then
   print "Specify ORACLE_SID value on command-line."
   exit 1
fi

RECIPIENTS="you@yourcompany.com"
DATESTAMP=`date +%Y%m%d`
LOGFILE=/home/oracle/dba/log/checklag_${DATESTAMP}.log

PATH=$PATH:/bin:/usr/bin:/usr/local/bin; export PATH
ORACLE_SID=$1; export ORACLE_SID
ORAENV_ASK=NO; export ORAENV_ASK
. /usr/local/bin/oraenv

export NLS_DATE_FORMAT='yyyy/mm/dd hh24:mi:ss';

sqlplus -s /nolog <<EOF
connect / as sysdba
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
col name for a25
spool $LOGFILE
select name, database_role from v\$database;

select sysdate, max(first_time) last_applied_log, round((sysdate-max(first_time))*24,2) lag_hours
from v\$archived_log
where applied='YES' and registrar='RFS';

select process, status, thread#, sequence#
from v\$managed_standby
where process like 'MR%';

select * from v\$dataguard_stats;
spool off;
exit;
EOF

# Mail log file to dba
mail -s "$ORACLE_SID Standby Lag Check" "$RECIPIENTS" <$LOGFILE;
