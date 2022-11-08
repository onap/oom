.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _HELM Best Practices Guide: https://docs.helm.sh/chart_best_practices/#requirements
.. _helm installation guide: https://helm.sh/docs/intro/install/
.. _kubectl installation guide: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
.. _Curated applications for Kubernetes: https://github.com/kubernetes/charts
.. _Cert-Manager Installation documentation: https://cert-manager.io/docs/installation/kubernetes/
.. _Cert-Manager kubectl plugin documentation: https://cert-manager.io/docs/usage/kubectl-plugin/
.. _Strimzi Apache Kafka Operator helm Installation documentation: https://strimzi.io/docs/operators/in-development/deploying.html#deploying-cluster-operator-helm-chart-str

.. _oom_base_setup_guide:

OOM Base Platform
#################

As part of the initial base setup of the host Kubernetes cluster,
the following mandatory installation and configuration steps must be completed.

.. contents::
   :backlinks: top
   :depth: 1
   :local:
..

For additional platform add-ons, see the :ref:`oom_base_optional_addons` section.

Install & configure kubectl
***************************
The Kubernetes command line interface used to manage a Kubernetes cluster needs to be installed
and configured to run as non root.

For additional information regarding kubectl installation and configuration see the `kubectl installation guide`_

To install kubectl, execute the following, replacing the <recommended-kubectl-version> with the version defined
in the :ref:`versions_table` table::

    > curl -LO https://dl.k8s.io/release/v<recommended-kubectl-version>/bin/linux/amd64/kubectl

    > chmod +x ./kubectl

    > sudo mv ./kubectl /usr/local/bin/kubectl

    > mkdir ~/.kube

    > cp kube_config_cluster.yml ~/.kube/config.onap

    > export KUBECONFIG=~/.kube/config.onap

    > kubectl config use-context onap

Validate the installation::

    > kubectl get nodes

::

  NAME             STATUS   ROLES               AGE     VERSION
  onap-control-1   Ready    controlplane,etcd   3h53m   v1.23.8
  onap-control-2   Ready    controlplane,etcd   3h53m   v1.23.8
  onap-k8s-1       Ready    worker              3h53m   v1.23.8
  onap-k8s-2       Ready    worker              3h53m   v1.23.8
  onap-k8s-3       Ready    worker              3h53m   v1.23.8
  onap-k8s-4       Ready    worker              3h53m   v1.23.8
  onap-k8s-5       Ready    worker              3h53m   v1.23.8
  onap-k8s-6       Ready    worker              3h53m   v1.23.8


Install & configure helm
************************
Helm is used for package and configuration management of the relevant helm charts.
For additional information, see the `helm installation guide`_

To install helm, execute the following, replacing the <recommended-helm-version> with the version defined
in the :ref:`versions_table` table::

    > wget https://get.helm.sh/helm-v<recommended-helm-version>-linux-amd64.tar.gz

    > tar -zxvf helm-v<recommended-helm-version>-linux-amd64.tar.gz

    > sudo mv linux-amd64/helm /usr/local/bin/helm

Verify the helm version with::

    > helm version

Helm's default CNCF provided `Curated applications for Kubernetes`_ repository called
*stable* can be removed to avoid confusion::

    > helm repo remove stable

Install the additional OOM plugins required to un/deploy the OOM helm charts::

    > git clone http://gerrit.onap.org/r/oom

    > cp -R ~/oom/kubernetes/helm/plugins/ /usr/local/bin/helm/plugins

Verify the plugins are installed::

    > helm plugin ls

::

    NAME        VERSION   DESCRIPTION
    deploy      1.0.0     install (upgrade if release exists) parent charty and all subcharts as separate but related releases
    undeploy    1.0.0     delete parent chart and subcharts that were deployed as separate releases


Install the strimzi kafka operator
**********************************
Strimzi Apache Kafka provides a way to run an Apache Kafka cluster on Kubernetes
in various deployment configurations by using kubernetes operators.
Operators are a method of packaging, deploying, and managing Kubernetes applications.

Strimzi Operators extend the Kubernetes functionality, automating common
and complex tasks related to a Kafka deployment. By implementing
knowledge of Kafka operations in code, the Kafka administration
tasks are simplified and require less manual intervention.

The Strimzi cluster operator is deployed using helm to install the parent chart
containing all of the required custom resource definitions. This should be done
by a kubernetes administrator to allow for deployment of custom resources in to
any kubernetes namespace within the cluster.

Full installation instructions can be found in the
`Strimzi Apache Kafka Operator helm Installation documentation`_.

To add the required helm repository, execute the following::

    > helm repo add strimzi https://strimzi.io/charts/

To install the strimzi kafka operator, execute the following, replacing the <recommended-strimzi-version> with the version defined
in the :ref:`versions_table` table::

    > helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator --namespace strimzi-system --version <recommended-strimzi-version> --set watchAnyNamespace=true --create-namespace

Verify the installation::

    > kubectl get po -n strimzi-system

::

    NAME                                        READY   STATUS    RESTARTS       AGE
    strimzi-cluster-operator-7f7d6b46cf-mnpjr   1/1     Running   0              2m


Install Cert-Manager
********************

Cert-Manager is a native Kubernetes certificate management controller.
It can help with issuing certificates from a variety of sources, such as
Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, self
signed or external issuers. It ensures certificates are valid and up to
date, and attempt to renew certificates at a configured time before expiry.

Cert-Manager is deployed using regular YAML manifests which include all
the needed resources (the CustomResourceDefinitions, cert-manager,
namespace, and the webhook component).

Full installation instructions, including details on how to configure extra
functionality in Cert-Manager can be found in the
`Cert-Manager Installation documentation`_.

There is also a kubectl plugin (kubectl cert-manager) that can help you
to manage cert-manager resources inside your cluster. For installation
steps, please refer to `Cert-Manager kubectl plugin documentation`_.


To install cert-manager, execute the following, replacing the <recommended-cm-version> with the version defined
in the :ref:`versions_table` table::

    > kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v<recommended-cm-version>/cert-manager.yaml

Verify the installation::

    > kubectl get po -n cert-manager

::

    NAME                                       READY   STATUS    RESTARTS      AGE
    cert-manager-776c4cfcb6-vgnpw              1/1     Running   0             2m
    cert-manager-cainjector-7d9668978d-hdxf7   1/1     Running   0             2m
    cert-manager-webhook-66c8f6c75-dxmtz       1/1     Running   0             2m

