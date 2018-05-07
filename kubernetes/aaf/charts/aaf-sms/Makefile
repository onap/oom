# Copyright © 2018 Amdocs, Bell, AT&T Intellectual Property.  All rights reserved.
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

make-aaf-sms: make-aaf-sms-quorumclient  make-aaf-sms-vault

make-aaf-sms-quorumclient:
	cd charts && helm dep up aaf-sms-quorumclient && helm lint aaf-sms-quorumclient

make-aaf-sms-vault:
	cd charts && helm dep up aaf-sms-vault && helm lint aaf-sms-vault

clean:
	@find . -type f -name 'requirements.lock' -delete
	@find . -type f -name '*.tgz' -delete
