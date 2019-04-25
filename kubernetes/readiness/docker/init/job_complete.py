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
            else:
                log.info(job_name + " is not complete")
        else:
            log.info(job_name + " has not succeeded yet")
        return complete
    except Exception as e:
        log.error("Exception when calling read_namespaced_job_status: %s\n" % e)


DEF_TIMEOUT = 10
DESCRIPTION = "Kubernetes container job complete check utility"
USAGE = "Usage: job_complete.py [-t <timeout>] -j <job_name> [-j <job_name> ...]\n" \
        "where\n" \
        "<timeout> - wait for container job complete timeout in min, default is " + str(DEF_TIMEOUT) + "\n" \
        "<job_name> - name of the job to wait for\n"

def main(argv):
    # args are a list of job names
    job_names = []
    timeout = DEF_TIMEOUT
    try:
        opts, args = getopt.getopt(argv, "hj:t:", ["job-name=", "timeout=", "help"])
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print("%s\n\n%s" % (DESCRIPTION, USAGE))
                sys.exit()
            elif opt in ("-j", "--job-name"):
                job_names.append(arg)
            elif opt in ("-t", "--timeout"):
                timeout = float(arg)
    except (getopt.GetoptError, ValueError) as e:
        print("Error parsing input parameters: %s\n" % e)
        print(USAGE)
        sys.exit(2)
    if job_names.__len__() == 0:
        print("Missing required input parameter(s)\n")
        print(USAGE)
        sys.exit(2)

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