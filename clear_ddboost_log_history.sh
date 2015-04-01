#!/bin/bash

# DB2 requires that the "comment field" of log archives (i.e. LOGARCHOPT1) be less than 30 characters. If that's not the case, the comment will be left blank and EMC DDBoost will have trouble pruning the logs.
# Please note that default template file location (/opt/ddbda/config/db2_ddbda.cfg) has over 30 characters!
# If you're having segtfaults when doing backup or pruning this might be the cause
# Also you db2 history gets really cluttered since atomatic-deletion of logs stops working

# This script update the "comment field" of archive logs in history setting Boost's config file at /db2/boostcfg/db2_ddbda.cfg (make sure to copy or link the config file to this path!)
# After running the script execute db2 prune(which will take a long time) to properly clear the history in DB2

# This script is meant to be executed by your SIDADM user


db2 connect 

db2 list history archive log all for db $SAPSYSTEMNAME  | grep 'EID.*Location: /usr/lib/ddbda/lib64/libddboostdb2.so' | cut -f4 -d' ' | while read LOG_EID 
do
    db2 update history EID $LOG_EID with comment \"@/db2/boostcfg/db2_ddbda.cfg\" 
    break
done
