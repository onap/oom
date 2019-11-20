# Copyright © 2019  AT&T Intellectual Property.  All rights reserved.
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
make-dcaegen2: make-dcae-bootstrap make-dcae-cloudify-manager make-dcae-config-binding-service make-dcae-healthcheck make-dcae-redis make-dcae-servicechange-handler make-dcae-inventory-api make-dcae-deployment-handler make-dcae-policy-handler make-dcae-dashboard

make-dcae-bootstrap:
	cd components && helm dep up dcae-bootstrap && helm lint dcae-bootstrap

make-dcae-cloudify-manager:
	cd components && helm dep up dcae-cloudify-manager && helm lint dcae-cloudify-manager

make-dcae-config-binding-service:
	cd components && helm dep up dcae-config-binding-service && helm lint dcae-config-binding-service

make-dcae-healthcheck:
	cd components && helm dep up dcae-healthcheck && helm lint dcae-healthcheck

make-dcae-redis:
	cd components && helm dep up dcae-redis && helm lint dcae-redis

make-dcae-servicechange-handler:
	cd components && helm dep up dcae-servicechange-handler && helm lint dcae-servicechange-handler

make-dcae-inventory-api:
	cd components && helm dep up dcae-inventory-api && helm lint dcae-inventory-api

make-dcae-deployment-handler:
	cd components && helm dep up dcae-deployment-handler && helm lint dcae-deployment-handler

make-dcae-policy-handler:
	cd components && helm dep up dcae-policy-handler && helm lint dcae-policy-handler

make-dcae-dashboard:
	cd components && helm dep up dcae-dashboard && helm lint dcae-dashboard

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
