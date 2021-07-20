#!/usr/bin/env python
import getopt
import logging
import os
import sys
import time

from kubernetes import config
from kubernetes.client import Configuration
from kubernetes.client.api import core_v1_api
from kubernetes.client.rest import ApiException
from kubernetes.stream import stream

from kubernetes import client

# extract env variables.
namespace = os.environ['NAMESPACE']
cert = os.environ['CERT']
host = os.environ['KUBERNETES_SERVICE_HOST']
token_path = os.environ['TOKEN']

with open(token_path, 'r') as token_file:
    token = token_file.read().replace('\n', '')

# setup logging
log = logging.getLogger(__name__)
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
handler.setLevel(logging.INFO)
log.addHandler(handler)
log.setLevel(logging.INFO)

configuration = client.Configuration()
configuration.host = "https://" + host
configuration.ssl_ca_cert = cert
configuration.api_key['authorization'] = token
configuration.api_key_prefix['authorization'] = 'Bearer'
configuration.assert_hostname = False
coreV1Api = client.CoreV1Api(client.ApiClient(configuration))
api_instance = client.CoreV1Api(client.ApiClient(configuration))

def run_command( pod_name, command ):
        try:
                exec_command = [
                    '/bin/sh',
                    '-c',
                    command]
                resp = stream(api_instance.connect_get_namespaced_pod_exec, pod_name, namespace,
                      command=exec_command,
                      stderr=True, stdin=False,
                      stdout=True, tty=False)
        except ApiException as e:
                print("Exception when calling CoreV1Api->connect_get_namespaced_pod_exec: %s\n" % e)
                return False
        print(resp)
        return True

def find_pod(container_name,command,pods):
    ready = False
    try:
        response = coreV1Api.list_namespaced_pod(namespace=namespace, watch=False)
        for i in response.items:
            # container_statuses can be None, which is non-iterable.
            if i.status.container_statuses is None:
                continue
            for s in i.status.container_statuses:
                if s.name == container_name:
                    if pods == True:
                       print (i.metadata.name)
                    else:
                       ready = run_command(i.metadata.name,command)
                else:
                    continue
    except Exception as e:
        log.error("Exception when calling list_namespaced_pod: %s\n" % e)

    return ready


DESCRIPTION = "Kubernetes container readiness check utility"
USAGE = "Usage: ready.py [-t <timeout>] -c <container_name> [-c <container_name> ...]\n" \
        "where\n" \
        "<container_name> - name of the container to wait for\n"

def main(argv):
    pods = False
    command = ""
    container_name = ""
    try:
        opts, args = getopt.getopt(argv, "ghp:c:", ["pod-container-name=", "command=", "help","getpods"])
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print("%s\n\n%s" % (DESCRIPTION, USAGE))
                sys.exit()
            elif opt in ("-p", "--pod-container-name"):
                container_name = arg
            elif opt in ("-c", "--command"):
                command = arg
            elif opt in ("-g", "--getpods"):
                pods = True
    except (getopt.GetoptError, ValueError) as e:
        print("Error parsing input parameters: %s\n" % e)
        print(USAGE)
        sys.exit(2)
    if container_name.__len__() == 0:
        print("Missing required input parameter(s)\n")
        print(USAGE)
        sys.exit(2)

    if pods == False:
            if command.__len__() == 0:
                print("Missing required input parameter(s)\n")
                print(USAGE)
                sys.exit(2)
    ready = find_pod(container_name,command,pods)
    if ready == False:
        sys.exit(2)

if __name__ == "__main__":
    main(sys.argv[1:])


