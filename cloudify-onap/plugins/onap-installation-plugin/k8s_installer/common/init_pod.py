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
import yaml

import constants
import resources_services

SERVICES_FILE_PARTS_SEPARATOR = '---'


def do_create_init_pod():
    ctx.logger.info('Creating init pod')

    yaml_config = resources_services.render_chart(
        ctx.node.properties["init_pod"],
        _retrieve_root_path(),
        _retrieve_helm_cli_path()
    )
    yaml_content_part = yaml_config.split(SERVICES_FILE_PARTS_SEPARATOR)[2]
    enhanced_yaml = _add_openstack_envs(yaml_content_part)

    resources_services.create_resource(enhanced_yaml)

    ctx.logger.info('Init pod created successfully')


def do_delete_init_pod():
    ctx.logger.info('Deleting init pod')

    ctx.logger.info('Init pod deleted successfully')

def _add_openstack_envs(yaml_content):
    input_dict = yaml.load(yaml_content)

    container_dict = input_dict['spec']['containers'][0]
    container_dict.pop('envFrom')

    openstack_envs = ctx.node.properties["openstack_envs"]
    for item in openstack_envs.items():
        ctx.logger.debug("adding item = {}".format(item))
        container_dict['env'].append(item)

    return input_dict

def _retrieve_root_path():
    return ctx.instance.runtime_properties.get(constants.RT_APPS_ROOT_PATH, None)

def _retrieve_helm_cli_path():
    return ctx.instance.runtime_properties.get(constants.RT_HELM_CLI_PATH, None)