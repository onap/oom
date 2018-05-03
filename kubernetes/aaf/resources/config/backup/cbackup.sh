cd /opt/app/cass_backup
DATA="ns role perm ns_attrib user_role cred cert x509 delegate approval approved future notify artifact health history"
PWD=cassandra
CQLSH="cqlsh -u cassandra -k authz -p $PWD"
for T in $DATA ; do
    echo "Creating $T.dat"
    $CQLSH -e  "COPY authz.$T TO '$T.dat' WITH DELIMITER='|'"
done
