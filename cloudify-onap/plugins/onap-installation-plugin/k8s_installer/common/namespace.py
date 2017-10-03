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

import cloudify_kubernetes.tasks as kubernetes_plugin
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError

import deployment_result


def do_create_namespace():
    namespace = _retrieve_namespace()
    ctx.logger.info('Creating namespace: {0}'.format(namespace))

    namespace_resource_template = _prepare_namespace_resource_template(
        namespace
    )

    ctx.logger.debug(
        'Kubernetes object which will be deployed: {0}'
            .format(namespace_resource_template)
    )

    kubernetes_plugin.custom_resource_create(**namespace_resource_template)
    deployment_result.save_deployment_result('namespace')
    ctx.logger.info('Namespace created successfully')


def do_delete_namespace():
    namespace = _retrieve_namespace()
    ctx.logger.info('Deleting namespace: {0}'.format(namespace))

    namespace_resource_template = _prepare_namespace_resource_template(
        namespace
    )

    ctx.logger.debug(
        'Kubernetes object which will be deleted: {0}'
            .format(namespace_resource_template)
    )

    deployment_result.set_deployment_result('namespace')
    kubernetes_plugin.custom_resource_delete(**namespace_resource_template)
    ctx.logger.info('Namespace deleted successfully')



def _retrieve_namespace():

    default_namespace = ctx.node.properties.get('options', {}).get('namespace')
    namespace = ctx.node.properties.get('namespace', default_namespace)

    if not namespace:
        raise NonRecoverableError(
            'Namespace is not defined (node={})'.format(ctx.node.name)
        )

    return namespace


def _prepare_namespace_resource_template(name):
    return {
        'definition': {
            'apiVersion': 'v1',
            'kind': 'Namespace',
            'metadata': {
                'name': name,
                'labels': {
                    'name': name
                },
            },
        },
        'api_mapping': {
            'create': {
                'api': 'CoreV1Api',
                'method': 'create_namespace',
                'payload': 'V1Namespace'
            },
            'read': {
                'api': 'CoreV1Api',
                'method': 'read_namespace',
            },
            'delete': {
                'api': 'CoreV1Api',
                'method': 'delete_namespace',
                'payload': 'V1DeleteOptions'
            }
        }
    }
