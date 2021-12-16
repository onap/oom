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

set -eu

if ! which checkbashisms >/dev/null && ! sudo yum install devscripts-minimal && ! sudo apt-get install devscripts
then
    printf "checkbashisms command not found - please install it \n\
            (e.g. sudo apt-get install devscripts | yum install devscripts-minimal )\n" >&2
    exit 2
fi

find . -not -path '*/.*' -name '*.sh' -exec checkbashisms {} + || exit 3
find . -not -path '*/.*' -name '*.failover' -exec checkbashisms -f \{\} + || exit 4
! find . -not -path '*/.*' -name '*.sh' -exec grep 'local .*=' {} + || exit 5
! find . -not -path '*/.*' -name '*.failover' -exec grep 'local .*=' {} + || exit 6

exit 0
