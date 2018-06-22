import os
from datetime import datetime

# With this file at web/settings/__init__.py, we need three applications of
# dirname() to find the project root.
PROJECT_PATH = os.path.realpath(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
LOGS_PATH    = os.path.join(PROJECT_PATH, "logs")

ICE_ENVIRONMENT = os.environ['ICE_ENVIRONMENT']
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

if ICE_ENVIRONMENT == 'production':
    DEBUG = False

    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    EMAIL_HOST = os.environ.get('ICE_EMAIL_HOST')
    EMAIL_HOST_PASSWORD = os.environ['EMAIL_HOST_PASSWORD']
    EMAIL_HOST_USER = os.environ['EMAIL_HOST_USER']
    EMAIL_PORT = os.environ['EMAIL_PORT']
else:
    DEBUG = True
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'


# Note: Only SSL email backends are allowed
EMAIL_USE_SSL = True

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
    ),
    'PAGE_SIZE': 10,
    # Use Django's standard `django.contrib.auth` permissions,
    # or allow read-only access for unauthenticated users.
    'DEFAULT_PERMISSION_CLASSES': ('rest_framework.permissions.IsAdminUser',),
}
APPEND_SLASH = False

# Application definition

INSTALLED_APPS = [

    'django.contrib.auth',
    'django.contrib.contenttypes',  # required by d.c.admin
    'django.contrib.sessions',      # required by d.c.admin
    'django.contrib.messages',      # required by d.c.admin
    'django.contrib.staticfiles',
    'django.contrib.admin',         # django admin site
    'rest_framework',
    'iceci.apps.IceCiConfig',
]

MIDDLEWARE_CLASSES = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'web.urls'

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

WSGI_APPLICATION = 'web.wsgi.application'

# Database
# https://docs.djangoproject.com/en/1.9/ref/settings/#databases

DATABASES = {
    'default': { # CI DB details.
        'NAME': '/app/ice_ci_db.db' ,
        'ENGINE': 'django.db.backends.sqlite3',
        'TEST_NAME': '/app/ice_ci_db.db',
    },
}
SINGLETONE_DB = {
    'default': { # CI DB details.
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('CI_DB_NAME', 'ice_ci_db'),
        'USER': os.environ.get('CI_DB_USER', 'iceci'),
        'PASSWORD': os.environ.get('CI_DB_PASSWORD', 'Aa123456'),
        'HOST': os.environ.get('CI_DB_HOST', 'localhost'),
        'PORT': os.environ.get('CI_DB_PORT', '5433'),
    },
    'em_db': { # ICE DB details.
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('EM_DB_NAME', 'icedb'),
        'USER': os.environ.get('EM_DB_USER', 'iceuser'),
        'PASSWORD': os.environ.get('EM_DB_PASSWORD', 'Aa123456'),
        'HOST': os.environ.get('EM_DB_HOST', 'localhost'),
        'PORT': os.environ.get('EM_DB_PORT', '5433'),
    },
    'cms_db': { # ICE CMS details.
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('CMS_DB_NAME', 'icecmsdb'),
        'USER': os.environ.get('CMS_DB_USER', 'icecmsuser'),
        'PASSWORD': os.environ.get('CMS_DB_PASSWORD', 'Aa123456'),
        'HOST': os.environ.get('CMS_DB_HOST', 'localhost'),
        'PORT': os.environ.get('CMS_DB_PORT', '5433'),
    }
}

# Password validation
# https://docs.djangoproject.com/en/1.9/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/1.9/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = False


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.9/howto/static-files/
STATIC_ROOT = os.environ['STATIC_ROOT']
STATIC_URL = '/static/'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {  # All possible attributes are: https://docs.python.org/3/library/logging.html#logrecord-attributes
        'verbose': {
            'format': '%(asctime)s %(levelname)s %(module)s %(filename)s:%(lineno)d %(process)d %(thread)d %(message)s'
        },
        'simple': {
            'format': '%(asctime)s %(levelname)s %(filename)s:%(lineno)d  %(message)s'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'file1': {
            'level': 'INFO',  # handler will ignore DEBUG (only process INFO, WARN, ERROR, CRITICAL, FATAL)
            'class': 'logging.FileHandler',
            'filename': os.environ.get('ICE_ICE_LOGGER_PATH', LOGS_PATH) + 'vvp-info.log',
            'formatter': 'verbose'
        },
        'file2': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': os.environ.get('ICE_ICE_LOGGER_PATH', LOGS_PATH) + 'vvp-debug.log',
            'formatter': 'verbose'
        },
        'file3': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': os.environ.get('ICE_ICE_LOGGER_PATH', LOGS_PATH) + 'vvp-requests.log',
            'formatter': 'verbose'
        },
        'file4': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': os.environ.get('ICE_ICE_LOGGER_PATH', LOGS_PATH) + 'vvp-db.log',
            'formatter': 'verbose'
        }
    },
    'loggers': {
        'vvp-ci.logger': {
            'handlers': ['file1', 'file2', 'file3', 'file4','console'],
            'level': os.getenv('ICE_ICE_LOGGER_LEVEL', 'DEBUG'),
        },
        'django': {
            'handlers': ['console'],
            'level': os.getenv('ICE_DJANGO_LOGGER_LEVEL', 'DEBUG'),
        },
        'django.request': {
            'handlers': ['file3'],
            'level': os.getenv('ICE_ICE_REQUESTS_LOGGER_LEVEL', 'ERROR'),
        },
        'django.db.backends': {
            'handlers': ['file4'],
            'level': os.getenv('ICE_ICE_DB_LOGGER_LEVEL', 'ERROR'),
        }
    }
}


#############################
# ICE-CI Related Configuration
#############################
ICE_CONTACT_FROM_ADDRESS = os.getenv('ICE_CONTACT_FROM_ADDRESS')
ICE_CONTACT_EMAILS = list(os.getenv('ICE_CONTACT_EMAILS','user@example.com').split(','))
ICE_CI_ENVIRONMENT_NAME = os.getenv('ICE_CI_ENVIRONMENT_NAME', 'Dev') # Dev / Docker / Staging
ICE_EM_URL = "{domain}/{prefix}".format(domain=os.environ['ICE_EM_DOMAIN_NAME'], prefix=PROGRAM_NAME_URL_PREFIX)
ICE_PORTAL_URL = os.environ['ICE_DOMAIN']
EM_REST_URL = ICE_EM_URL + '/v1/engmgr/'

#Number of test results presented in admin page. Illegal values: '0' or 'Null'
NUMBER_OF_TEST_RESULTS = int(os.getenv('NUMBER_OF_TEST_RESULTS', '30'))
ICE_BUILD_REPORT_NUM = os.getenv('ICE_BUILD_REPORT_NUM',"{:%Y-%m-%d-%H-%M-%S}".format(datetime.now()))
IS_JUMP_STATE=os.getenv('IS_JUMP_STATE', "True")
DATABASE_TYPE = 'sqlite'

# FIXME: Does this authentication scheme actually gain us anything? What's the
# threat model
WEBHOOK_TOKEN = os.environ['SECRET_WEBHOOK_TOKEN']

# The authentication token and URL needed for us to issue requests to the GitLab API.
GITLAB_TOKEN = os.environ['SECRET_GITLAB_AUTH_TOKEN']
GITLAB_URL = "http://vvp-gitlab/"

JENKINS_URL = "http://vvp-jenkins:8080/"
JENKINS_USERNAME = "admin"
JENKINS_PASSWORD = os.environ['SECRET_JENKINS_PASSWORD']

AWS_S3_HOST = os.environ['S3_HOST']
AWS_S3_PORT = int(os.environ['S3_PORT'])
AWS_S3_CUSTOM_DOMAIN = os.environ['S3_HOST']
AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']
