#!/usr/bin/env python

import subprocess
from cloudify import ctx
from cloudify.exceptions import OperationRetry


def check_command(command):

    try:
        process = subprocess.Popen(
            command.split()
        )
    except OSError:
        return False

    output, error = process.communicate()

    ctx.logger.debug('command: {0} '.format(command))
    ctx.logger.debug('output: {0} '.format(output))
    ctx.logger.debug('error: {0} '.format(error))
    ctx.logger.debug('process.returncode: {0} '.format(process.returncode))

    if process.returncode:
        ctx.logger.error('Running `{0}` returns error.'.format(command))
        return False

    return True


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
    ctx.logger.debug('error: {0} '.format(error))
    ctx.logger.debug('process.returncode: {0} '.format(process.returncode))

    if process.returncode:
        ctx.logger.error('Running `{0}` returns error.'.format(_command))
        return False

    return output


if __name__ == '__main__':

    # Check if Docker PS works
    docker = check_command('docker ps')
    if not docker:
            raise OperationRetry(
                'Docker is not present on the system.')
    ctx.logger.info('Docker is present on the system.')

    # Next check if Cloud Init is running.
    finished = False
    ps = execute_command('ps -ef')
    for line in ps.split('\n'):
        if '/usr/bin/python /usr/bin/cloud-init modules' in line:
            raise OperationRetry(
                'You provided a Cloud-init Cloud Config to configure instances. '
                'Waiting for Cloud-init to complete.')
    ctx.logger.info('Cloud-init finished.')
