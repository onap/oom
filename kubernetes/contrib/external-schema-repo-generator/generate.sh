#!/bin/sh

# ============LICENSE_START=======================================================
# VES
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
ARGUMENTS=$#
REPO_URL=$1
BRANCHES=$2
SCHEMAS_LOCATION=$3
VENDOR=$4
CONFIGMAP_FILENAME=$5
CONFIGMAP_NAME=$6
SCHEMA_MAP_FILENAME=$7

# Constants
TMP_LOCATION=tmpRepo
SUCCESS_CODE=0
TREE=tree
EXPECTED_1_ARG=1
EXPECTED_7_ARGS=7
INDENTATION_LEVEL_1=1
INDENTATION_LEVEL_2=2
INDENTATION_LEVEL_3=3
INDENTATION_LEVEL_4=4

# Variables
VALID_BRANCHES=""

# Indents each line of string by adding indentSize*indentString spaces on the beginning
# Optional argument is indentString level, default: 1
# correct usage example:
# echo "Sample Text" | indent 2
indentString() {
  indentSize=2
  indentString=1
  if [ -n "$1" ]; then indentString=$1; fi
  pr -to $(expr "$indentString" \* "$indentSize")
}

# Checks whether number of arguments is valid
# $1 is actual number of arguments
# $2 is expected number of arguments
checkArguments() {
  if [ "$1" -ne "$2" ]; then
    echo "Incorrect number of arguments"
    exit 1
  fi
}

# Clones all branches selected in $BRANCH from $REPO_URL
cloneRepo() {
  for ACTUAL_BRANCH in $BRANCHES; do
    cloneBranch "$ACTUAL_BRANCH"
  done
}

# Clones single branch $1 from $REPO_URL.
# $1 - branch name
cloneBranch() {
  checkArguments $# $EXPECTED_1_ARG
  if [ -d $TMP_LOCATION/"$1" ]; then
    echo "Skipping cloning repository."
    echo "Branch $1 has already been cloned in the directory ./$TMP_LOCATION/$1"
    echo "To redownload branch remove ./$TMP_LOCATION/$1."
  else
    mkdir -p $TMP_LOCATION
    echo "Cloning repository with branch $1"
    git clone --quiet --single-branch --branch "$1" "$REPO_URL" $TMP_LOCATION/"$1" 2> /dev/null
    RESULT=$?
    if [ $RESULT -ne $SUCCESS_CODE ] ; then
      echo "Problem with cloning branch $1."
      echo "Branch $1 will not be added to spec."
#      BRANCHES=("${BRANCHES[@]/$1}")
    else
      VALID_BRANCHES="${VALID_BRANCHES} $1"
    fi
  fi
}

# Creates file with name $CONFIGMAP_FILENAME
# Inserts ConfigMap metadata and sets name as $CONFIGMAP_NAME
addConfigMapMetadata() {
  echo "Creating ConfigMap spec file: $CONFIGMAP_FILENAME"
  cat << EOF > "$CONFIGMAP_FILENAME"
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME
  labels:
    name: $CONFIGMAP_NAME
  namespace: onap
data:
EOF
}

# For each selected branch:
#   clones the branch from repository,
#   adds schemas from branch to ConfigMap spec
# Removes all cloned branches
addSchemas() {
  for ACTUAL_BRANCH in $VALID_BRANCHES; do
    addSchemasFromBranch "$ACTUAL_BRANCH"
  done
}

# Adds schemas from single branch to spec
# $1 - branch name
addSchemasFromBranch() {
  checkArguments $# $EXPECTED_1_ARG
  echo "Adding schemas from branch $1 to spec"
  SCHEMAS=$(ls -g $TMP_LOCATION/$1/$SCHEMAS_LOCATION/*.yaml | awk '{print $NF}')
  for FILENAME in $SCHEMAS; do
    echo "$1-"$(basename "$FILENAME")": |-" | indentString $INDENTATION_LEVEL_1 >> "$CONFIGMAP_FILENAME"
    cat "$FILENAME" | indentString $INDENTATION_LEVEL_2 >> "$CONFIGMAP_FILENAME"
  done
}

# Generates mapping file for collected schemas directly in spec
generateMappingFile() {
  echo "Generating mapping file in spec"
  echo "$SCHEMA_MAP_FILENAME"": |-" | indentString $INDENTATION_LEVEL_1 >> "$CONFIGMAP_FILENAME"
  echo "[" | indentString $INDENTATION_LEVEL_2 >> "$CONFIGMAP_FILENAME"

  for ACTUAL_BRANCH in $VALID_BRANCHES; do
    echo "Adding mappings from branch $ACTUAL_BRANCH"
    addMappingsFromBranch "$ACTUAL_BRANCH"
  done

  truncate -s-2 "$CONFIGMAP_FILENAME"
  echo "" >> "$CONFIGMAP_FILENAME"
  echo "]" | indentString $INDENTATION_LEVEL_2 >> "$CONFIGMAP_FILENAME"
}

# Adds mappings from single branch directly to spec
# $1 - branch name
addMappingsFromBranch() {
  checkArguments $# $EXPECTED_1_ARG
  SCHEMAS=$(ls -g $TMP_LOCATION/$1/$SCHEMAS_LOCATION/*.yaml | awk '{print $NF}' )

  for SCHEMA in $SCHEMAS; do
    REPO_ENDPOINT=$(echo "$REPO_URL" | cut -d/ -f4- | rev | cut -d. -f2- | rev)
    SCHEMA_REPO_PATH=$(echo "$SCHEMA" | cut -d/ -f2-)
    PUBLIC_URL_SCHEMAS_LOCATION=${REPO_URL%.*}
    PUBLIC_URL=$PUBLIC_URL_SCHEMAS_LOCATION/$TREE/$SCHEMA_REPO_PATH
    LOCAL_URL=$VENDOR/$REPO_ENDPOINT/$TREE/$SCHEMA_REPO_PATH

    echo "{" | indentString $INDENTATION_LEVEL_3 >> "$CONFIGMAP_FILENAME"
    echo "\"publicURL\": \"""$PUBLIC_URL""\"," | indentString $INDENTATION_LEVEL_4 >> "$CONFIGMAP_FILENAME"
    echo "\"localURL\": \"""$LOCAL_URL""\"" | indentString $INDENTATION_LEVEL_4 >> "$CONFIGMAP_FILENAME"
    echo "}," | indentString $INDENTATION_LEVEL_3 >> "$CONFIGMAP_FILENAME"
  done
}

# Cleans cloned repositories
cleanTmpRepos() {
  rm -rf $TMP_LOCATION
}

main() {
  checkArguments $ARGUMENTS $EXPECTED_7_ARGS
  cloneRepo
  addConfigMapMetadata
  addSchemas
  generateMappingFile
  cleanTmpRepos
}

main