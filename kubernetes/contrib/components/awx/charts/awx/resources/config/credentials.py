{{/*
# Copyright © 2019 Bell Canada
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
*/}}

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'awx.main.db.profiled_pg',
        'NAME': "{{ .Values.config.postgresDB }}",
        'USER': "{{ .Values.config.postgresUser }}",
        'PASSWORD': "{{ .Values.config.postgresPassword }}",
        'HOST': "awx-postgresql",
        'PORT': "5432",
    }
}
BROKER_URL = 'amqp://{}:{}@{}:{}/{}'.format(
    "{{ .Values.config.rabbitmqUser }}",
    "{{ .Values.config.rabbitmqPassword }}",
    "localhost",
    "5672",
    "{{ .Values.config.rabbitmqVhost }}")
CHANNEL_LAYERS = {
    'default': {'BACKEND': 'asgi_amqp.AMQPChannelLayer',
                'ROUTING': 'awx.main.routing.channel_routing',
                'CONFIG': {'url': BROKER_URL}}
}