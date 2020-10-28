#!/bin/sh
# Copyright © 2020 Samsung Electronics

terminate() {
  pids="$(jobs -p)"
  if [ "$pids" != "" ]; then
    kill -TERM $pids >/dev/null 2>/dev/null
  fi
  wait
}

cat <<EOF >/update_files
#!/bin/sh
if [ "\$1" == "y" ] && [ "\$3" == "..data" ]; then
  echo "\$(date) | INFO | Configmap has been reloaded"
  cd /config-input
  for file in \$(ls -1); do
    if [ "\$file" -nt "/config/\$file" ]; then
      echo "\$(date) | INFO | Templating /config/\$file"
      envsubst <\$file >/config/\$file
    fi
  done
fi
EOF
chmod +x /update_files

trap terminate TERM
echo "Started monitoring /config-input/ directory"
inotifyd /update_files /config-input/ &
wait
