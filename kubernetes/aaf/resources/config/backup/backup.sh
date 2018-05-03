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
