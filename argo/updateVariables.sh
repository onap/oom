#!/bin/bash

# directories to patch
DIRS=("argocd" "infra" "onap" "onap-test")

# Variables and Replacements (Key=Variable, Value=Replacement)
# Beispiel: VAR1="Wert1", VAR2="Wert2"
declare -A VARS
VARS["ONAP_ARGO_REPO_URL"]="https://git.onap.org/oom"
VARS["ONAP_ARGO_BRANCH"]="master"
VARS["STORAGECLASS"]="cinder-os"
VARS["BASEURL"]="simpledemo.onap.org"
VARS["POSTADDR"]="-test"
VARS["DOCKER_REPO"]="docker.io"
VARS["ONAP_REPO"]="nexus3.onap.org:10001"
VARS["ELASTIC_REPO"]="docker.elastic.co"
VARS["QUAY_REPO"]="quay.io"
VARS["GOOGLE_REPO"]="gcr.io"
VARS["K8S_REPO"]="registry.k8s.io"
VARS["GITHUB_REPO"]="ghcr.io"

# Funktion to replace in one file
replace_in_file() {
  local file="$1"
  local tmpfile="${file}.tmp"

  cp "$file" "$tmpfile"

  for var in "${!VARS[@]}"; do
    # Replace <VAR> with value
    # -i: inplace, but done with tmpfile, if Backup is required
    sed -i "s|<${var}>|${VARS[$var]}|g" "$tmpfile"
  done

  mv "$tmpfile" "$file"
}

# Main Loop: Run through all files in the given directories
for dir in "${DIRS[@]}"; do
  # Find all files recursively
  find "$dir" -type f | while read -r file; do
    replace_in_file "$file"
    echo "Done: $file"
  done
done

echo "Done."