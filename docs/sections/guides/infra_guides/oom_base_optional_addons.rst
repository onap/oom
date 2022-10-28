.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Prometheus stack README: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#readme

.. _oom_base_optional_addons:

OOM Optional Addons
###################

The following optional applications can be added to your kubernetes environment.

Install Prometheus Stack
************************

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
