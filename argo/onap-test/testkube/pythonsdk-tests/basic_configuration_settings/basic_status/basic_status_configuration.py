from onaptests.configuration.status_settings import *
from global_tests_settings import *

STORE_ARTIFACTS = False
CHECK_POD_VERSIONS = False
IGNORE_EMPTY_REPLICAS = True

WAIVER_LIST = ['integration', 'jaeger', 'performance-test', 'medusa-purge', 'wiremock', 'sample-rapp', '-scraper', 'soak', 'repo1-full']

EXCLUDE_NAMESPACE_LIST = ['nonrtric-rapp', 'kyverno', 'cluster-observability']

CHECK_ALL_NAMESPACES = True
LOG_CONFIG["handlers"]["file"]["level"] = "INFO"
