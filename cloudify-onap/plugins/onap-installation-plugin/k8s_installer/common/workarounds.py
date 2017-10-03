########
# Copyright (c) 2017 GigaSpaces Technologies Ltd. All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    * See the License for the specific language governing permissions and
#    * limitations under the License.

from cloudify import ctx
from cloudify.exceptions import NonRecoverableError

from fabric import api as fabric_api

def _retrieve_namespace():
    namespace = ctx.node.properties.get(
        'namespace',
        ctx.node.properties
            .get('options', {})
            .get('namespace', None)
    )

    if not namespace:
        raise NonRecoverableError(
            'Namespace is not defined (node={})'.format(ctx.node.name)
        )

    return namespace


def configure_secret():
    namespace = _retrieve_namespace()
    ctx.logger.info(
        'Configuring docker secrets for namespace: {0}'.format(namespace)
    )

    command = 'kubectl create secret ' \
              'docker-registry onap-docker-registry-key ' \
              '--docker-server=nexus3.onap.org:10001 ' \
              '--docker-username=docker ' \
              '--docker-password=docker ' \
              '--docker-email=email@email.com ' \
              '--namespace={0}'.format(namespace)

    ctx.logger.info('Command "{0}" will be executed'.format(command))

    with fabric_api.settings(
            **ctx.node.properties.get('ssh_credentials')):
        fabric_api.run(command)

    ctx.logger.info('Docker secrets configured successfully')


def _get_fabric_env():
    result = dict()

    result['host_string'] = ctx.node.properties.get('ssh_credentials')['host_string']
    result['user'] = ctx.node.properties.get('ssh_credentials')['user']
    result['key'] = ctx.node.properties.get('ssh_credentials')['key']

    return result
