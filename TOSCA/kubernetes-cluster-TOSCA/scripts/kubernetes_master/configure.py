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

# This script will be executed on Kubernetes master host. It will initialize the master, and install a pod network.

import pwd
import grp
import os
import re
import getpass
import subprocess
from cloudify import ctx
from cloudify.exceptions import OperationRetry
from cloudify_rest_client.exceptions import CloudifyClientError

JOIN_COMMAND_REGEX = '^kubeadm join[\sA-Za-z0-9\.\:\-\_]*'
BOOTSTRAP_TOKEN_REGEX = '[a-z0-9]{6}.[a-z0-9]{16}'
IP_PORT_REGEX = '[0-9]+(?:\.[0-9]+){3}:[0-9]+'
NOT_SHA_REGEX='^(?!.*sha256)'
JCRE_COMPILED = re.compile(JOIN_COMMAND_REGEX)
BTRE_COMPILED = re.compile(BOOTSTRAP_TOKEN_REGEX)
IPRE_COMPILED = re.compile(IP_PORT_REGEX)
SHA_COMPILED=re.compile(NOT_SHA_REGEX)

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


def cleanup_and_retry():
    reset_cluster_command = 'sudo kubeadm reset'
    output = execute_command(reset_cluster_command)
    ctx.logger.info('reset_cluster_command {1}'.format(reset_cluster_command, output))
    raise OperationRetry('Restarting kubernetes because of a problem.')


def configure_admin_conf():
    # Add the kubeadmin config to environment
    agent_user = getpass.getuser()
    uid = pwd.getpwnam(agent_user).pw_uid
    gid = grp.getgrnam('docker').gr_gid
    admin_file_dest = os.path.join(os.path.expanduser('~'), 'admin.conf')

    execute_command('sudo cp {0} {1}'.format('/etc/kubernetes/admin.conf', admin_file_dest))
    execute_command('sudo chown {0}:{1} {2}'.format(uid, gid, admin_file_dest))

    with open(os.path.join(os.path.expanduser('~'), '.bashrc'), 'a') as outfile:
        outfile.write('export KUBECONFIG=$HOME/admin.conf')
    os.environ['KUBECONFIG'] = admin_file_dest


def setup_secrets(_split_master_port, _bootstrap_token):
    master_ip = split_master_port[0]
    master_port = split_master_port[1]
    ctx.instance.runtime_properties['master_ip'] = _split_master_port[0]
    ctx.instance.runtime_properties['master_port'] = _split_master_port[1]
    ctx.instance.runtime_properties['bootstrap_token'] = _bootstrap_token
    from cloudify import manager
    cfy_client = manager.get_rest_client()

    _secret_key = 'kubernetes_master_ip'
    if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
        cfy_client.secrets.create(key=_secret_key, value=master_ip)
    else:
        cfy_client.secrets.update(key=_secret_key, value=master_ip)
    ctx.logger.info('Set secret: {0}.'.format(_secret_key))

    _secret_key = 'kubernetes_master_port'
    if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
        cfy_client.secrets.create(key=_secret_key, value=master_port)
    else:
        cfy_client.secrets.update(key=_secret_key, value=master_port)
    ctx.logger.info('Set secret: {0}.'.format(_secret_key))

    _secret_key = 'bootstrap_token'
    if cfy_client and not len(cfy_client.secrets.list(key=_secret_key)) == 1:
        cfy_client.secrets.create(key=_secret_key, value=_bootstrap_token)
    else:
        cfy_client.secrets.update(key=_secret_key, value=_bootstrap_token)
    ctx.logger.info('Set secret: {0}.'.format(_secret_key))


if __name__ == '__main__':

    ctx.instance.runtime_properties['KUBERNETES_MASTER'] = True
    cniCommand1=subprocess.Popen(["sudo", "sysctl", 'net.bridge.bridge-nf-call-iptables=1'], stdout=subprocess.PIPE)
    # Start Kubernetes Master
    ctx.logger.info('Attempting to start Kubernetes master.')
    start_master_command = 'sudo kubeadm init'
    start_output = execute_command(start_master_command)
    ctx.logger.debug('start_master_command output: {0}'.format(start_output))
    # Check if start succeeded.
    if start_output is False or not isinstance(start_output, basestring):
        ctx.logger.error('Kubernetes master failed to start.')
        cleanup_and_retry()
    ctx.logger.info('Kubernetes master started successfully.')

    # Slice and dice the start_master_command start_output.
    ctx.logger.info('Attempting to retrieve Kubernetes cluster information.')
    split_start_output = \
        [line.strip() for line in start_output.split('\n') if line.strip()]
    del line

    ctx.logger.debug(
        'Kubernetes master start output, split and stripped: {0}'.format(
            split_start_output))
    split_join_command = ''
    for li in split_start_output:
        ctx.logger.debug('li in split_start_output: {0}'.format(li))
        if re.match(JCRE_COMPILED, li):
            split_join_command = re.split('\s', li)
    del li
    ctx.logger.info('split_join_command: {0}'.format(split_join_command))

    if not split_join_command:
        ctx.logger.error('No join command in split_start_output: {0}'.format(split_join_command))
        cleanup_and_retry()

    for li in split_join_command:
        ctx.logger.info('Sorting bits and pieces: li: {0}'.format(li))
        if (re.match(BTRE_COMPILED, li) and re.match(SHA_COMPILED, li)):
            bootstrap_token = li
        elif re.match(IPRE_COMPILED, li):
            split_master_port = li.split(':')
    setup_secrets(split_master_port, bootstrap_token)
    configure_admin_conf()

    weaveCommand1=subprocess.Popen(["kubectl", "version"], stdout=subprocess.PIPE)
    weaveCommand2=subprocess.Popen(["base64"],stdin=weaveCommand1.stdout, stdout=subprocess.PIPE)
    kubever = weaveCommand2.communicate()[0]
    kubever = kubever.replace('\n', '').replace('\r', '')
    ctx.logger.info("kubever :"+kubever)
    weaveURL=('https://cloud.weave.works/k8s/net?k8s-version={0}'.format(kubever))
    ctx.logger.info("weaveURL:" + weaveURL)
    weaveCommand4=subprocess.Popen(["kubectl","apply","-f",weaveURL],stdout=subprocess.PIPE)
    weaveResult= weaveCommand4.communicate()[0]
    ctx.logger.info("weaveResult :"+weaveResult)
