from fabric.api import run

from cloudify import ctx
from cloudify.exceptions import NonRecoverableError


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
    run(command)

    ctx.logger.info('Docker secrets configured successfully')
