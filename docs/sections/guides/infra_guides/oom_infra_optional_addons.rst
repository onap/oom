.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Prometheus stack README: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md
.. _ONAP Next Generation Security & Logging Structure: https://wiki.onap.org/pages/viewpage.action?pageId=103417456
.. _Istio setup guide: https://istio.io/latest/docs/setup/install/helm/
.. _Kiali setup guide: https://kiali.io/docs/installation/installation-guide/example-install/
.. _Kserve setup guide: https://kserve.github.io/website/0.10/admin/kubernetes_deployment/

.. _oom_base_optional_addons:

OOM Optional Addons
===================

The following optional applications can be added to your kubernetes
environment.

Install Prometheus Stack
------------------------

Prometheus is an open-source systems monitoring and alerting toolkit with
an active ecosystem.

Kube Prometheus Stack is a collection of Kubernetes manifests, Grafana
dashboards, and Prometheus rules combined with documentation and scripts to
provide easy to operate end-to-end Kubernetes cluster monitoring with
Prometheus using the Prometheus Operator. As it includes both Prometheus
Operator and Grafana dashboards, there is no need to set up them separately.
See the `Prometheus stack README`_ for more information.

To install the prometheus stack, execute the following:

- Add the prometheus-community Helm repository::

    > helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

- Update your local Helm chart repository cache::

    > helm repo update

- To install prometheus, execute the following, replacing the <recommended-pm-version> with the version defined in the :ref:`versions_table` table::

    > helm install prometheus prometheus-community/kube-prometheus-stack --namespace=prometheus --create-namespace --version=<recommended-pm-version>


Kiali Installation
------------------

Kiali is used to visualize the Network traffic in a ServiceMesh enabled cluster
For setup the kiali operator is used, see `Kiali setup guide`_

- Install kiali-operator namespace::

    > kubectl create namespace kiali-operator

    > kubectl label namespace kiali-operator istio-injection=enabled

- Install the kiali-operator::

    > helm repo add kiali https://kiali.org/helm-charts

    > helm repo update kiali

    > helm install --namespace kiali-operator kiali/kiali-operator

- Create Kiali CR file (e.g. kiali.yaml)

    .. collapse:: kiali.yaml

      .. include:: ../../resources/yaml/kiali.yaml
         :code: yaml

- Install kiali::

    > kubectl apply -f kiali.yaml

- Create Ingress gateway entry for the kiali web interface
  using the configured Ingress <base-url> (here "simpledemo.onap.org")
  as described in :ref:`oom_customize_overrides`

    .. collapse:: kiali-ingress.yaml

      .. include:: ../../resources/yaml/kiali-ingress.yaml
         :code: yaml

- Add the Ingress entry for Kiali::

    > kubectl -n istio-system apply -f kiali-ingress.yaml


Jaeger Installation
-------------------

To be done...

K8ssandra-Operator Installation
-------------------------------

To be done...

Kserve Installation
-------------------

KServe is a standard Model Inference Platform on Kubernetes. It supports
RawDeployment mode to enable InferenceService deployment with Kubernetes
resources. Comparing to serverless deployment it unlocks Knative limitations
such as mounting multiple volumes, on the other hand Scale down and from Zero
is not supported in RawDeployment mode.

This installation is necessary for the ML models to be deployed as inference
service. Once deployed, the inference services can be queried for the
prediction.

**Kserve participant component in Policy ACM requires this installation. Kserve participant deploy/undeploy inference services in Kserve.**

Dependent component version compatibility details and installation instructions
can be found at `Kserve setup guide`_

Kserve installation requires the following components:

-  Istio. Its installation instructions can be found at :ref:`oom_base_optional_addons_istio_installation`

-  Cert-Manager. Its installation instructions can be found at :ref:`oom_base_setup_cert_manager`

Installation instructions as follows,

- Create kserve namespace::

    > kubectl create namespace kserve

- Install Kserve::

    > kubectl apply -f https://github.com/kserve/kserve/releases/download/v<recommended-kserve-version>/kserve.yaml

- Install Kserve default serving runtimes::

    > kubectl apply -f https://github.com/kserve/kserve/releases/download/v<recommended-kserve-version>/kserve-runtimes.yaml

- Patch ConfigMap inferenceservice-config as follows::

    > kubectl patch configmap/inferenceservice-config -n kserve --type=strategic -p '{"data": {"deploy": "{\"defaultDeploymentMode\": \"RawDeployment\"}"}}'
