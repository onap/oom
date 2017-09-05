import pip

from cloudify import ctx


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

    try:
        import jinja2
    except ImportError:
        pip.main(["install", "jinja2"])

    import yaml
    import jinja2
    import cloudify_kubernetes.tasks as kubernetes_plugin

    return yaml, kubernetes_plugin, jinja2


def _init_jinja(jinja2):
    return jinja2.Environment(
        loader=jinja2.BaseLoader()
    )


def _render_template(jinja_env, template_content, values):
    template_content = template_content.replace('.Values', 'Values')

    template = jinja_env.from_string(template_content)
    rendered_template = template.render(Values=values)
    return rendered_template


def _retrieve_resources_paths():
    return ctx.node.properties.get('resources', [])


def _retrieve_services_paths():
    return ctx.node.properties.get('services', None)


def _retrieve_values(yaml):
    values_file_path = ctx.node.properties.get('values', None)

    if values_file_path:
        return yaml.load(ctx.get_resource(values_file_path))

    ctx.logger.warn('Values file not found')


def _save_deployment_result(key):
    result = ctx.instance.runtime_properties['kubernetes']
    ctx.instance.runtime_properties[key] = result
    ctx.instance.runtime_properties['kubernetes'] = {}


def _do_create_resources(kubernetes_plugin, yaml, jinja_env, values):
    for path in _retrieve_resources_paths():
        ctx.logger.info('Creating resource defined in: {0}'.format(path))

        template_content = ctx.get_resource(path)
        yaml_content = _render_template(
            jinja_env,
            template_content,
            values
        )
        content = yaml.load(yaml_content)

        kubernetes_plugin.resource_create(definition=content)
        _save_deployment_result(
            'resource_{0}'.format(content['metadata']['name'])
        )

    ctx.logger.info('Resources created successfully')


def _do_create_services(kubernetes_plugin, yaml, jinja_env, values):
    ctx.logger.info('Creating services')
    services_file_path = _retrieve_services_paths()

    if not services_file_path:
        ctx.logger.warn(
            'Service file is not defined. Skipping services provisioning !'
        )

        return

    template_content = ctx.get_resource(services_file_path)
    yaml_content = _render_template(
        jinja_env,
        template_content,
        values
    )

    yaml_content_parts = \
        yaml_content.split(SERVICES_FILE_PARTS_SEPARATOR)

    for yaml_content_part in yaml_content_parts:
        content = yaml.load(yaml_content_part)

        kubernetes_plugin.resource_create(definition=content)
        _save_deployment_result(
            'service_{0}'.format(content['metadata']['name'])
        )

    ctx.logger.info('Services created successfully')


if __name__ == '__main__':
    yaml, kubernetes_plugin, jinja2 = _import_or_install()
    jinja_env = _init_jinja(jinja2)
    values = _retrieve_values(yaml)

    _do_create_resources(kubernetes_plugin, yaml, jinja_env, values)
    _do_create_services(kubernetes_plugin, yaml, jinja_env, values)

