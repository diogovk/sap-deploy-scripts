#!/bin/bash

# Due to a bug in DDBoost/DB2, the comment with the config file is not written when LOGARCHOPT1 is set to a path with over 30 characters (which is the default)

# The following will create a script that will update existing logs to the Boost's config file at /db2/boostcfg/db2_ddbda.cfg (make sure to copy or link the config file to this path!)

echo db2 connect > update_log_archive_comment.sh

db2 list history  archive log all for db $SAPSYSTEMNAME  | grep 'EID.*Location: /usr/lib/ddbda/lib64/libddboostdb2.so' | cut -f4 -d' ' | xargs -I% echo db2 update history  EID % with comment '\"@/db2/boostcfg/db2_ddbda.cfg\"' >> update_log_archive_comment.sh
