#!/bin/sh

if [ -e config.sh ]; then
  source ./config.sh
fi

dropdb -U $username -w $database
# createdb -O $username -U $username -T postgis_21_sample -w osm
createdb -O postgres -U $username -T template0 -w $database -E UTF8
psql -d $database -c "CREATE EXTENSION postgis;"
$psql_exe -f sql/pg.sql

exit 0
