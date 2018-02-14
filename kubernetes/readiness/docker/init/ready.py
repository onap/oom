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
coreV1Api = client.CoreV1Api(client.ApiClient(configuration))

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
                    ready = s.ready
                    if not ready:
                        log.info(container_name + " is not ready.")
                    else:
                        log.info(container_name + " is ready!")
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

