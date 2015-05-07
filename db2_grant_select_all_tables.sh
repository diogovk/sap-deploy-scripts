#!/bin/bash

## Create role:
# db2 create role sapreadonly
## Grant role to user
# db2 grant sapreadonly to user my_user

# Gives select permission to all tables in schema SAPECD to the role sapreadonly
db2 -tnx "select distinct 'GRANT select ON TABLE '||
       '\"'||rtrim(tabschema)||'\".\"'||rtrim(tabname)||'\" TO role sapreadonly;'
       from syscat.tables
       where tabschema = 'SAPECD' "  >> grants.sql

db2 -tvf grants.sql
