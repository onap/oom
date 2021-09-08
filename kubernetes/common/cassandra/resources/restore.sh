#!/bin/sh

# Initialize variables
ss_dir=""
base_db_dir=""
ss_name=""
ss="snapshots"
me=`basename $0`

find_target_table_name ()
{
    dest_path=$1
    keyspace_name=$2
    src_table_name=$3
    find_in_dir=$dest_path/$keyspace_name
    tname_without_uuid=$(echo $src_table_name | cut -d '-' -f 1)
    dest_table_name=$(ls -td -- $find_in_dir/$tname_without_uuid-* | head -n 1 | rev | cut -d'/' -f1 | rev)
    printf $dest_table_name
}

print_usage ()
{
    echo "NAME"
    echo "    Script to restore Cassandra database from Nuvo/Cain snapshot"
    echo "SYNOPSIS"
    echo "    $me [--help|-h] [--base_db_dir|-b] [--snapshot_dir|-s] [--keyspace|-k] [--tag|-t]"
    echo "    MUST OPTIONS: base_db_dir, snapshot_dir, keyspace_name"
    echo "DESCRIPTION"
    echo "    --base_db_dir, -b"
    echo "        Location of running Cassandra database"
    echo "    --snapshot_dir, -s"
    echo "        Snapshot location of Cassandra database taken by Nuvo/Cain"
    echo "    --keyspace, -k"
    echo "        Name of the keyspace to restore"
    echo "EXAMPLE"
    echo "    $me -b /var/lib/cassandra/data -s /root/data.ss -k DISCOVERY_SERVER -t 1234567"
    exit
}
if [ $# -eq  0 ]
then
    print_usage
fi

while [ $# -gt 0 ]
do
key="$1"
shift

case $key in
    -h|--help)
    print_usage
    ;;
    -b|--base_db_dir)
    base_db_dir="$1"
    shift
    ;;
    -s|--snapshot_dir)
    ss_dir="$1"
    shift
    ;;
    -k|--keyspace)
    keyspace_name="$1"
    ;;
    -t|--tag)
    tag_name="$1"
    ;;
    --default)
    DEFAULT=YES
    shift
    ;;
    *)
    # unknown option
    ;;
esac
done

# Validate inputs
if [ "$base_db_dir" = "" ] || [ "$ss_dir" = "" ] || [ "$keyspace_name" = "" ]
then
    echo ""
    echo ">>>>>>>>>>Not all inputs provided, please check usage >>>>>>>>>>"
    echo ""
    print_usage
fi

# Remove commit logs from current data dir
#/var/lib/cassandra/commitlog/CommitLog*.log
find $base_db_dir/../  -name "CommitLog*.log"  -delete

# Remove *.db from current data dir excluding skipped keyspaces
find $base_db_dir/$keyspace_name  -name "*.db"  -delete

# Copy snapshots to data dir
echo "----------db files in snapshots--------------"
dirs_to_be_restored=`ls $ss_dir`
for i in ${dirs_to_be_restored}
do
    src_path=$ss_dir/$i/snapshots/$tag_name
    # Find the destination
    table_name=$i
    dest_table=$(find_target_table_name $base_db_dir $keyspace_name $table_name)
    dest_path=$base_db_dir/$keyspace_name/$dest_table
    # Create keyspace/table directory if not exists
    #if [ ! -d "$dest_path" ]; then
    #    mkdir -p $dest_path
    #fi
    db_files=$(ls $src_path/*.db 2> /dev/null | wc -l)
    if [ $db_files -ne 0 ]
    then
        cp $src_path/*.db $dest_path
        if [ $? -ne 0 ]
        then
            echo "=====ERROR: Unable to restore $src_path/*.db to $dest_path====="
            exit 1
        fi
        echo "=======check $dest_path ==============="
        ls $dest_path
   fi
done
