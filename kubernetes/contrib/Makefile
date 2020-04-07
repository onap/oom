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

make-contrib: make-contrib-awx make-contrib-netbox make-contrib-ejbca make-contrib-core

make-contrib-awx:
	cd components && helm dep up awx && helm lint awx

make-contrib-ejbca:
	cd components && helm dep up ejbca && helm lint ejbca

make-contrib-netbox:
	cd components && helm dep up netbox && helm lint netbox

make-contrib-core:
	helm dep up . && helm lint .

clean:
	@find . -type f -name '*.tgz' -delete
	@find . -type f -name '*.lock' -delete
