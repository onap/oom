#!/usr/bin/env python

# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2017 AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#============LICENSE_END============================================

#This script will be execute on master host. This script will check whether Kube-DNS is running, and set secrets in cloudify.

import os
import subprocess
import pip
try:
    import yaml
except ImportError:
    pip.main(['install', 'pyyaml'])
    import yaml

from cloudify import ctx
from cloudify.exceptions import RecoverableError
from cloudify import manager


def execute_command(_command):

    ctx.logger.debug('_command {0}.'.format(_command))

    subprocess_args = {
        'args': _command.split(),
        'stdout': subprocess.PIPE,
        'stderr': subprocess.PIPE
    }

    ctx.logger.debug('subprocess_args {0}.'.format(subprocess_args))

    process = subprocess.Popen(**subprocess_args)
    output, error = process.communicate()

    ctx.logger.debug('command: {0} '.format(_command))
    ctx.logger.debug('output: {0} '.format(output))
    ctx.logger.debug('error: {0} '.format(error))
    ctx.logger.debug('process.returncode: {0} '.format(process.returncode))

    if process.returncode:
        ctx.logger.error('Running `{0}` returns error.'.format(_command))
        return False

    return output


def check_kubedns_status(_get_pods):

    ctx.logger.debug('get_pods: {0} '.format(_get_pods))

    for pod_line in _get_pods.split('\n'):
        ctx.logger.debug('pod_line: {0} '.format(pod_line))
        try:
            _namespace, _name, _ready, _status, _restarts, _age = pod_line.split()
        except ValueError:
            pass
        else:
            if 'kube-dns' in _name and 'Running' not in _status:
                return False
            elif 'kube-dns' in _name and 'Running' in _status:
                return True
    return False


if __name__ == '__main__':

    cfy_client = manager.get_rest_client()

    # Checking if the Kubernetes DNS service is running (last step).
    admin_file_dest = os.path.join(os.path.expanduser('~'), 'admin.conf')
    os.environ['KUBECONFIG'] = admin_file_dest
    get_pods = execute_command('kubectl get pods --all-namespaces')
    if not check_kubedns_status(get_pods):
        raise RecoverableError('kube-dns not Running')

    # Storing the K master configuration.
    kubernetes_master_config = {}
    with open(admin_file_dest, 'r') as outfile:
        try:
            kubernetes_master_config = yaml.load(outfile)
        except yaml.YAMLError as e:
            RecoverableError(
                'Unable to read Kubernetes Admin file: {0}: {1}'.format(
                    admin_file_dest, str(e)))
    ctx.instance.runtime_properties['configuration_file_content'] = \
        kubernetes_master_config

    clusters = kubernetes_master_config.get('clusters')
    _clusters = {}
    for cluster in clusters:
        __name = cluster.get('name')
        _cluster = cluster.get('cluster', {})
        _secret_key = '%s_certificate_authority_data' % __name
        if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
            cfy_client.secrets.create(key=_secret_key, value=_cluster.get('certificate-authority-data'))
            ctx.logger.info('Set secret: {0}.'.format(_secret_key))
        else:
            cfy_client.secrets.update(key=_secret_key, value=_cluster.get('certificate-authority-data'))
        ctx.instance.runtime_properties['%s_certificate_authority_data' % __name] = _cluster.get('certificate-authority-data')
        _clusters[__name] = _cluster
    del __name

    contexts = kubernetes_master_config.get('contexts')
    _contexts = {}
    for context in contexts:
        __name = context.get('name')
        _context = context.get('context', {})
        _contexts[__name] = _context
    del __name

    users = kubernetes_master_config.get('users')
    _users = {}
    for user in users:
        __name = user.get('name')
        _user = user.get('user', {})
        _secret_key = '%s_client_certificate_data' % __name
        if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
            cfy_client.secrets.create(key=_secret_key, value=_user.get('client-certificate-data'))
            ctx.logger.info('Set secret: {0}.'.format(_secret_key))
        else:
            cfy_client.secrets.update(key=_secret_key, value=_user.get('client-certificate-data'))
        _secret_key = '%s_client_key_data' % __name
        if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
            cfy_client.secrets.create(key=_secret_key, value=_user.get('client-key-data'))
            ctx.logger.info('Set secret: {0}.'.format(_secret_key))
        else:
            cfy_client.secrets.update(key=_secret_key, value=_user.get('client-key-data'))
        ctx.instance.runtime_properties['%s_client_certificate_data' % __name] = _user.get('client-certificate-data')
        ctx.instance.runtime_properties['%s_client_key_data' % __name] = _user.get('client-key-data')
        _users[__name] = _user
    del __name

    ctx.instance.runtime_properties['kubernetes'] = {
        'clusters': _clusters,
        'contexts': _contexts,
        'users': _users
    }
