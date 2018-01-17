#!/usr/bin/env python

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
