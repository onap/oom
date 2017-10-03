########
# Copyright (c) 2017 GigaSpaces Technologies Ltd. All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    * See the License for the specific language governing permissions and
#    * limitations under the License.


from setuptools import setup

try:
    import cloudify_kubernetes
except ImportError:
    import pip
    pip.main(['install', 'https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/archive/1.2.1.zip'])

setup(
    name='onap-installation-plugin',
    version='1.0.0',
    author='',
    author_email='',
    packages=['k8s_installer', 'k8s_installer.common'],
    install_requires=[
        'cloudify-plugins-common>=3.3.1',
        'cloudify-kubernetes-plugin==1.2.1',
        #'/tmp/k8spl/cloudify-kubernetes-plugin'
        'pyyaml',
        'gitpython',
        'paramiko==1.18.3',
        'fabric==1.13.1'
    ]
)
