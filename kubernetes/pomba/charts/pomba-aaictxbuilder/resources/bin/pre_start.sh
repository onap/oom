#!/bin/sh

# Get the list of topic from curl ressult
dmaap_mr_host={{ .Values.config.address.message_router_host }}
dmaap_mr_port={{ .Values.config.address.message_router_port }}
temp_output_file=".tmpoutput"
curl -X GET http://$dmaap_mr_host:$dmaap_mr_port/topics  > $temp_output_file

# Test topic POA-AUDIT-INIT
poa_audit_init_topic="POA-AUDIT-INIT"
if grep -iFq "$poa_audit_init_topic" $temp_output_file
then
    # code if found
    echo "$poa_audit_init_topic found."
else
    # code if not found
    echo "$poa_audit_init_topic NOT found."
    curl -X POST -H "content-type: application/json" --data @bogus-empty-event.json http://$dmaap_mr_host:$dmaap_mr_port/events/$poa_audit_init_topic
fi

# Test topic POA-AUDIT-RESULT
poa_audit_result_topic="POA-AUDIT-RESULT"
if grep -iFq "$poa_audit_result_topic" $temp_output_file
then
    # code if found
    echo "$poa_audit_result_topic found."
else
    # code if not found
    echo "$poa_audit_result_topic NOT found."
    curl -X POST -H "content-type: application/json" --data @bogus-empty-event.json http://$dmaap_mr_host:$dmaap_mr_port/events/$poa_audit_result_topic
fi

# Test topic POA-RULE-VALIDATION
poa_rule_validation_topic="POA-RULE-VALIDATION"
if grep -iFq "$poa_rule_validation_topic" $temp_output_file
then
    # code if found
    echo "$poa_rule_validation_topic found."
else
    # code if not found
    echo "$poa_rule_validation_topic NOT found."
    curl -X POST -H "content-type: application/json" --data @bogus-empty-event.json http://$dmaap_mr_host:$dmaap_mr_port/events/$poa_rule_validation_topic
fi

# remove the temp file
rm -f $temp_output_file