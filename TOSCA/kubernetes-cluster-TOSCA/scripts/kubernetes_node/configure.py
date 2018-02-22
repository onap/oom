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

# Afther K8s master up and running. This script will be triggered in each worker nodes. It will join the nodes, and mount the NFS directory.

import subprocess
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError

START_COMMAND = 'sudo kubeadm join --token {0} {1}:{2}'


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


if __name__ == '__main__':

    hostname = execute_command('hostname')
    ctx.instance.runtime_properties['hostname'] = hostname.rstrip('\n')

    # Get the master cluster info.
    masters = \
        [x for x in ctx.instance.relationships if
         x.target.instance.runtime_properties.get(
             'KUBERNETES_MASTER', False)]
    if len(masters) != 1:
        raise NonRecoverableError(
            'Currently, a Kubernetes node must have a '
            'dependency on one Kubernetes master.')
    master = masters[0]
    bootstrap_token = \
        master.target.instance.runtime_properties['bootstrap_token']
    master_ip = \
        master.target.instance.runtime_properties['master_ip']
    master_port = \
        master.target.instance.runtime_properties['master_port']

    # Join the cluster.
    cniCommand1=subprocess.Popen(["sudo", "sysctl", 'net.bridge.bridge-nf-call-iptables=1'], stdout=subprocess.PIPE)
    join_command = \
        'sudo kubeadm join --token {0} {1}:{2}'.format(
            bootstrap_token, master_ip, master_port)
    execute_command(join_command)

    #mount
    mount_command=\
        'sudo mount -t nfs -o proto=tcp,port=2049 {0}:/dockerdata-nfs /dockerdata-nfs'.format(master_ip)
    execute_command(mount_command)