#!/bin/sh

# ============LICENSE_START=======================================================
# OOM
# ================================================================================
# Copyright (C) 2020 Nokia. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================


# Arguments renaming
arguments_number=$#
repo_url=$1
branches=$2
schemas_location=$3
vendor=$4
configmap_filename=$5
configmap_name=$6
snippet_filename=$7

# Constants
SCHEMA_MAP_FILENAME="schema-map.json"
SUCCESS_CODE=0
TREE=tree
EXPECTED_1_ARG=1
EXPECTED_7_ARGS=7
INDENTATION_LEVEL_1=1
INDENTATION_LEVEL_2=2
INDENTATION_LEVEL_3=3
INDENTATION_LEVEL_4=4
INDENTATION_LEVEL_5=5

# Variables
tmp_location=$(mktemp -d)
valid_branches=""

# Indents each line of string by adding indent_size*indent_string spaces on the beginning
# Optional argument is indent_string level, default: 1
# correct usage example:
# echo "Sample Text" | indent_string 2
indent_string() {
  indent_size=2
  indent_string=1
  if [ -n "$1" ]; then indent_string=$1; fi
  pr -to $(expr "$indent_string" \* "$indent_size")
}

# Checks whether number of arguments is valid
# $1 is actual number of arguments
# $2 is expected number of arguments
check_arguments() {
  if [ "$1" -ne "$2" ]; then
    echo "Incorrect number of arguments"
    exit 1
  fi
}

# Clones all branches selected in $BRANCH from $repo_url
clone_repo() {
  for actual_branch in $branches; do
    clone_branch "$actual_branch"
  done
}

# Clones single branch $1 from $repo_url.
# $1 - branch name
clone_branch() {
  check_arguments $# $EXPECTED_1_ARG
  if [ -d $tmp_location/"$1" ]; then
    echo "Skipping cloning repository."
    echo "Branch $1 has already been cloned in the directory ./$tmp_location/$1"
    echo "To redownload branch remove ./$tmp_location/$1."
  else
    echo "Cloning repository from branch $1"
    git clone --quiet --single-branch --branch "$1" "$repo_url" "$tmp_location/$1" 2>/dev/null
    result=$?
    if [ $result -ne $SUCCESS_CODE ] ; then
      echo "Problem with cloning branch $1."
      echo "Branch $1 will not be added to spec."
    else
      valid_branches="${valid_branches} $1"
    fi
  fi
}

# Creates file with name $configmap_filename
# Inserts ConfigMap metadata and sets name as $configmap_name
add_config_map_metadata() {
  echo "Creating ConfigMap spec file: $configmap_filename"
  cat << EOF > "$configmap_filename"
apiVersion: v1
kind: ConfigMap
metadata:
  name: $configmap_name
  labels:
    name: $configmap_name
  namespace: onap
data:
EOF
}

# For each selected branch:
#   clones the branch from repository,
#   adds schemas from branch to ConfigMap spec
add_schemas() {
  for actual_branch in $valid_branches; do
    echo "Adding schemas from branch $actual_branch to spec"
    add_schemas_from_branch "$actual_branch"
  done
}

# Adds schemas from single branch to spec
# $1 - branch name
add_schemas_from_branch() {
  check_arguments $# $EXPECTED_1_ARG
  schemas=$(ls -g $tmp_location/$1/$schemas_location/*.yaml | awk '{print $NF}')
  for schema in $schemas; do
    echo "$1-$(basename $schema): |-" | indent_string $INDENTATION_LEVEL_1
    cat "$schema" | indent_string $INDENTATION_LEVEL_2
  done
} >> "$configmap_filename"

# Generates mapping file for collected schemas directly in spec
generate_mapping_file() {
  echo "Generating mapping file in spec"
  echo "$SCHEMA_MAP_FILENAME"": |-" | indent_string $INDENTATION_LEVEL_1 >> "$configmap_filename"
  echo "[" | indent_string $INDENTATION_LEVEL_2 >> "$configmap_filename"

  for actual_branch in $valid_branches; do
    echo "Adding mappings from branch: $actual_branch"
    add_mappings_from_branch "$actual_branch"
  done

  truncate -s-2 "$configmap_filename"
  echo "" >> "$configmap_filename"
  echo "]" | indent_string $INDENTATION_LEVEL_2 >> "$configmap_filename"
}

# Adds mappings from single branch directly to spec
# $1 - branch name
add_mappings_from_branch() {
  check_arguments $# $EXPECTED_1_ARG
  schemas=$(ls -g $tmp_location/$1/$schemas_location/*.yaml | awk '{print $NF}' )

  for schema in $schemas; do
    repo_endpoint=$(echo "$repo_url" | cut -d/ -f4- | rev | cut -d. -f2- | rev)
    schema_repo_path=$(echo "$schema" | cut -d/ -f4-)
    public_url_schemas_location=${repo_url%.*}
    public_url=$public_url_schemas_location/$TREE/$schema_repo_path
    local_url=$vendor/$repo_endpoint/$TREE/$schema_repo_path

    echo "{" | indent_string $INDENTATION_LEVEL_3 >> "$configmap_filename"
    echo "\"publicURL\": \"$public_url\"," | indent_string $INDENTATION_LEVEL_4 >> "$configmap_filename"
    echo "\"localURL\": \"$local_url\"" | indent_string $INDENTATION_LEVEL_4 >> "$configmap_filename"
    echo "}," | indent_string $INDENTATION_LEVEL_3 >> "$configmap_filename"
  done
}

create_snippet() {
  echo "Generating snippets in file: $snippet_filename"
  generate_entries

  cat << EOF > "$snippet_filename"
Snippets for mounting ConfigMap in DCAE VESCollector Deployment
=========================================================================

## Description
These snippets will override existing in VESCollector schemas and mapping file.

No extra configuration in VESCollector is needed with these snippets.

## Snippets
#### spec.template.spec.containers[0].volumeMounts
\`\`\`
        - mountPath: /opt/app/VESCollector/etc/externalRepo
          name: custom-$vendor-schemas
\`\`\`

#### spec.template.spec.volumes
\`\`\`
      - configMap:
          defaultMode: 420
          items:
          - key: $SCHEMA_MAP_FILENAME
            path: schema-map.json
$schemas_entries
          name: $configmap_name
        name: custom-$vendor-schemas
\`\`\`
EOF
}

generate_entries() {
  for actual_branch in $valid_branches; do
    schemas=$(ls -g $tmp_location/$actual_branch/$schemas_location/*.yaml | awk '{print $NF}')
    for schema in $schemas; do
      repo_endpoint=$(echo "$repo_url" | cut -d/ -f4- | rev | cut -d. -f2- | rev)
      schema_repo_path=$(echo "$schema" | cut -d/ -f4-)

      key="$actual_branch-$(basename "$schema")"
      path=$vendor/$repo_endpoint/$TREE/$schema_repo_path
      schemas_entries="$schemas_entries- key: $key\n  path: $path\n"
    done
  done
  schemas_entries=$(echo "$schemas_entries" | indent_string $INDENTATION_LEVEL_5)
}

# todo add check of global env whether script should be ran
main() {
  check_arguments $arguments_number $EXPECTED_7_ARGS
  clone_repo
  add_config_map_metadata
  add_schemas
  generate_mapping_file
  create_snippet
}

main