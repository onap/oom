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

import urllib
import tarfile
import os
import tempfile
from git import Repo

def get_helm_path(url):
    tarball = _fetch_helm(url)
    helm_dir = _get_tmp_file_name()
    _untar_helm_archive(tarball, helm_dir)
    helm_binary_path = _find_file('helm', helm_dir)
    return helm_binary_path


def get_apps_root_path(git_url):
    dst_repo_path = _get_tmp_file_name()
    Repo.clone_from(git_url, dst_repo_path)
    apps_root = format(dst_repo_path)
    return apps_root

def _fetch_helm(url):
    dst_tar_path = _get_tmp_file_name()

    file = urllib.URLopener()
    file.retrieve(url, dst_tar_path)

    return dst_tar_path

def _untar_helm_archive(tar_path, helm_dir):
    helm_tar = tarfile.open(tar_path)
    helm_tar.extractall(helm_dir)
    helm_tar.close()


def _find_file(filename, base_path):
    for root, dirs, files in os.walk(base_path):
        for name in files:
            if name == filename:
                return os.path.abspath(os.path.join(root, name))

    raise Exception('Cannot find helm binary')


def _get_tmp_file_name():
    return '{}/{}'.format(tempfile._get_default_tempdir(), next(tempfile._get_candidate_names()))


