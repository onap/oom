# Copyright © 2018 Amdocs, Bell Canada
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

# BEGIN Store prev
BD=/opt/app/osaaf/backup
if [ -e "$BD/6day" ]; then
   rm -Rf $BD/6day
fi

PREV=$BD/6day
for D in $BD/5day $BD/4day $BD/3day $BD/2day $BD/yesterday; do
   if [ -e "$D" ]; then
      mv "$D" "$PREV"
   fi
   PREV="$D"
done

if [ -e "$BD/today" ]; then
    if [ -e "$BD/backup.log" ]; then
	mv $BD/backup.log $BD/today
    fi
    gzip $BD/today/*
    mv $BD/today $BD/yesterday
fi

mkdir $BD/today

# END Store prev
date
docker exec -t aaf_cass bash -c "mkdir -p /opt/app/cass_backup"
docker container cp $BD/cbackup.sh aaf_cass:/opt/app/cass_backup/backup.sh
# echo "login as Root, then run \nbash /opt/app/cass_backup/backup.sh"
docker exec -t aaf_cass bash /opt/app/cass_backup/backup.sh
docker container cp aaf_cass:/opt/app/cass_backup/. $BD/today
date
