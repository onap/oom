# sourced, not executed, by docker-entrypoint.sh (/bin/bash)

# defaults
: ${ICE_CMS_DB_USER:="icecmsuser"}
: ${ICE_CMS_DB_NAME:="icecmsdb"}
: ${ICE_CMS_DB_PASSWORD:="na"}

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<- EOF
    CREATE USER ${ICE_CMS_DB_USER} WITH CREATEDB PASSWORD '${ICE_CMS_DB_PASSWORD}';
    CREATE DATABASE ${ICE_CMS_DB_NAME} WITH OWNER ${ICE_CMS_DB_USER} ENCODING 'utf-8';
EOF
