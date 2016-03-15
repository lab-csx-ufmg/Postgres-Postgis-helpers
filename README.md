# Postgres-Postgis-helpers
These are a set of helper scripts that make our lifes easy dealing with postgres/postgis.

## Postgis Transfer
transfer_postigis_db and change_db_owner can be used for transfering data from one spatial database to another using the network. One of the uncommon (but very helpful) usage of theses scripts is to indirect backup data in a newer or older version of postgres/postgis.

### How it works
The transfer_postgis_db shell script creates a custom using pg_dump, then creates a new database on destination and apply
create extention postgis to enable using this extension. The all data is placed on new database with postgis_restore.pl perl's
script which is shipped with postgis.

Since all operations are executed with 'postgres' user to ensure that all object are created, after the fist script is executed,
the second one is used to change permissions of all objects to the onwer.

### How to use
To take a copy of the database just execute:

```bash
./transfer_postgis_db.sh -o <origin_server> -d <destination_server> -ow <owner> -db <dbname> -dir <temp_directory_to_dump>
```

### Help messages
To show the help messages, just execute each shell script with param "-h"

```bash
./change_db_owner.sh -h
./transfer_postgis_db.sh -h
```

# Contributions
If you have contributions to our code, please make a pull request and let us know.
