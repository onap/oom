# Copyright © 2018 Amdocs, Bell Canada, AT&T
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

This directory contains all external configuration files that
need to be mounted into an application container.

See the configmap.yaml in the templates directory for an example
of how to load (ie map) config files from this directory, into
Kubernetes, for distribution within the k8s cluster.

See deployment.yaml in the templates directory for an example
of how the 'config mapped' files are then mounted into the
containers.
