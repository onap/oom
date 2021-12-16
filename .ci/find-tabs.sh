#!/bin/sh

# Copyright © 2021 Orange
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

set -e

tabs_lines=""  # Lines containing tabs

for file in $(git grep --cached -Il '' | sed -e 's/^/.\//')
do
  lines=$(grep -ErnIH "\t" "$file" | grep -v Makefile | cut -f-2 -d ":")
  if [ -n "$lines" ]; then
    tabs_lines=$([ -z "$tabs_lines" ] && echo "$lines" || printf "%s\n%s" "$tabs_lines" "$lines")
  fi
done

exit_code=0

# If tabs_lines is not empty, change the exit code to 1 to fail the CI.
if [ -n "$tabs_lines" ]; then
  printf "\n***** Lines containing tabs *****\n\n"
  echo "${tabs_lines}"
  exit_code=1
fi

exit $exit_code
