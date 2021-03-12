#!/bin/sh

# Copyright 2019 Samsung Electronics Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Gather information on ONAP cluster required by security tests.
# Copy results to Robot pod.
#


TMPDIR='/tmp'
TMPTPL='onap_security'
CSV2JSON='import csv; import json; import sys; print(json.dumps({i[0]: i[1] for i in csv.reader(sys.stdin)}))'
FILTER="$(tr -d [:space:] <<TEMPLATE
{{range .items}}
    {{range.spec.ports}}
        {{if .nodePort}}
            {{.nodePort}}{{','}}{{.name}}{{'\n'}}
        {{end}}
    {{end}}
{{end}}
TEMPLATE)"


setup () {
    export NODEPORTS_FILE="$(mktemp -p ${TMPDIR} ${TMPTPL}XXX)"
}

create_actual_nodeport_json () {
    kubectl get svc -n $NAMESPACE -o go-template="$FILTER" | python3 -c "$CSV2JSON" > "$NODEPORTS_FILE"
}

copy_actual_nodeport_json_to_robot () {
    kubectl cp "$1" "$2/$3:$4"
}

cleanup () {
    rm "$NODEPORTS_FILE"
}


setup
create_actual_nodeport_json
copy_actual_nodeport_json_to_robot "$NODEPORTS_FILE" "$NAMESPACE" "$POD" "$TMPDIR"
cleanup
