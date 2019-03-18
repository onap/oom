# Copyright © 2018  AT&T Intellectual Property.  All rights reserved.
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

make-dmaap: make-dmaap-bc make-message-router make-dmaap-dr-node make-dmaap-dr-prov

make-dmaap-bc:
	cd components && helm dep up dmaap-bc && helm lint dmaap-bc

make-message-router:
	cd components && helm dep up message-router && helm lint message-router

make-dmaap-dr-node:
	cd components && helm dep up dmaap-dr-node && helm lint dmaap-dr-node

make-dmaap-dr-prov:
	cd components && helm dep up dmaap-dr-prov && helm lint dmaap-dr-prov

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
