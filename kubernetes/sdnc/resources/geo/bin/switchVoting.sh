#!/bin/bash

function usage()
{
    echo usage: switchVoting.sh primary\|secondary
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

case "$1" in

primary)
   status=$(curl -u admin:Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U -o /dev/null -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/restconf/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":true}, { "member-name" : "member-2", "voting":true}, { "member-name" : "member-3", "voting":true},{ "member-name" : "member-4", "voting":false},{ "member-name" : "member-5", "voting":false},{ "member-name" : "member-6", "voting":false}] } }' -w "%{http_code}\n" $url 2> /dev/null)
;;

secondary)
   status=$(curl -u admin:Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U -o /dev/null -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/restconf/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":false}, { "member-name" : "member-2", "voting":false}, { "member-name" : "member-3", "voting":false},{ "member-name" : "member-4", "voting":true},{ "member-name" : "member-5", "voting":true},{ "member-name" : "member-6", "voting":true}] } }' -w "%{http_code}\n" $url 2> /dev/null)
;;

*)
   usage
esac

if [ $status -ne 200 ];then
  echo "failure"
else
  echo "success"
fi
