#!/bin/sh

# Wait for ES to start then initialize SearchGuard
/usr/local/bin/docker-entrypoint.sh eswrapper &
/usr/share/elasticsearch/bin/wait_until_started.sh
/usr/share/elasticsearch/bin/init_sg.sh

wait