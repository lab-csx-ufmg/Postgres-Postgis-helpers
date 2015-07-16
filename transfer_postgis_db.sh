#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script transfer a postgis database from one server to another
 
OPTIONS:
	-h
	  Show this message
	
	-o
	  Origin server
	
	-d
	  Destination server
	  Default value localhost
	
	-db
	  Database name
	
	-ow
	  Owner
	  Default value postgres

	-dir
	  Backup folder
	  Default value /var/tmp

EOF
}

ORIGIN=
DESTINATION="localhost"
DBNAME=
OWNER="postgres"
BKPFOLDER="/var/tmp"
PGISRESTORE=$(pg_config --sharedir)/contrib/postgis-2.1/postgis_restore.pl

# A string with command options
OPTIONS=$@

# An array with all the arguments
ARGUMENTS=($OPTIONS)

# Loop index
IDX=0

for OPT in $OPTIONS
do
    # Incrementing index
    IDX=`expr $IDX + 1`

	case "$OPT" in
		-h)
			usage; exit 1;;
		-o)
			ORIGIN=${ARGUMENTS[$IDX]};;
		-d)
			DESTINATION=${ARGUMENTS[$IDX]};;
		-f)
			BKPFOLDER=${ARGUMENTS[$IDX]};;
		-dbname)
			DBNAME=${ARGUMENTS[$IDX]};;
		-owner)
			OWNER=${ARGUMENTS[$IDX]};;
	esac
done

if [[ -z $ORIGIN ]] || [[ -z $DESTINATION ]] || [[ -z $DBNAME ]] || [[ -z $OWNER ]]
	then
		usage
		exit 1
fi

# get data from server
pg_dump -h $ORIGIN -p 5432 -U postgres -Fc -b -v -f "$BKPFOLDER/$DBNAME.backup" $DBNAME

# create new database
psql -h $DESTINATION -p 5432 -U postgres -c "CREATE DATABASE \"$DBNAME\" OWNER \"$OWNER\";"

# create db extention
psql -h $DESTINATION -p 5432 -U postgres -d $DBNAME -c "CREATE EXTENSION postgis;"

# put data on database
perl $PGISRESTORE  "$BKPFOLDER/$DBNAME.backup" | psql -h $DESTINATION -U postgres $DBNAME 2>> $BKPFOLDER/backup.log

#change owner
./change_db_owner.sh -d $DBNAME -o $OWNER