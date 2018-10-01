# Copyright 2018 Intel Corporation, Inc
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

# Helm Chart for ONAP Hardware Security Components

This includes the following Kubernetes services:

1. dist-center - A service that is used to create and distribute private keys
2. abrmd - A service that manages access to the TPM device

# Service Dependencies

All services depend on AAF