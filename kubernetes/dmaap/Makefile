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

make-dmaap: make-bus-controller make-message-router

make-bus-controller: lint-bus-controller
	cd charts && helm dep up dmaap-bus-controller

make-message-router: lint-message-router
	cd charts && helm dep up message-router

lint-bus-controller:
	cd charts && helm lint dmaap-bus-controller

lint-message-router:
	cd charts && helm lint message-router

clean:
	@find . -type f -name '*.tgz' -delete
