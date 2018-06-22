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
