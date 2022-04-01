.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2021 Nokia

.. Links
.. _Cert-Manager Installation documentation: https://cert-manager.io/docs/installation/kubernetes/
.. _Cert-Manager kubectl plugin documentation: https://cert-manager.io/docs/usage/kubectl-plugin/
.. _Strimzi Apache Kafka Operator helm Installation documentation: https://strimzi.io/docs/operators/in-development/deploying.html#deploying-cluster-operator-helm-chart-str

.. _oom_setup_paas:

ONAP PaaS set-up
################

Starting from Honolulu release, Cert-Manager and Prometheus Stack are a part
of k8s PaaS for ONAP operations and can be installed to provide
additional functionality for ONAP engineers.
Starting from Jakarta release, Strimzi Apache Kafka is deployed to provide
Apache kafka as the default messaging bus for ONAP.

The versions of PaaS components that are supported by OOM are as follows:

.. table:: ONAP PaaS components

  ==============     =============  =================  =======
  Release            Cert-Manager   Prometheus Stack   Strimzi
  ==============     =============  =================  =======
  honolulu           1.2.0          13.x
  istanbul           1.5.4          19.x
  jakarta                                              0.28.0
  ==============     =============  =================  =======

This guide provides instructions on how to install the PaaS
components for ONAP.

.. contents::
   :depth: 1
   :local:
..

Strimzi Apache Kafka Operator
=============================

Strimzi provides a way to run an Apache Kafka cluster on Kubernetes
in various deployment configurations by using kubernetes operators.
Operators are a method of packaging, deploying, and managing a
Kubernetes application.
Strimzi Operators extend Kubernetes functionality, automating common
and complex tasks related to a Kafka deployment. By implementing
knowledge of Kafka operations in code, Kafka administration
tasks are simplified and require less manual intervention.

Installation steps
------------------

The recommended version of Strimzi for Kubernetes 1.19 is v0.28.0.
The Strimzi cluster operator is deployed using helm to install the parent chart
containing all of the required custom resource definitions. This should be done
by a kubernetes administrator to allow for deployment of custom resources in to
any kubernetes namespace within the cluster.

Full installation instructions can be found in the
`Strimzi Apache Kafka Operator helm Installation documentation`_.

Installation can be as simple as:

- Add the helm repo::

    > helm repo add strimzi https://strimzi.io/charts/

- Install the operator::

    > helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator --namespace strimzi-system --version 0.28.0 --set watchAnyNamespace=true --create-namespace

Cert-Manager
============

Cert-Manager is a native Kubernetes certificate management controller.
It can help with issuing certificates from a variety of sources, such as
Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, self
signed or external issuers. It ensures certificates are valid and up to
date, and attempt to renew certificates at a configured time before expiry.

Installation steps
------------------

The recommended version of Cert-Manager for Kubernetes 1.19 is v1.5.4.
Cert-Manager is deployed using regular YAML manifests which include all
the needed resources (the CustomResourceDefinitions, cert-manager,
namespace, and the webhook component).

Full installation instructions, including details on how to configure extra
functionality in Cert-Manager can be found in the
`Cert-Manager Installation documentation`_.

There is also a kubectl plugin (kubectl cert-manager) that can help you
to manage cert-manager resources inside your cluster. For installation
steps, please refer to `Cert-Manager kubectl plugin documentation`_.

Installation can be as simple as::

  > kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

Prometheus Stack (optional)
===========================

Prometheus is an open-source systems monitoring and alerting toolkit with
an active ecosystem.

Kube Prometheus Stack is a collection of Kubernetes manifests, Grafana
dashboards, and Prometheus rules combined with documentation and scripts to
provide easy to operate end-to-end Kubernetes cluster monitoring with
Prometheus using the Prometheus Operator. As it includes both Prometheus
Operator and Grafana dashboards, there is no need to set up them separately.

Installation steps
------------------

The recommended version of kube-prometheus-stack chart for
Kubernetes 1.19 is 19.x (which is currently the latest major chart version),
for example 19.0.2.

In order to install Prometheus Stack, you must follow these steps:

- Create the namespace for Prometheus Stack::

    > kubectl create namespace prometheus

- Add the prometheus-community Helm repository::

    > helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

- Update your local Helm chart repository cache::

    > helm repo update

- To install the kube-prometheus-stack Helm chart in latest version::

    > helm install prometheus prometheus-community/kube-prometheus-stack --namespace=prometheus

  To install the kube-prometheus-stack Helm chart in specific version, for example 19.0.2::

    > helm install prometheus prometheus-community/kube-prometheus-stack --namespace=prometheus --version=19.0.2
