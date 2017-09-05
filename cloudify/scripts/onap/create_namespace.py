import pip

from cloudify import ctx
from cloudify.exceptions import NonRecoverableError


def _import_or_install():
    try:
        import yaml
    except ImportError:
        pip.main(["install", "pyaml"])

    try:
        import cloudify_kubernetes.tasks as kubernetes_plugin
    except ImportError:
        pip.main([
            "install",
            "https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/archive/1.2.1rc1.zip"
        ])

    import yaml
    import cloudify_kubernetes.tasks as kubernetes_plugin

    return yaml, kubernetes_plugin


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


def _save_deployment_result(key):
    result = ctx.instance.runtime_properties['kubernetes']
    ctx.instance.runtime_properties[key] = result
    ctx.instance.runtime_properties['kubernetes'] = {}


def _do_create_namespace(kubernetes_plugin):
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
    _save_deployment_result('namespace')
    ctx.logger.info('Namespace created successfully')


if __name__ == '__main__':
    _, kubernetes_plugin = _import_or_install()

    _do_create_namespace(kubernetes_plugin)
