#!/bin/sh
/opt/app/policy/bin/prepare_upgrade.sh ${SQL_DB}
/opt/app/policy/bin/db-migrator -s ${SQL_DB} -o upgrade
rc=$?
/opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
exit $rc
