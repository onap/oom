# Copyright © 2019  AT&T Intellectual Property.  All rights reserved.
# Modifications Copyright © 2021 Nokia
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
HELM_BIN := helm

make-dcaegen2: make-dcae-bootstrap make-dcae-cloudify-manager make-dcae-config-binding-service make-dcae-healthcheck make-dcae-servicechange-handler make-dcae-inventory-api make-dcae-deployment-handler make-dcae-policy-handler make-dcae-dashboard make-dcae-ves-openapi-manager

make-dcae-bootstrap:
	cd components && $(HELM_BIN) dep up dcae-bootstrap && $(HELM_BIN) lint dcae-bootstrap

make-dcae-cloudify-manager:
	cd components && $(HELM_BIN) dep up dcae-cloudify-manager && $(HELM_BIN) lint dcae-cloudify-manager

make-dcae-config-binding-service:
	cd components && $(HELM_BIN) dep up dcae-config-binding-service && $(HELM_BIN) lint dcae-config-binding-service

make-dcae-healthcheck:
	cd components && $(HELM_BIN) dep up dcae-healthcheck && $(HELM_BIN) lint dcae-healthcheck

make-dcae-servicechange-handler:
	cd components && $(HELM_BIN) dep up dcae-servicechange-handler && $(HELM_BIN) lint dcae-servicechange-handler

make-dcae-inventory-api:
	cd components && $(HELM_BIN) dep up dcae-inventory-api && $(HELM_BIN) lint dcae-inventory-api

make-dcae-deployment-handler:
	cd components && $(HELM_BIN) dep up dcae-deployment-handler && $(HELM_BIN) lint dcae-deployment-handler

make-dcae-policy-handler:
	cd components && $(HELM_BIN) dep up dcae-policy-handler && $(HELM_BIN) lint dcae-policy-handler

make-dcae-dashboard:
	cd components && $(HELM_BIN) dep up dcae-dashboard && $(HELM_BIN) lint dcae-dashboard

make-dcae-ves-openapi-manager:
	cd components && $(HELM_BIN) dep up dcae-ves-openapi-manager && $(HELM_BIN) lint dcae-dashboard

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
