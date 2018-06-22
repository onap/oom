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

"""
storage.py

In order to make Django store trusted static files and untrusted media
(user-uploaded) files in separate s3 buckets, we must create two different
storage classes.

https://www.caktusgroup.com/blog/2014/11/10/Using-Amazon-S3-to-store-your-Django-sites-static-and-media-files/
http://www.leehodgkinson.com/blog/my-mezzanine-s3-setup/

"""

# FIXME this module never changes so might not need not be kept in a
# configmap. Also it is (almost) the same as what we use in cms.

# There is a newer storage based on boto3 but that doesn't support changing
# the HOST, as we need to for non-amazon s3 services. It does support an
# "endpoint"; setting AWS_S3_ENDPOINT_URL may cause it to work.
from storages.backends.s3boto import S3BotoStorage
from django.conf import settings


# NOTE for some reason, collectstatic uploads to bucket/location but the
# urls constructed are domain/location
class S3StaticStorage(S3BotoStorage):
    custom_domain = '%s/%s' % (settings.AWS_S3_HOST, settings.STATIC_BUCKET)
    bucket_name = settings.STATIC_BUCKET
    # location = ...


class S3MediaStorage(S3BotoStorage):
    custom_domain = '%s/%s' % (settings.AWS_S3_HOST, settings.MEDIA_BUCKET)
    bucket_name = settings.MEDIA_BUCKET
    # location = ...
