#!/bin/bash

# Gives select permission to all tables in schema SAPECD to the role sapreadonly
db2 -tnx "select distinct 'GRANT select ON TABLE '||
       '\"'||rtrim(tabschema)||'\".\"'||rtrim(tabname)||'\" TO role sapreadonly;'
       from syscat.tables
       where tabschema = 'SAPECD' "  >> grants.sql

db2 -tvf grants.sql
