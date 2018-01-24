#!/bin/bash -e

# Edit parameters below to specify the address and login to server.
USER=root
PSWD=7SFP7PLVJSD6WJ5znwBPffOKdHuHnrV1oUF7RIT0
HOST=mariadb
PORT=3306
LB_USER=haproxy

ENABLE_LB="UPDATE mysql.user SET User='${LB_USER}' WHERE User='${LB_USER}_blocked';"
DISABLE_LB="UPDATE mysql.user SET User='${LB_USER}_blocked' WHERE User='${LB_USER}';"
MYSQL_CMD="`type -p mysql` -B -u$USER -p$PSWD -h$HOST -P$PORT"

status_update()
{
    echo "SET SESSION wsrep_on=off;"
    echo "$@"
    echo "FLUSH PRIVILEGES;"
}

get_sst_method()
{
    $MYSQL_CMD -s -N -e "SHOW VARIABLES LIKE 'wsrep_sst_method';" | awk '{ print $2 }'
}

while [ $# -gt 0 ]
do
    case $1 in
    --status)
        STATUS=$2
        shift
        ;;
    --uuid)
        CLUSTER_UUID=$2
        shift
        ;;
    --primary)
        [ "$2" = "yes" ] && PRIMARY="1" || PRIMARY="0"
        shift
        ;;
    --index)
        INDEX=$2
        shift
        ;;
    --members)
        MEMBERS=$2
        shift
        ;;
    esac
    shift
done

case $STATUS in
Synced)
    CMD=$ENABLE_LB
    ;;
Donor)
    # enabling donor only if xtrabackup configured
    SST_METHOD=`get_sst_method`
    [[ $SST_METHOD =~ 'xtrabackup' ]] && CMD=$ENABLE_LB || CMD=$DISABLE_LB
    ;;
Undefined)
    # shutting down database: do nothing
    ;;
*)
    CMD=$DISABLE_LB
    ;;
esac

if [ -n "$CMD" ]
then
    status_update "$CMD" | $MYSQL_CMD
fi

exit 0
