# Copyright © 2020  AT&T Intellectual Property.  All rights reserved.
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

make-dcaemod: make-dcaemod-distributor-api make-dcaemod-genprocessor make-dcaemod-designtool make-dcaemod-onboarding-api make-dcaemod-runtime-api make-dcaemod-nifi-registry make-dcaemod-healthcheck

make-dcaemod-distributor-api:
	cd components && $(HELM_BIN) dep up dcaemod-genprocessor && $(HELM_BIN) lint dcaemod-genprocessor

make-dcaemod-genprocessor:
	cd components && $(HELM_BIN) dep up dcaemod-distributor-api && $(HELM_BIN) lint dcaemod-distributor-api

make-dcaemod-designtool:
	cd components && $(HELM_BIN) dep up dcaemod-designtool && $(HELM_BIN) lint dcaemod-designtool

make-dcaemod-onboarding-api:
	cd components && $(HELM_BIN) dep up dcaemod-onboarding-api && $(HELM_BIN) lint dcaemod-onboarding-api

make-dcaemod-runtime-api:
	cd components && $(HELM_BIN) dep up dcaemod-runtime-api && $(HELM_BIN) lint dcaemod-runtime-api

make-dcaemod-nifi-registry:
	cd components && $(HELM_BIN) dep up dcaemod-nifi-registry && $(HELM_BIN) lint dcaemod-nifi-registry

make-dcaemod-healthcheck:
	cd components && $(HELM_BIN) dep up dcaemod-healthcheck && $(HELM_BIN) lint dcaemod-healthcheck

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
