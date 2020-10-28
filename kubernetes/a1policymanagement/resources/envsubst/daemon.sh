#!/bin/sh
{{/*
# Copyright © 2020 Samsung Electronics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

terminate() {
  echo "$(date) | INFO | Terminating child processes"
  pids="$(jobs -p)"
  if [ "$pids" != "" ]; then
    kill -TERM $pids >/dev/null 2>/dev/null
  fi
  wait
}

trap terminate TERM
echo "$(date) | INFO | Started monitoring /config-input/ directory"
inotifyd /tmp/scripts/update_files /config-input/ &
wait
