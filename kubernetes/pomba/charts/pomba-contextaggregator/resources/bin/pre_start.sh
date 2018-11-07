#!/bin/sh

# Get the list of topic from curl ressult
dmaap_mr_host=message-router
dmaap_mr_port=3904
temp_output_file=".tmpoutput"
curl -X GET http://$dmaap_mr_host:$dmaap_mr_port/topics  > $temp_output_file

# Test topic POA-AUDIT-INIT, POA-AUDIT-RESULT, POA-RULE-VALIDATION
TOPICS="POA-AUDIT-INIT POA-RULE-VALIDATION POA-AUDIT-RESULT"
for i_topic in $TOPICS
do
  echo "Looping ... topic: $i_topic"
  if grep -iFq "$i_topic" $temp_output_file
  then
      # code if found
      echo "$i_topic found."
  else
      # code if not found
      echo "$i_topic NOT found."
      curl -X POST -H "content-type: application/json" --data '{"event":"create topic"}' http://$dmaap_mr_host:$dmaap_mr_port/events/$i_topic
  fi
done

# remove the temp file
rm -f $temp_output_file
