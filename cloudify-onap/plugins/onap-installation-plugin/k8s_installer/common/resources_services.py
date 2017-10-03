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

import subprocess

import cloudify_kubernetes.tasks as kubernetes_plugin
import yaml
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError

import constants
import deployment_result
import time
import ast
import json
import base64

SERVICES_FILE_PARTS_SEPARATOR = '---'


def create_resoruces():
    ctx.logger.info('Creating resources')
    apps_path = _retrieve_root_path()

    if not apps_path:
        ctx.logger.warn(
            'Apps dir is not defined. Skipping!'
        )

        return

    helm_app = ctx.node.properties.get('path', None)

    yaml_file = prepare_content(helm_app)

    yaml_content_parts = yaml_file.split(SERVICES_FILE_PARTS_SEPARATOR)

    for yaml_content_part in yaml_content_parts:
        if yaml_content_part:
            yaml_content = _apply_readiness_workaround(yaml_content_part)
            if yaml_content:
                create_resource(yaml_content)

    ctx.logger.info('Resource created successfully')

def delete_resoruces():

    ctx.logger.info('Deleting resources')
    apps_path = _retrieve_root_path()

    if not apps_path:
        ctx.logger.warn(
            'Apps dir is not defined. Skipping!'
        )
        return

    helm_app = ctx.node.properties.get('path', None)

    yaml_file = prepare_content(helm_app)

    yaml_content_parts = yaml_file.split(SERVICES_FILE_PARTS_SEPARATOR)

    for yaml_content_part in yaml_content_parts:
        if yaml_content_part:
            yaml_content = _apply_readiness_workaround(yaml_content_part)
            if yaml_content:
                delete_resource(yaml_content)

        ctx.logger.info('Resources deleted successfully')


def prepare_content(resource):
    helm_path = _retrieve_helm_cli_path()
    yaml_file = render_chart(resource, _retrieve_root_path(), helm_path)

    return yaml_file


def create_resource(yaml_content_dict):
    ctx.logger.debug("Loading yaml: {}".format(yaml_content_dict))

    if yaml_content_dict.get('kind', '') == 'PersistentVolumeClaim':
        ctx.logger.debug("PersistentVolumeClaim custom handling")
        kubernetes_plugin.custom_resource_create(definition=yaml_content_dict, api_mapping=_get_persistent_volume_mapping_claim_api())
    else:
        kubernetes_plugin.resource_create(definition=yaml_content_dict)

    deployment_result.save_deployment_result('resource_{0}'.format(yaml_content_dict['metadata']['name']))

def delete_resource(yaml_content_dict):
    ctx.logger.debug("Loading yaml: {}".format(yaml_content_dict))

    deployment_result.save_deployment_result('resource_{0}'.format(yaml_content_dict['metadata']['name']))
    if yaml_content_dict.get('kind', '') == 'PersistentVolumeClaim':
        ctx.logger.debug("PersistentVolumeClaim custom handling")
        kubernetes_plugin.custom_resource_delete(definition=yaml_content_dict, api_mapping=_get_persistent_volume_mapping_claim_api())
    else:
        kubernetes_plugin.resource_delete(definition=yaml_content_dict)


def render_chart(app, app_root_path, helm_cli_path):
    app_chart_path = "{}/{}/".format(app_root_path, app)
    ctx.logger.debug('App chart path = {}'.format(app_chart_path))
    return _exec_helm_template(helm_cli_path, app_chart_path)


def _exec_helm_template(helm_path, chart):
    cmd = '{0} template {1}'.format(helm_path, chart)
    ctx.logger.debug('Executing helm template cmd: {}'.format(cmd))
    rendered = subprocess.Popen(cmd.split(" "), stdout=subprocess.PIPE).stdout.read().decode()

    return rendered

def _get_persistent_volume_mapping_claim_api():
    api_mapping = {
      'create' : {
        'api': 'CoreV1Api',
        'method': 'create_namespaced_persistent_volume_claim',
        'payload': 'V1PersistentVolumeClaim'
      },
      'read' : {
        'api': 'CoreV1Api',
        'method': 'read_namespaced_persistent_volume_claim',
      },
      'delete': {
        'api': 'CoreV1Api',
        'method': 'delete_namespaced_persistent_volume_claim',
        'payload': 'V1DeleteOptions'
      }
    }

    return api_mapping


def _apply_readiness_workaround(yaml_file):
    b64_env = _get_k8s_b64_env()

    input_dict = yaml.load(yaml_file)

    try:
        init_containers = input_dict['spec']['template']['metadata']['annotations'][
            'pod.beta.kubernetes.io/init-containers']
        init_cont_list = eval(init_containers)

        new_init_cont_list = list()
        new_cont = None
        for init_cont in init_cont_list:
            if "oomk8s/readiness-check" in init_cont['image']:
                init_cont['image'] = "clfy/oomk8s-cfy-readiness-check:1.0.1"
                #init_cont['imagePullPolicy'] = "IfNotPresent"
                init_cont['env'].append(b64_env)
                new_cont = init_cont
                new_init_cont_list.append(json.dumps(init_cont))

        new_payload = ",".join(new_init_cont_list)

        if new_cont:
            input_dict['spec']['template']['metadata']['annotations'].pop('pod.beta.kubernetes.io/init-containers')
            input_dict['spec']['template']['metadata']['annotations']['pod.beta.kubernetes.io/init-containers'] = '[{}]'.format(new_payload)


    except KeyError as ke:
        ctx.logger.debug('Readiness section is not found.')

    return input_dict


def _get_k8s_b64():
    target_relationship = _retrieve_managed_by_master()

    k8s_config = target_relationship.node.properties.get('configuration').get('file_content')

    if not k8s_config:
        raise Exception("Cannot find kubernetes config")

    k8s_config_plain = yaml.dump(k8s_config, allow_unicode=True)

    k8s_config_b64 = base64.b64encode(k8s_config_plain)

    return k8s_config_b64


def _get_k8s_b64_env():
    env = dict()
    env['name'] = 'K8S_CONFIG_B64'
    env['value'] = _get_k8s_b64()
    return env


def _retrieve_root_path():
    target_relationship = _retrieve_depends_on()

    apps_root_path = target_relationship.instance.runtime_properties.get(constants.RT_APPS_ROOT_PATH, None)

    ctx.logger.debug("Retrived apps root path = {}".format(apps_root_path))

    return apps_root_path

def _retrieve_helm_cli_path():
    target_relationship = _retrieve_depends_on()

    helm_cli_path = target_relationship.instance.runtime_properties.get(constants.RT_HELM_CLI_PATH, None)

    ctx.logger.debug("Retrived helm clis path = {}".format(helm_cli_path))

    return helm_cli_path

def _retrieve_depends_on():
    result = None
    for relationship in ctx.instance.relationships:
        if relationship.type == 'cloudify.relationships.depends_on':
            return relationship.target

def _retrieve_managed_by_master():
    result = None
    for relationship in ctx.instance.relationships:
        if relationship.type == 'cloudify.kubernetes.relationships.managed_by_master':
            return relationship.target
