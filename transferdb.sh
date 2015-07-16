#!/bin/bash

in=$1
out=$2
dbname=$3
owner=$4

pg_share_dir=$(pg_config --sharedir);

# get data from server
pg_dump -h $in -p 5432 -U postgres -Fc -b -v -f "/var/tmp/${dbname}.backup" ${dbname}

# create new database
psql -h $out -p 5432 -U postgres -c "CREATE DATABASE \"${dbname}\" OWNER \"${owner}\";"

# create db extention
psql -h $out -p 5432 -U postgres -d ${dbname} -c "CREATE EXTENSION postgis;"

# put data on database
perl ${pg_share_dir}/contrib/postgis-2.1/postgis_restore.pl "/var/tmp/${dbname}.backup" | psql -h $out -U postgres ${dbname} 2>> /var/tmp/backupPostgres.log