from os import getenv

K8S_TESTS_NAMESPACE = getenv("NAMESPACE", "onap")

CDS_URL         = f"http://cds-blueprints-processor-http.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
SDC_BE_URL      = f"http://sdc-be.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
SDC_FE_URL      = f"http://sdc-fe.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8181"
SO_URL          = f"http://so.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
K8SPLUGIN_URL   = f"http://multicloud-k8s.{K8S_TESTS_NAMESPACE}.svc.cluster.local:9015"
AAI_URL         = f"http://aai.{K8S_TESTS_NAMESPACE}.svc.cluster.local:80"
CPS_URL         = f"http://cps-core.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
SDNC_URL        = f"http://sdnc.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8282"
TESTKUBE_URL    = f"http://testkube-api-server.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8088"
VES_URL         = f"http://dcae-ves-collector.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
NBI_URL         = f"http://nbi.{K8S_TESTS_NAMESPACE}.svc.cluster.local:8080"
POLICY_API_URL  = f"http://policy-api.{K8S_TESTS_NAMESPACE}.svc.cluster.local:6969"
POLICY_PAP_URL  = f"http://policy-pap.{K8S_TESTS_NAMESPACE}.svc.cluster.local:6969"
POLICY_PDP_URL  = f"http://policy-xacml-pdp.{K8S_TESTS_NAMESPACE}.svc.cluster.local:6969"

IN_CLUSTER                 = True
SERVICE_DISTRIBUTION_NUMBER_OF_TRIES = 15
EXPOSE_SERVICES_NODE_PORTS = False
CPS_AUTH                   = ("cpsuser", "tj61KoH9")
SDC_CLEANUP                = False
#SDNC_DB_PRIMARY_HOST       = f"sdnc-db.{K8S_TESTS_NAMESPACE}.svc.cluster.local"
SDNC_DB_PRIMARY_HOST       = f"mariadb-galera.{K8S_TESTS_NAMESPACE}.svc.cluster.local"

AAI_API_VERSION = "v29"

SDC_SERVICE_DISTRIBUTION_COMPONENTS = [
    "SO-sdc-controller",
    "aai-model-loader",
    "sdnc-sdc-listener",
    "multicloud-k8s"
]

SDC_SERVICE_DISTRIBUTION_DESIRED_STATE = {
    "SO-sdc-controller": "DOWNLOAD_OK",
    "aai-model-loader": "DOWNLOAD_OK",
    "sdnc-sdc-listener": "DOWNLOAD_OK",
}
