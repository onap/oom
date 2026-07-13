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

# Find lines containing tabs, excluding Makefiles
tabs_lines=$(git grep -n -I "$(printf '\t')" | grep -v 'Makefile' | cut -f1,2 -d":" || true)

if [ -n "$tabs_lines" ]; then
  printf "\n***** Lines containing tabs *****\n\n"
  echo "$tabs_lines"
  exit 1
fi

exit 0
