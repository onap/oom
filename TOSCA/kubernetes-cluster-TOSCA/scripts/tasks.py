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

# here we define some tasks

from fabric.api import run


def label_node(labels, hostname):
    if labels:
        label_list = []
        for key, value in labels.items():
            label_pair_string = '%s=%s' % (key, value)
            label_list.append(label_pair_string)
        label_string = ' '.join(label_list)
        command = 'kubectl label nodes %s %s' % (hostname, label_string)
        run(command)


def stop_node(hostname):
    command = 'kubectl drain %s' % (hostname)
    run(command)


def delete_node(hostname):
    command = 'kubectl delete no %s' % (hostname)
    run(command)
