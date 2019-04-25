#!/usr/bin/env python
import getopt
import logging
import os
import sys
import time

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
coreV1Api = client.CoreV1Api(client.ApiClient(configuration))
api_instance=client.ExtensionsV1beta1Api(client.ApiClient(configuration))
api = client.AppsV1beta1Api(client.ApiClient(configuration))
batchV1Api = client.BatchV1Api(client.ApiClient(configuration))

def is_job_complete(job_name):
    complete = False
    log.info("Checking if " + job_name + "  is complete")
    response = ""
    try:
        response = batchV1Api.read_namespaced_job_status(job_name, namespace)
        if response.status.succeeded == 1:
            job_status_type = response.status.conditions[0].type
            if job_status_type == "Complete":
                complete = True
                log.info(job_name + " is complete")
            else:
                log.info(job_name + " is not complete")
        else:
            log.info(job_name + " has not succeeded yet")
        return complete
    except Exception as e:
        log.error("Exception when calling read_namespaced_job_status: %s\n" % e)

def wait_for_statefulset_complete(statefulset_name):
    try:
        response = api.read_namespaced_stateful_set(statefulset_name, namespace)
        s = response.status
        if ( s.updated_replicas == response.spec.replicas and
                s.replicas == response.spec.replicas and
                s.ready_replicas == response.spec.replicas and
                s.current_replicas == response.spec.replicas and
                s.observed_generation == response.metadata.generation):
            log.info("Statefulset " + statefulset_name + "  is ready")
            return True
        else:
            log.info("Statefulset " + statefulset_name + "  is not ready")
        return False
    except Exception as e:
        log.error("Exception when waiting for Statefulset status: %s\n" % e)

def wait_for_deployment_complete(deployment_name):
    try:
        response = api.read_namespaced_deployment(deployment_name, namespace)
        s = response.status
        if ( s.unavailable_replicas == None and
                s.updated_replicas == response.spec.replicas and
                s.replicas == response.spec.replicas and
                s.ready_replicas == response.spec.replicas and
                s.observed_generation == response.metadata.generation):
            log.info("Deployment " + deployment_name + "  is ready")
            return True
        else:
            log.info("Deployment " + deployment_name + "  is not ready")
        return False
    except Exception as e:
        log.error("Exception when waiting for deployment status: %s\n" % e)

def is_ready(container_name):
    ready = False
    log.info("Checking if " + container_name + "  is ready")
    try:
        response = coreV1Api.list_namespaced_pod(namespace=namespace, watch=False)
        for i in response.items:
            # container_statuses can be None, which is non-iterable.
            if i.status.container_statuses is None:
                continue
            for s in i.status.container_statuses:
                if s.name == container_name:
                    if i.metadata.owner_references[0].kind  == "StatefulSet":
                        ready = wait_for_statefulset_complete(i.metadata.owner_references[0].name)
                    elif i.metadata.owner_references[0].kind == "ReplicaSet":
                        api_response = api_instance.read_namespaced_replica_set_status(i.metadata.owner_references[0].name, namespace)
                        ready = wait_for_deployment_complete(api_response.metadata.owner_references[0].name)
                    elif i.metadata.owner_references[0].kind == "Job":
                        ready = is_job_complete(i.metadata.owner_references[0].name)

                    return ready

                else:
                    continue
        return ready
    except Exception as e:
        log.error("Exception when calling list_namespaced_pod: %s\n" % e)

DEF_TIMEOUT = 10
DESCRIPTION = "Kubernetes container readiness check utility"
USAGE = "Usage: ready.py [-t <timeout>] -c <container_name> [-c <container_name> ...]\n" \
        "where\n" \
        "<timeout> - wait for container readiness timeout in min, default is " + str(DEF_TIMEOUT) + "\n" \
        "<container_name> - name of the container to wait for\n"

def main(argv):
    # args are a list of container names
    container_names = []
    timeout = DEF_TIMEOUT
    try:
        opts, args = getopt.getopt(argv, "hc:t:", ["container-name=", "timeout=", "help"])
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print("%s\n\n%s" % (DESCRIPTION, USAGE))
                sys.exit()
            elif opt in ("-c", "--container-name"):
                container_names.append(arg)
            elif opt in ("-t", "--timeout"):
                timeout = float(arg)
    except (getopt.GetoptError, ValueError) as e:
        print("Error parsing input parameters: %s\n" % e)
        print(USAGE)
        sys.exit(2)
    if container_names.__len__() == 0:
        print("Missing required input parameter(s)\n")
        print(USAGE)
        sys.exit(2)

    for container_name in container_names:
        timeout = time.time() + timeout * 60
        while True:
            ready = is_ready(container_name)
            if ready is True:
                break
            elif time.time() > timeout:
                log.warning("timed out waiting for '" + container_name + "' to be ready")
                exit(1)
            else:
                time.sleep(5)

if __name__ == "__main__":
    main(sys.argv[1:])

