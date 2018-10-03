# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2018 AT&T
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

from tempfile import NamedTemporaryFile
from fabric.api import get, sudo, run
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError, RecoverableError

CONFIG_PATH = '/etc/cloudify/config.yaml'


def install_rpm(_rpm):
    try:
        sudo("rpm -i {0}".format(_rpm))
    except Exception as e:
        raise NonRecoverableError(str(e))
    return True


def install_requirements():
    try:
        sudo("sudo yum install -y python-backports-ssl_match_hostname "
             "python-setuptools python-backports")
    except Exception as e:
        raise NonRecoverableError(str(e))
    return True


def update_config(private, public, _config_path):
    SED = "sed -i 's|{0}|{1}|g' {2}"

    old_private_ip = "  private_ip: \\x27\\x27"
    new_private_ip = "  private_ip: \\x27{0}\\x27".format(private)

    try:
        sudo(SED.format(old_private_ip, new_private_ip, _config_path))
    except Exception as e:
        raise NonRecoverableError(str(e))

    old_public_ip = "  public_ip: \\x27\\x27"
    new_public_ip = "  public_ip: \\x27{0}\\x27".format(public)

    try:
        sudo(SED.format(old_public_ip, new_public_ip, _config_path))
    except Exception as e:
        raise NonRecoverableError(str(e))

    old_networks = "  networks: {}"
    new_networks = "  networks: {{ \\x27default\\x27: \\x27{0}\\x27, \\x27external\\x27: \\x27{1}\\x27 }}".format(
        private, public)

    try:
        sudo(SED.format(old_networks, new_networks, _config_path))
        sudo("chmod 775 {0}".format(_config_path))
    except Exception as e:
        raise NonRecoverableError(str(e))
    return True


def cfy_install(password, old=False):
    sudo("chmod 777 {0}".format(CONFIG_PATH))

    install_string = 'cfy_manager install'

    if password:
        install_string = \
            install_string + ' ' + '--admin-password {0}'.format(
                password)
    if old:
        install_string = install_string + '  --clean-db'
    elif not old:
        try:
            sudo("sudo yum install -y openssl-1.0.2k")
        except Exception as e:
            raise NonRecoverableError(str(e))

    try:
        run(install_string)
    except Exception as e:
        ctx.logger.error(str(e))
        return False

    sudo("chmod 775 {0}".format(CONFIG_PATH))

    return True


def plugins_upload():
    try:
        run("cfy plugins bundle-upload")
    except Exception as e:
        raise NonRecoverableError(str(e))

    return True


def secrets_create(secret_key, secret_value):
    try:
        run("cfy secrets create {0} -s \"{1}\"".format(
            secret_key, secret_value))
    except Exception as e:
        raise NonRecoverableError(str(e))

    return True


def blueprints_upload(file, name, url):
    try:
        run("cfy blueprints upload -n {0} -b {1} {2}".format(file, name, url))
    except Exception as e:
        raise NonRecoverableError(str(e))

    return True


def create(private_ip,
           public_ip,
           rpm,
           secrets,
           blueprints,
           config_path=CONFIG_PATH,
           password=None,
           **_):
    ctx.logger.info("Installing Cloudify Manager components.")

    try:
        run("echo Hello")
    except Exception as e:
        raise RecoverableError(str(e))

    if not ctx.instance.runtime_properties.get('installed_rpm'):
        install_requirements()
        ctx.instance.runtime_properties['installed_rpm'] = install_rpm(rpm)

    if not ctx.instance.runtime_properties.get('updated_config'):
        ctx.instance.runtime_properties['updated_config'] = \
            update_config(private_ip, public_ip, config_path)

    if 'cfy_installed' not in ctx.instance.runtime_properties:
        cfy_install_output = cfy_install(password)
    else:
        cfy_install_output = cfy_install(password, old=True)

    ctx.instance.runtime_properties['cfy_installed'] = cfy_install_output
    if not cfy_install_output:
        raise RecoverableError('cfy install failed.')

    if not ctx.instance.runtime_properties.get('plugins_uploaded'):
        try:
            run(
                "cfy plugins upload https://nexus.onap.org/content/sites/raw/org.onap.ccsdk.platform.plugins/plugins/helm-3.0.0-py27-none-linux_x86_64.wgn -y https://nexus.onap.org/content/sites/raw/org.onap.ccsdk.platform.plugins/type_files/helm/3.0.0/helm-type.yaml")
        except Exception as e:
            raise NonRecoverableError(str(e))
        ctx.instance.runtime_properties['plugins_uploaded'] = plugins_upload()

    more_secrets = [
        {'key': 'cfy_user', 'value': 'admin'},
        {'key': 'kubernetes_master_port', 'value': 'kubernetes_master_port'},
        {'key': 'kubernetes-admin_client_certificate_data',
         'value': 'kubernetes-admin_client_certificate_data'},
        {'key': 'kubernetes_master_ip', 'value': 'kubernetes_master_ip'},
        {'key': 'kubernetes_certificate_authority_data',
         'value': 'kubernetes_certificate_authority_data'},
        {'key': 'kubernetes-admin_client_key_data',
         'value': 'kubernetes-admin_client_key_data'},
        {'key': 'cfy_password', 'value': password or 'cfy_password'},
        {'key': 'cfy_tenant', 'value': 'default_tenant'},
        {'key': 'kubernetes_token', 'value': 'kubernetes_token'}
    ]
    for ms in more_secrets:
        secrets.append(ms)

    for secret in secrets:
        secrets_create(
            secret.get('key'),
            secret.get('value'))

    for blueprint in blueprints:
        blueprints_upload(
            blueprint.get('file'),
            blueprint.get('name'),
            blueprint.get('url'))

    ctx.logger.info(
        "Initialize your CLI profile: "
        "`cfy profiles use "
        "{0} -u admin -p {1} -t default_tenant`".format(public_ip,
                                                        password or "_"))
    if not password:
        ctx.logger.info(
            "Since you did not provide a password, scroll up though "
            "the execution log and search for \"Manager password is\".")
