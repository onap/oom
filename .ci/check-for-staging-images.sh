#!/bin/sh

# Copyright © 2020 Samsung Electronics
# Modification copyright © 2021 Orange
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

BASE_URL="https://nexus3.onap.org/repository/docker.release"

USED_IMAGES=$(grep -r -E -o -h ':\s*onap/.*:.*' | sed -e 's/^: //' -e 's/^ //' | sort | uniq)
REPO_IMAGES=$(curl -s $BASE_URL/v2/_catalog | jq -r '.repositories[]')
NOT_AVAILABLE_IMAGES=$(echo "$USED_IMAGES" | grep -vE  "$(echo "$REPO_IMAGES" | tr "\n" "|" | sed 's/|$//')")
USED_IMAGES=$(echo "$USED_IMAGES" | grep -E "$(echo "$REPO_IMAGES" | tr "\n" "|" | sed 's/|$//')")
for i in $USED_IMAGES; do
    TMP_IMG=$(echo "$i" | cut -d ":" -f1)
    TMP_TAG=$(echo "$i" | cut -d ":" -f2)
    if [ "$LAST_IMG" != "$TMP_IMG" ]; then
        AVAILABLE_TAGS=$(curl -s $BASE_URL/v2/$TMP_IMG/tags/list | jq -r '.tags[]')
    fi
    if ! echo "$AVAILABLE_TAGS" | grep "$TMP_TAG" > /dev/null; then
        NOT_AVAILABLE_IMAGES="$NOT_AVAILABLE_IMAGES\n$i"
    fi
    LAST_IMG="$TMP_IMG"
    printf "."
done
printf "\n"
if [ -n "$NOT_AVAILABLE_IMAGES" ]; then
    echo "[ERROR] Only release images are allowed in helm charts."
    echo "[ERROR] Images not found in release repo:"
    printf "%b$NOT_AVAILABLE_IMAGES\n"
    exit 1
fi
exit 0
