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


def _save_deployment_result(key):
    result = ctx.instance.runtime_properties['kubernetes']
    ctx.instance.runtime_properties[key] = result
    ctx.instance.runtime_properties['kubernetes'] = {}


def _do_create_init_pod(kubernetes_plugin, yaml):
    ctx.logger.info('Creating init pod')
    init_pod_file_path = _retrieve_path()

    if not init_pod_file_path:
        raise NonRecoverableError('Init pod file is not defined.')

    temp_file_path = ctx.download_resource_and_render(
        init_pod_file_path
    )

    with open(temp_file_path) as temp_file:
        init_pod_file_content = temp_file.read()
        init_pod_yaml_content = yaml.load(init_pod_file_content)

        kubernetes_plugin.resource_create(definition=init_pod_yaml_content)
        _save_deployment_result('init_pod')

    ctx.logger.info('Init pod created successfully')


if __name__ == '__main__':
    yaml, kubernetes_plugin = _import_or_install()

    _do_create_init_pod(kubernetes_plugin, yaml)

