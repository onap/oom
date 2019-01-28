#!/usr/bin/python
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
batchV1Api = client.BatchV1Api(client.ApiClient(configuration))
api = client.AppsV1beta1Api(client.ApiClient(configuration))

def is_job_complete(job_name):
    complete = False
    log.info("Checking if Job " + job_name + "  is complete")
    response = ""
    try:
        response = batchV1Api.read_namespaced_job_status(job_name, namespace)
        if response.status.succeeded == 1:
            job_status_type = response.status.conditions[0].type
            if job_status_type == "Complete":
                complete = True
            else:
                log.info("Job " + job_name + " is not complete")
        else:
            log.info("Job " + job_name + " has not succeeded yet")
        return complete
    except Exception as e:
        log.error("Exception when calling read_namespaced_job_status: %s\n" % e)

def wait_for_statefulset_complete(statefulset_name):
    log.info("Checking if Statefulset " + statefulset_name + "  is ready")
    try:
        response = api.read_namespaced_stateful_set(statefulset_name, namespace)
        s = response.status
        if ( s.updated_replicas == None and
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
    log.info("Checking if deployment " + deployment_name + "  is ready")
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

DEF_TIMEOUT = 10
DESCRIPTION = "Kubernetes Deployment/Statefulset readiness check utility"
USAGE = "Usage: ready.py [-t <timeout>] -d <deployment_name> [-d <deployment_name> ...] -s <statefulset_name> [-s <statefulset_name> ...]\n" \
        "where\n" \
        "<timeout> - wait for container readiness timeout in min, default is " + str(DEF_TIMEOUT) + "\n" \
        "<deployment_name> - name of the deployment to wait for\n" \
        "<job_name> - name of the job to wait for\n" \
        "<statefulset_name> - name of the statefulset to wait for\n"

def main(argv):
    # args are a list of container names
    statefulset_names = []
    deployment_names = []
    job_names = []
    timeout = DEF_TIMEOUT
    try:
        opts, args = getopt.getopt(argv, "hs:d:j:t:", ["job-name=","deployment-name=", "statefulset-name=","timeout=", "help"])
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print("%s\n\n%s" % (DESCRIPTION, USAGE))
                sys.exit()
            elif opt in ("-d", "--deployment-name"):
                deployment_names.append(arg)
            elif opt in ("-s", "--statefulset-name"):
                statefulset_names.append(arg)
            elif opt in ("-j", "--job-name"):
                job_names.append(arg)
            elif opt in ("-t", "--timeout"):
                timeout = float(arg)
    except (getopt.GetoptError, ValueError) as e:
        print("Error parsing input parameters: %s\n" % e)
        print(USAGE)
        sys.exit(2)
    if ( deployment_names.__len__() == 0 and statefulset_names.__len__() == 0 and job_names.__len__() == 0):
        print("Missing required input parameter(s)\n")
        print(USAGE)
        sys.exit(2)

    for statefulset_name in statefulset_names:
        timeout = time.time() + timeout * 60
        while True:
            ready = wait_for_statefulset_complete(statefulset_name)
            if ready is True:
                break
            elif time.time() > timeout:
                log.warning("timed out waiting for '" + statefulset_name + "' to be ready")
                exit(1)
            else:
                time.sleep(5)

    for deployment_name in deployment_names:
        timeout = time.time() + timeout * 60
        while True:
            ready = wait_for_deployment_complete(deployment_name)
            if ready is True:
                break
            elif time.time() > timeout:
                log.warning("timed out waiting for '" + deployment_name + "' to be ready")
                exit(1)
            else:
                time.sleep(5)

    for job_name in job_names:
        timeout = time.time() + timeout * 60
        while True:
            complete = is_job_complete(job_name)
            if complete is True:
                break
            elif time.time() > timeout:
                log.warning("timed out waiting for '" + job_name + "' to be completed")
                exit(1)
            else:
                time.sleep(5)


if __name__ == "__main__":
    main(sys.argv[1:])

