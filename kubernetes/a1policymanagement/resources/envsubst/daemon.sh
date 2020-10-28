#!/bin/sh
# Copyright © 2020 Samsung Electronics

terminate() {
  pids="$(jobs -p)"
  if [ "$pids" != "" ]; then
    kill -TERM $pids >/dev/null 2>/dev/null
  fi
  wait
}

cat <<EOF >/tmp/update_files
{{ .Files.Get "resources/envsubst/update_files" | replace "$" "\\$" }}
EOF
chmod +x /tmp/update_files

trap terminate TERM
echo "$(date) | INFO | Started monitoring /config-input/ directory"
inotifyd /tmp/update_files /config-input/ &
wait
