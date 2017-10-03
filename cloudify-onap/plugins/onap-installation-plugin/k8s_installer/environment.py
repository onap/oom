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
from cloudify.decorators import operation

from common import constants
from common import helm
from common import init_pod, namespace


@operation
def create_init_pod(**kwargs):
    init_pod.do_create_init_pod()
    pass


@operation
def create_namespace(**kwargs):
    namespace.do_create_namespace()


@operation
def delete_init_pod(**kwargs):
    init_pod.do_delete_init_pod()


@operation
def delete_namespace(**kwargs):
    namespace.do_delete_namespace()


@operation
def setup_helm_templates(**kwargs):
    helm_url = constants.HELM_URL
    ctx.instance.runtime_properties[constants.RT_HELM_CLI_PATH] = helm.get_helm_path(helm_url)
    ctx.logger.debug('Helm cli path = {}'.format(ctx.instance.runtime_properties[constants.RT_HELM_CLI_PATH]))

    oom_git_url = constants.OOM_GIT_URL
    ctx.instance.runtime_properties[constants.RT_APPS_ROOT_PATH] = helm.get_apps_root_path(oom_git_url)
    ctx.logger.debug('Apps root path = {}'.format(ctx.instance.runtime_properties[constants.RT_APPS_ROOT_PATH]))




