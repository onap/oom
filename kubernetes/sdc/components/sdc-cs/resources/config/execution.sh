#!/bin/sh

mkdir -p /tmp/writable-config
mkdir -p /tmp/writable-config/sdctool
mkdir -p /tmp/writable-config/tools
cp -r /home/sdc/sdctool/* /tmp/writable-config/sdctool
cp -r /home/sdc/tools/* /tmp/writable-config/tools
cp /tmp/config/cassandra-db-scripts-common/* /tmp/writable-config/
chmod +x /tmp/writable-config/*.sh
chmod +x /tmp/writable-config/tools/*/*/*
mkdir -p /home/sdc/asdctool/logs/SDC/SDC-TOOL
chmod -R 770 /home/sdc/asdctool/logs/SDC/SDC-TOOL
cp -r /tmp/writable-config/janusgraph.properties /tmp/writable-config/sdctool/config
cp -r /tmp/writable-config/configuration.yaml /tmp/writable-config/sdctool/config
sh -x /tmp/writable-config/change_cassandra_user.sh || exit
sh -x /tmp/writable-config/create_dox_keyspace.sh || exit
cd /tmp/writable-config/tools/build/scripts
sed -i 's|#!/usr/bin/python|#!/usr/bin/python3|' /tmp/writable-config/tools/build/scripts/parse-json.py
sh -x /tmp/writable-config/tools/build/scripts/onboard-db-schema-creation.sh || exit
chmod -R 770 /tmp/writable-config/sdctool
sed -i 's/java \(.*\) -cp/java \1 -Djava.io.tmpdir=\/tmp\/writable-config\/tmp -cp/' /tmp/writable-config/sdctool/scripts/schemaCreation.sh
sed -i 's/java \(.*\) -cp/java \1 -Djava.io.tmpdir=\/tmp\/writable-config\/tmp -cp/' /tmp/writable-config/sdctool/scripts/janusGraphSchemaCreation.sh
sed -i 's/java \(.*\) -cp/java \1 -Djava.io.tmpdir=\/tmp\/writable-config\/tmp -cp/' /tmp/writable-config/sdctool/scripts/sdcSchemaFileImport.sh
sh -x /tmp/writable-config/create-alter-dox-db.sh
sh -x /tmp/writable-config/sdctool/scripts/schemaCreation.sh /tmp/writable-config/sdctool/config || exit
sh -x /tmp/writable-config/sdctool/scripts/janusGraphSchemaCreation.sh /tmp/writable-config/sdctool/config || exit
sh -x /tmp/writable-config/importconformance.sh || exit