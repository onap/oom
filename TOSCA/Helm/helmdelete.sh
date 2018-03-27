<<<<<<< b6f89dc0d2b461a7e3f083ebe8936de2bb8e0f6e:TOSCA/Helm/helmdelete.sh
#!/bin/bash
# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2017 AT&T
=======
# Copyright © 2017 AT&T, Amdocs, Bell Canada
>>>>>>> Apache 2 license addition for all configuration:kubernetes/policy/resources/config/opt/policy/config/drools/drools-tweaks.sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
<<<<<<< b6f89dc0d2b461a7e3f083ebe8936de2bb8e0f6e:TOSCA/Helm/helmdelete.sh
#         http://www.apache.org/licenses/LICENSE-2.0
=======
#       http://www.apache.org/licenses/LICENSE-2.0
>>>>>>> Apache 2 license addition for all configuration:kubernetes/policy/resources/config/opt/policy/config/drools/drools-tweaks.sh
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
<<<<<<< b6f89dc0d2b461a7e3f083ebe8936de2bb8e0f6e:TOSCA/Helm/helmdelete.sh
#============LICENSE_END============================================

helm delete $1-$2 --purge
kubectl delete namespace $1-$2
kubectl delete clusterrolebinding $1-$2-admin-binding

=======

#! /bin/bash
>>>>>>> Apache 2 license addition for all configuration:kubernetes/policy/resources/config/opt/policy/config/drools/drools-tweaks.sh

