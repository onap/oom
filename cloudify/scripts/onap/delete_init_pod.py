import pip

from cloudify import ctx
from cloudify.exceptions import NonRecoverableError


SERVICES_FILE_PARTS_SEPARATOR = '---'


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


def _retrieve_path():
    return ctx.node.properties.get('init_pod', None)


def _set_deployment_result(key):
    result = ctx.instance.runtime_properties.pop(key)
    ctx.instance.runtime_properties['kubernetes'] = result


def _do_delete_init_pod(kubernetes_plugin, yaml):
    ctx.logger.info('Deleting init pod')
    init_pod_file_path = _retrieve_path()

    if not init_pod_file_path:
        raise NonRecoverableError('Init pod file is not defined.')

    temp_file_path = ctx.download_resource_and_render(
        init_pod_file_path
    )

    with open(temp_file_path) as temp_file:
        init_pod_file_content = temp_file.read()
        init_pod_yaml_content = yaml.load(init_pod_file_content)

        _set_deployment_result('init_pod')
        kubernetes_plugin.resource_delete(definition=init_pod_yaml_content)

    ctx.logger.info('Init pod deleted successfully')


if __name__ == '__main__':
    yaml, kubernetes_plugin = _import_or_install()

    _do_delete_init_pod(kubernetes_plugin, yaml)

