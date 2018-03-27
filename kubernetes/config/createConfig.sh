# Copyright © 2017 Amdocs, Bell Canada
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

#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
EOF
}

create_namespace() {
  kubectl create namespace $1
}

create_configuration() {
  create_namespace $1
  helm install . --name "$1-config" --namespace $1 --set nsPrefix=$1
}

#MAINs
NS=

while getopts ":n:u:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

if [[ -z $NS ]]; then
  usage
  exit 1
fi

printf "\n**** Creating configuration for ONAP instance: $NS\n"
create_configuration $NS

printf "**** Done ****\n"
