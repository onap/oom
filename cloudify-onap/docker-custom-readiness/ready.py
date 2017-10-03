#!/usr/bin/python
#from kubernetes import client, config
import kubernetes
import time, argparse, logging, sys, os, base64
import yaml

#setup logging
log = logging.getLogger(__name__)
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
handler.setLevel(logging.DEBUG)
log.addHandler(handler)
log.setLevel(logging.DEBUG)


def is_ready(container_name):
    log.info( "Checking if " + container_name + "  is ready")

    kubernetes.config.kube_config.KubeConfigLoader(config_dict=get_k8s_config_env()).load_and_set()
    client = kubernetes.client
    namespace = get_namespace_env()
    v1 = client.CoreV1Api()

    ready = False

    try:
        response = v1.list_namespaced_pod(namespace=namespace, watch=False)
        for i in response.items:
            for s in i.status.container_statuses:
                if s.name == container_name:
                    log.debug ( "response %s" % response )
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


def get_k8s_config_env():
    try:
        k8s_config_env = os.environ.get("K8S_CONFIG_B64")
        decoded = base64.b64decode(k8s_config_env)
        return yaml.load(decoded)
    except KeyError as ke:
        raise Exception("K8S_CONFIG_B64 variable is not set.")


def get_namespace_env():
    try:
        namespace_env = os.environ.get("NAMESPACE")
        return namespace_env
    except KeyError as ke:
        raise Exception("NAMESPACE variable is not set.")


def main(args):#from kubernetes import client, config

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
