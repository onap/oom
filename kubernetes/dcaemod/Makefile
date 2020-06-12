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
make-dcaemod: make-dcaemod-distributor-api make-dcaemod-genprocessor make-dcaemod-designtool make-dcaemod-onboarding-api make-dcaemod-runtime-api make-dcaemod-nifi-registry make-dcaemod-healthcheck

make-dcaemod-distributor-api:
	cd components && helm dep up dcaemod-genprocessor && helm lint dcaemod-genprocessor

make-dcaemod-genprocessor:
	cd components && helm dep up dcaemod-distributor-api && helm lint dcaemod-distributor-api

make-dcaemod-designtool:
	cd components && helm dep up dcaemod-designtool && helm lint dcaemod-designtool

make-dcaemod-onboarding-api:
	cd components && helm dep up dcaemod-onboarding-api && helm lint dcaemod-onboarding-api

make-dcaemod-runtime-api:
	cd components && helm dep up dcaemod-runtime-api && helm lint dcaemod-runtime-api

make-dcaemod-nifi-registry:
	cd components && helm dep up dcaemod-nifi-registry && helm lint dcaemod-nifi-registry

make-dcaemod-healthcheck:
	cd components && helm dep up dcaemod-healthcheck && helm lint dcaemod-healthcheck

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
