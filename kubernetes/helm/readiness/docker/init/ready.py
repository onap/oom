#!/usr/bin/python
from kubernetes import client, config
import time, argparse, logging, sys, os

#extract env variables.
namespace = os.environ['NAMESPACE']
cert = os.environ['CERT']
host = os.environ['KUBERNETES_SERVICE_HOST']
token_path = os.environ['TOKEN']

with open(token_path, 'r') as token_file:
    token = token_file.read().replace('\n', '')

client.configuration.host = "https://" + host
client.configuration.ssl_ca_cert = cert
client.configuration.api_key['authorization'] = token
client.configuration.api_key_prefix['authorization'] = 'Bearer'

#setup logging
log = logging.getLogger(__name__)
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
handler.setLevel(logging.INFO)
log.addHandler(handler)
log.setLevel(logging.INFO)


def is_ready(container_name):
    log.info( "Checking if " + container_name + "  is ready")
    # config.load_kube_config() # for local testing
    # namespace='onap-sdc' # for local testing
    v1 = client.CoreV1Api()

    ready = False

    try:
        response = v1.list_namespaced_pod(namespace=namespace, watch=False)
        for i in response.items:
            for s in i.status.container_statuses:
                if s.name == container_name:
                    ready = s.ready
                    if not ready:
                        log.info( container_name + " is not ready.")
                    else:
                        log.info( container_name + " is ready!")
                else:
                    continue
        return ready
    except Exception as e:
        log.error("Exception when calling list_namespaced_pod: %s\n" % e)


def main(args):
    # args are a list of container names
    for container_name in args:
        # 5 min, TODO: make configurable
        timeout = time.time() + 60 * 10
        while True:
            ready = is_ready(container_name)
            if ready is True:
                break
            elif time.time() > timeout:
                log.warning( "timed out waiting for '" + container_name + "' to be ready")
                exit(1)
            else:
                time.sleep(5)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process some names.')
    parser.add_argument('--container-name', action='append', required=True, help='A container name')
    args = parser.parse_args()
    arg_dict = vars(args)

    for arg in arg_dict.itervalues():
        main(arg)
