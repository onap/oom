#!/bin/sh -x
SQL_DEST_DIR=${SQL_DEST_DIR:-/tmp/sql}
DB_PORT=${DB_PORT:-3306}

[[ -z "$SQL_SRC_DIR" ]] && { echo "Error: SQL_SRC_DIR must be provided as an environment variable"; exit 1; }
[[ -z "$DB_USER" ]] && { echo "Error: DB_USER must be provided as an environment variable"; exit 1; }
[[ -z "$DB_PASS" ]] && { echo "Error: DB_PASS must be provided as an environment variable"; exit 1; }
[[ -z "$DB_HOST" ]] && { echo "Error: DB_HOST must be provided as an environment variable"; exit 1; }

mkdir -p $SQL_DEST_DIR

#Find all sql files and copy them to the destination directory
find "/onap-sources/$SQL_SRC_DIR" -type f -iname "*.sql" | awk -v dest="$SQL_DEST_DIR" '{n=split($1,a,"/"); system(sprintf( "cp %s %s", $1, dest"/"a[n])) }'


#Not needed right now?
#--database=$DB_NAME

#--force to deal with duplicate records in absense of "insert ignore"
##ERROR 1062 (23000) at line 382: Duplicate entry '2' for key 'PRIMARY'

cd $SQL_DEST_DIR
cat *.sql | mysql -vv --user=$DB_USER --password=$DB_PASS --host=$DB_HOST --port=$DB_PORT --force
