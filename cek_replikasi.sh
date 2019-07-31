#!/usr/bin/env bash
#author	 : ngadmin
#version : 0.1

date=`date`
workdir=`dirname "$0"`
cd $workdir

master_host=10.10.10.95
slave_host=10.10.10.99
pguser="postgres"
pgdb="postgres"

rep_status=`psql -U $pguser -h $master_host -d $pgdb -c "select state from pg_stat_replication" | awk 'FNR==3' | awk '{print $1}'`
master=`psql -U $pguser -h $master_host -d $pgdb -c "SELECT pg_current_xlog_location();" | awk 'FNR==3'`
slave=`psql -U $pguser -h $slave_host -d $pgdb -c "SELECT pg_last_xlog_receive_location();" | awk 'FNR==3'`
rep_lags=`psql -U $pguser -h $slave_host -d $pgdb -c " SELECT CASE WHEN pg_last_xlog_receive_location() = pg_last_xlog_replay_location() THEN 0 ELSE EXTRACT (EPOCH FROM now() - pg_last_xact_replay_timestamp())::INTEGER END AS replication_lag;"`
rep_delay=`psql -U $pguser -h $slave_host -d $pgdb -c "SELECT pg_xlog_location_diff(pg_last_xlog_receive_location(), pg_last_xlog_replay_location()) AS replication_delay_bytes;"`

if [ "$rep_status" = "streaming" ]; then
	echo $date $rep_status >> log/stream.log
else
	echo $rep_status >> log/stream.log
	/usr/bin/python notify/send-notify-fail.py
fi

echo $date current_xlog_location on master : $master >> log/xlog_location.log
echo $date last_xlog_receive_location on slave : $slave >> log/xlog_location.log
echo $date $rep_lags >> log/xlog_location.log
echo $date $rep_delay >> log/xlog_location.log
