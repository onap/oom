COUNT=0

sleep 5;
while [ $COUNT -lt 12 ]; do 

curl -X POST \
  http://oof-has-music:8080/MUSIC/rest/v2/keyspaces/conductor_ikram/tables/plans/rows/ \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 502781e8-d588-475d-b181-c2e26625ac95' \
  -H 'X-minorVersion: 3' \
  -H 'X-patchVersion: 0' \
  -H 'ns: conductor' \
  -H 'password: c0nduct0r' \
  -H 'userId: conductor' \
  -d '{
    "consistencyInfo": {
        "type": "eventual"
    },
    "values": {
        "id" : "healthcheck",
        "created": 1479482603641,
        "message": "",
        "name": "foo",
        "recommend_max": 1,
        "solution": "{\"healthcheck\": \" healthcheck\"}",
        "status": "solved",
        "template": "{\"healthcheck\": \"healthcheck\"}",
        "timeout": 3600,
        "translation": "{\"healthcheck\": \" healthcheck\"}",
        "updated": 1484324150629
    }
}
'
  sleep 1;
  COUNT = COUNT+1
done



