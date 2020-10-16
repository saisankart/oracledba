#!/bin/bash
export PATH=$PATH:/usr/local/bin
ORACLE_HOST=`hostname -s`; export ORACLE_HOST
#set the local environment for GI HOME
ORACLE_DB_LIST=`$ORACLE_HOME/bin/srvctl config database -v | awk '{print $1"~*~"$2}'`
for DB_INFO in ${ORACLE_DB_LIST[*]}
do
   DB_ARRAY=(${DB_INFO//~*~/ })
   DB_NAME=${DB_ARRAY[0]}
   ORACLE_HOME=${DB_ARRAY[1]}; export ORACLE_HOME
 ORACLE_SID=`$ORACLE_HOME/bin/srvctl config database -d $DB_NAME | grep 'Database instance' | awk '{print $3}'`
   ORA_PROCESS_COUNT=`ps -ef | grep ora_smon_$ORACLE_SID | wc -l`
   if [[ $ORACLE_SID && $ORA_PROCESS_COUNT -ne 0 ]]
   then
       $ORACLE_HOME/bin/sqlplus / as sysdba @/home/oracle/ops_transition/startup.sql
   fi
done
EOF
