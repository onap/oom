# Copyright © 2018 Amdocs, AT&T, Bell Canada
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

import os
from pathlib import Path
from awsauth import S3Auth
# A mapping from host names to Requests Authentication Objects; see
# http://docs.python-requests.org/en/master/user/authentication/
AUTHS = {}
if 'S3_HOST' in os.environ:
    AUTHS[os.environ['S3_HOST']] = S3Auth(
        os.environ['AWS_ACCESS_KEY_ID'],
        os.environ['AWS_SECRET_ACCESS_KEY'],
        service_url='https://%s/' % os.environ['S3_HOST']
        )
LOGS_PATH = Path(os.environ['IMAGESCANNER_LOGS_PATH'])
STATUSFILE = LOGS_PATH/'status.txt'
# A dict passed as kwargs to jenkins.Jenkins constructor.
JENKINS = {
  'url': 'http://jenkins:8080',
  'username': 'admin',
  'password': os.environ['SECRET_JENKINS_PASSWORD'],
  }
