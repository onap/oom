


OUT=$(curl -o /dev/null -s -w "%{http_code}\n"  \
  http://localhost:8080/MUSIC/rest/v2/admin/onboardAppWithMusic \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 705d4a9d-aaf2-40b4-914a-e0ce1a79534c' \
  -d '{
   "appname": "conductor",
   "userId" : "conductor",
   "isAAF"  : false,
   "password" : "c0nduct0r"
}
')

if [ ${OUT} = "200" ]; then
    echo "Success"
    echo 1 > /tmp/onboarded
    exit 0;
else
    echo "Failure"
    exit 1;
fi

