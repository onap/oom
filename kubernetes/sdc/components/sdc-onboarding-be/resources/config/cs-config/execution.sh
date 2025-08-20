#!/bin/sh

# Create directories
mkdir -p /tmp/writable-config
mkdir -p /tmp/writable-config/sdctool
mkdir -p /tmp/writable-config/tools

# Copy files
cp -r /home/sdc/sdctool/* /tmp/writable-config/sdctool
cp -r /home/sdc/tools/* /tmp/writable-config/tools
cp /tmp/config/cassandra-db-scripts-common/* /tmp/writable-config/

# Adjust permissions
chmod -R a+rx,u+w /tmp/writable-config

# Make scripts executable
find /tmp/writable-config -type f -name "*.sh" -exec chmod a+rx {} \;
find /tmp/writable-config/tools -type f -name "*.py" -exec chmod a+rx {} \;

# Logs
mkdir -p /home/sdc/asdctool/logs/SDC/SDC-TOOL
chmod -R a+rx,u+w /home/sdc/asdctool/logs/SDC/SDC-TOOL

# Copy configuration files
cp -r /tmp/writable-config/janusgraph.properties /tmp/writable-config/sdctool/config
cp -r /tmp/writable-config/configuration.yaml /tmp/writable-config/sdctool/config

# Run DB scripts
sh -x /tmp/writable-config/change_cassandra_user.sh || exit
sh -x /tmp/writable-config/create_dox_keyspace.sh || exit

# Python script fix
cd /tmp/writable-config/tools/build/scripts
sed -i 's|#!/usr/bin/python|#!/usr/bin/python3|' parse-json.py

# Onboard DB schema
sh -x onboard-db-schema-creation.sh || exit

# Adjust permissions for sdctool
chmod -R a+rx,u+w /tmp/writable-config/sdctool

# Update java tmpdir for scripts
for script in schemaCreation.sh janusGraphSchemaCreation.sh sdcSchemaFileImport.sh; do
  sed -i "s|java \(.*\) -cp|java \1 -Djava.io.tmpdir=/tmp/writable-config/tmp -cp|" /tmp/writable-config/sdctool/scripts/$script
done

# Additional DB scripts
sh -x /tmp/writable-config/create-alter-dox-db.sh
sh -x /tmp/writable-config/sdctool/scripts/schemaCreation.sh /tmp/writable-config/sdctool/config || exit
sh -x /tmp/writable-config/sdctool/scripts/janusGraphSchemaCreation.sh /tmp/writable-config/sdctool/config || exit
sh -x /tmp/writable-config/importconformance.sh || exit
