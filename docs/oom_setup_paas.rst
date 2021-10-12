.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2021 Nokia

.. Links
.. _Cert-Manager Installation documentation: https://cert-manager.io/docs/installation/kubernetes/
.. _Cert-Manager kubectl plugin documentation: https://cert-manager.io/docs/usage/kubectl-plugin/

.. _oom_setup_paas:

ONAP PaaS set-up
################

Starting from Honolulu release, Cert-Manager and Prometheus Stack are a part
of k8s PaaS for ONAP operations and can be installed to provide
additional functionality for ONAP engineers.

The versions of PaaS components that are supported by OOM are as follows:

.. table:: ONAP PaaS components

  ==============     =============  =================
  Release            Cert-Manager   Prometheus Stack
  ==============     =============  =================
  honolulu           1.2.0          13.x
  istanbul           1.5.4          19.x
  ==============     =============  =================

This guide provides instructions on how to install the PaaS
components for ONAP.

.. contents::
   :depth: 1
   :local:
..

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
