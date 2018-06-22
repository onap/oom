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
Django settings for VVP project.

Environment variables that must exist:

    ENVIRONMENT
    SECRET_KEY
    SECRET_WEBHOOK_TOKEN
    SECRET_GITLAB_AUTH_TOKEN
    SECRET_JENKINS_PASSWORD
    SECRET_CMS_APP_CLIENT_ID
    SECRET_CMS_APP_CLIENT_SECRET

Environment variables that must exist in production:

    EMAIL_HOST
    EMAIL_HOST_PASSWORD
    EMAIL_HOST_USER
    EMAIL_PORT

"""

import os
from vvp.settings.envbool import envbool
from corsheaders.defaults import default_headers
from boto.s3.connection import OrdinaryCallingFormat
import datetime

# With this file at ice/settings/__init__.py, we need three applications of
# dirname() to find the project root.
import engagementmanager
PROJECT_PATH = os.path.dirname(os.path.dirname(engagementmanager.__file__))
LOGS_PATH    = os.path.join(PROJECT_PATH, "logs")

ENVIRONMENT = os.environ['ENVIRONMENT']
PROGRAM_NAME_URL_PREFIX = os.environ['PROGRAM_NAME_URL_PREFIX']
SERVICE_PROVIDER = os.environ['SERVICE_PROVIDER']
PROGRAM_NAME = os.environ['PROGRAM_NAME']
SERVICE_PROVIDER_DOMAIN = os.environ['SERVICE_PROVIDER_DOMAIN']

# See https://docs.djangoproject.com/en/1.9/howto/deployment/checklist/
SECRET_KEY = os.environ["SECRET_KEY"]

# https://docs.djangoproject.com/en/1.10/ref/settings/#allowed-hosts
# Anything in the Host header that does not match our expected domain should
# raise SuspiciousOperation exception.
ALLOWED_HOSTS = ['*']

DEBUG = envbool('DJANGO_DEBUG_MODE', False)

if ENVIRONMENT == 'production':
    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    EMAIL_HOST = os.environ['EMAIL_HOST']
    EMAIL_HOST_PASSWORD = os.environ['EMAIL_HOST_PASSWORD']
    EMAIL_HOST_USER = os.environ['EMAIL_HOST_USER']
    EMAIL_PORT = os.environ['EMAIL_PORT']
else:
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Note: Only SSL email backends are allowed
EMAIL_USE_SSL = True

REST_FRAMEWORK = {
    # Use Django's standard `django.contrib.auth` permissions,
    # or allow read-only access for unauthenticated users.
    'EXCEPTION_HANDLER': 'engagementmanager.utils.exception_handler.ice_exception_handler',
    'PAGE_SIZE': 10,
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
        'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
    ),
    'DEFAULT_PARSER_CLASSES': (
        'engagementmanager.rest.parsers.XSSJSONParser',
        'engagementmanager.rest.parsers.XSSFormParser',
        'engagementmanager.rest.parsers.XSSMultiPartParser',
    )
}

JWT_AUTH = {
    'JWT_AUTH_HEADER_PREFIX': 'token',
    'JWT_ALGORITHM': 'HS256',
    'JWT_EXPIRATION_DELTA': datetime.timedelta(days=1),
    'JWT_DECODE_HANDLER': 'engagementmanager.utils.authentication.ice_jwt_decode_handler',
}

APPEND_SLASH = False

# Application definition
INSTALLED_APPS = [
    'django.contrib.auth',          # required by d.c.admin
    'corsheaders',
    'django.contrib.contenttypes',  # required by d.c.admin
    'django.contrib.sessions',      # required by d.c.admin
    'django.contrib.messages',      # required by d.c.admin
    'django.contrib.staticfiles',
    'django.contrib.admin',         # django admin site
    'rest_framework',
    'engagementmanager.apps.EngagementmanagerConfig',
    'validationmanager.apps.ValidationmanagerConfig',
]

MIDDLEWARE_CLASSES = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',          # required by d.c.admin
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',
]

ROOT_URLCONF = 'vvp.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [PROJECT_PATH + '/web/templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',          # required by d.c.admin
                'django.contrib.messages.context_processors.messages',  # required by d.c.admin
            ],
        },
    },
]

WSGI_APPLICATION = 'vvp.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.9/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ['PGDATABASE'],
        'USER': os.environ['PGUSER'],
        'PASSWORD': os.environ['PGPASSWORD'],
        'HOST': os.environ['PGHOST'],
        'PORT': os.environ['PGPORT'],
    }
}


# Password validation
# https://docs.djangoproject.com/en/1.9/ref/settings/#auth-password-validators
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.%s' % s} for s in [
        'UserAttributeSimilarityValidator',
        'MinimumLengthValidator',
        'CommonPasswordValidator',
        'NumericPasswordValidator',
        ]]


# Internationalization
# https://docs.djangoproject.com/en/1.9/topics/i18n/
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True

CORS_ALLOW_HEADERS = default_headers + ('ICE-USER-ID',)

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.9/howto/static-files/
STATIC_ROOT = os.environ['STATIC_ROOT']


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {  # All possible attributes are: https://docs.python.org/3/library/logging.html#logrecord-attributes
        'verbose': {
            'format': '%(asctime)s %(levelname)s %(name)s %(module)s %(lineno)d %(process)d %(thread)d %(message)s'
        },
        'simple': {
            'format': '%(asctime)s %(levelname)s %(name)s %(message)s'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'vvp-info.log': {
            'level': 'INFO',  # handler will ignore DEBUG (only process INFO, WARN, ERROR, CRITICAL, FATAL)
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_PATH, 'vvp-info.log'),
            'formatter': 'verbose'
        },
        'vvp-debug.log': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_PATH, 'vvp-debug.log'),
            'formatter': 'verbose'
        },
        'vvp-requests.log': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_PATH, 'vvp-requests.log'),
            'formatter': 'verbose'
        },
        'vvp-db.log': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_PATH, 'vvp-db.log'),
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'vvp.logger': {
            'handlers': ['vvp-info.log', 'vvp-debug.log', 'vvp-requests.log', 'vvp-db.log', 'console'],
            'level': 'DEBUG' if DEBUG else 'INFO',
        },
        'django': {
            'handlers': ['console'],
            'level': 'INFO' if DEBUG else 'ERROR',
        },
        'django.request': {
            'handlers': ['vvp-requests.log', 'console'],
            'level': 'INFO' if DEBUG else 'ERROR',
        },
        'django.db.backends': {
            'handlers': ['vvp-db.log', 'console'],
            'level': 'DEBUG' if DEBUG else 'ERROR',
            'propagate': False,
        },
        # silence the hundred lines of useless "missing variable in template"
        # complaints per admin pageview.
        'django.template': {
            'level': 'DEBUG',
            'handlers': ['vvp-info.log', 'vvp-debug.log', 'console'],
            'propagate': False,
        },
    }
}


#############################
# VVP Related Configuration
#############################
CONTACT_FROM_ADDRESS =  os.getenv('CONTACT_FROM_ADDRESS', 'dummy@example.com')
CONTACT_EMAILS = [s.strip() for s in os.getenv('CONTACT_EMAILS', 'user@example.com').split(',') if s]
DOMAIN = os.getenv('EM_DOMAIN_NAME')
TOKEN_EXPIRATION_IN_HOURS = 48
DAILY_SCHEDULED_JOB_HOUR = 20
NUMBER_OF_POLLED_ACTIVITIES = 5
TEMP_PASSWORD_EXPIRATION_IN_HOURS = 48
# This is the DNS name pointing to the private-network ip of the host machine
# running (a haproxy that points to) (an nginx frontend for) this app
API_DOMAIN = 'em'

# The authentication token needed by Jenkins or Gitlab to issue webhook updates
# to us. This is a "secret" shared by Jenkins and Django. It must be part of
# the URL path component for the Jenkins webhook in ValidationManager to accept
# a notification. It should be a set of random URL-path-safe characters, with
# no slash '/'.
# FIXME: Does this authentication scheme actually gain us anything? What's the
# threat model
WEBHOOK_TOKEN = os.environ['SECRET_WEBHOOK_TOKEN']

# The authentication token and URL needed for us to issue requests to the GitLab API.
GITLAB_TOKEN = os.environ['SECRET_GITLAB_AUTH_TOKEN']
GITLAB_URL = "http://vvp-gitlab/"

JENKINS_URL = "http://vvp-jenkins:8080/"
JENKINS_USERNAME = "admin"
JENKINS_PASSWORD = os.environ['SECRET_JENKINS_PASSWORD']

IS_CL_CREATED_ON_REVIEW_STATE = envbool('IS_CL_CREATED_ON_REVIEW_STATE', False)  # Options: True, False
IS_SIGNAL_ENABLED = envbool('IS_SIGNAL_ENABLED', True)
RECENT_ENG_TTL = 3  # In days
CMS_URL = "http://cms-uwsgi/api/"
CMS_APP_CLIENT_ID = os.environ['SECRET_CMS_APP_CLIENT_ID']
CMS_APP_CLIENT_SECRET = os.environ['SECRET_CMS_APP_CLIENT_SECRET']

# slack integration
SLACK_API_TOKEN = os.environ['SLACK_API_TOKEN']
ENGAGEMENTS_CHANNEL = os.getenv('ENGAGEMENTS_CHANNEL', '')
ENGAGEMENTS_NOTIFICATIONS_CHANNEL = os.getenv('ENGAGEMENTS_NOTIFICATIONS_CHANNEL:', '')
DEVOPS_CHANNEL = os.getenv('DEVOPS_CHANNEL', '')
DEVOPS_NOTIFICATIONS_CHANNEL = os.getenv('DEVOPS_NOTIFICATIONS_CHANNEL', '')

# S3 configuration for static resources storage and media upload

# used by our custom storage.py
MEDIA_BUCKET = "em-media"
STATIC_BUCKET = "em-static"

# django-storages configuration
AWS_S3_HOST = os.environ['S3_HOST']
AWS_S3_PORT = int(os.environ['S3_PORT'])
AWS_S3_CUSTOM_DOMAIN = os.environ['S3_HOST']
AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']
AWS_AUTO_CREATE_BUCKET = True
AWS_PRELOAD_METADATA = True

# Set by custom subclass.
# AWS_STORAGE_BUCKET_NAME = "em-static"
AWS_S3_CALLING_FORMAT = OrdinaryCallingFormat()
DEFAULT_FILE_STORAGE = 'vvp.settings.storage.S3MediaStorage'
STATICFILES_STORAGE = 'vvp.settings.storage.S3StaticStorage'

# These seem to have no effect even when we don't override with custom_domain?
STATIC_URL = 'https://%s/%s/' % (AWS_S3_CUSTOM_DOMAIN, STATIC_BUCKET)
MEDIA_URL = 'https://%s/%s/' % (AWS_S3_CUSTOM_DOMAIN, MEDIA_BUCKET)

STATIC_ROOT = os.environ['STATIC_ROOT']
