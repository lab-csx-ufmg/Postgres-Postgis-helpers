# Postgres/Postgis helpers
Those scripts are a set of helpers to make our lifes easier when dealing with postgres/postgis.

## Postgis Transfer
transfer_postigis_db and change_db_owner can be used to transfer data from one spatial database to another using the network. One of the uncommon (but very helpful) usage of those scripts is to backup data indirectly in a newer or older version of postgres/postgis.

### How it works
The transfer_postgis_db shell script creates a custom database using pg_dump, then creates a new database at the destination and applies the create extention postgis to enable this spatial extension. All data is placed in the new database with postgis_restore.pl perl's script which is shipped with postgis.

Since all operations are executed with 'postgres' user, to ensure that all objects are created, after the first script execution, the second one is used to change permissions of all objects to the onwer.

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
