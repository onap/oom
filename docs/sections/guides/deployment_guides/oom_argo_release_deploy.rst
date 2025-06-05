.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2025 Deutsche Telekom

.. Links
.. _ONAP helm release repository: https://nexus3.onap.org/service/rest/repository/browse/onap-helm-release/
.. _ONAP Release Long Term Roadmap: https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16220234/Long+Term+Release+Roadmap
.. _GitOps Deployment: https://www.cncf.io/blog/2025/06/09/gitops-in-2025-from-old-school-updates-to-the-modern-way/
.. _Trivy Scan: https://trivy.dev/latest/
.. _ArgoCD: https://argo-cd.readthedocs.io/en/stable/
.. _App of Apps: https://argo-cd.readthedocs.io/en/latest/operator-manual/cluster-bootstrapping/

.. _oom_argo_release_deploy:

OOM Deployment using ArgoCD
===========================

Besides the deployment of ONAP using helm as described in :ref:`oom_helm_release_repo_deploy`, you
can use GitOps based deployment of ONAP components using ArgoCD or Flux (see `GitOps deployment`_).
This document shows an example for an ArgoCD (see `ArgoCD`_) based installation.

General principles of GitOps and ArgoCD
---------------------------------------

GitOps is a modern approach to continuous delivery and infrastructure management
that uses Git as the source of truth for both application and infrastructure configurations.

In GitOps, all changes to the system, such as updates or rollbacks, are made through pull
requests in Git repositories, which then trigger automated deployment pipelines.

This ensures that the environment is always aligned with the desired state defined in the Git
repository, making the system more predictable and auditable.

ArgoCD is a Kubernetes-native continuous delivery tool that implements GitOps principles.
It monitors Git repositories for changes in configuration files
(such as YAML or Helm charts) and automatically syncs the state of the Kubernetes
clusters to match the desired configuration.
With ArgoCD, users can track application deployments and changes visually through
a web UI or CLI, providing transparency and easy rollback options.
It also supports multi-cluster deployments and offers strong access control mechanisms
to manage who can trigger changes.
The system is highly automated and allows for fast, secure delivery and operational
consistency across environments.

OOM support for ArgoCD deployment
---------------------------------

In the OOM repository a subtree is provided, which contains ArgoCD
Application definitions and other files supporting the installation
using ArgoCD:

An example structure of the OOM common helm charts is shown below:

.. code-block:: bash

  argo
  ├── argocd
  │   ├── kustomization.yaml
  │   ├── app-project.yaml
  │   ├── argocd.yaml
  │   ├── values
  │   │   └── argocd.yaml
  ├── infra
  │   ├── kustomization.yaml
  │   ├── certmanager.yaml
  │   ├── chartmuseum.yaml
  │   ├── compile-onap.yaml
  │   ├── ...
  │   ├── values
  │   │   ├── certmanager.yaml
  │   │   ├── chartmuseum.yaml
  │   │   ├── compile-onap.yaml
  │   │   ├── ...
  │   │   └── xxx.yaml
  │   ├── compile-onap
  │   │   └── helm
  │   │       ├── Chart.yaml
  │   │       ├── values.yaml
  │   │       └── templates
  │   │           └── onap-helm-render-job.yaml
  │   ├── ...
  ├── onap
  │   ├── kustomization.yaml
  │   ├── a1policymanagement.yaml
  │   ├── aai.yaml
  │   ├── authentication.yaml
  │   ├── cds.yaml
  │   ├── ...
  │   ├── values
  │   │   ├── a1policymanagement.yaml
  │   │   ├── aai.yaml
  │   │   ├── authentication.yaml
  │   │   ├── ...
  │   │   └── xxx.yaml
  ├── onap-test
  │   ├── kustomization.yaml
  │   ├── kafka-ui.yaml
  │   ├── onap-test-ingress.yaml
  │   ├── testkube.yaml
  │   ├── trivy-operator.yaml
  │   ├── values
  │   │   ├── kafka-ui.yaml
  │   │   ├── onap-test-ingress.yaml
  │   │   ├── testkube.yaml
  │   │   └── trivy-operator.yaml
  │   ├── ingress-routes
  │   │   └── helm
  │   │       ├── Chart.yaml
  │   │       ├── values.yaml
  │   │       └── templates
  │   │           └── ingress-kafka-ui.yaml
  │   ├── ...
  └── update-variables.sh

The main folders are:

* argocd

  * Application definition for the ArgoCD deployment

* infra

  * Application definitions for required infrastructure components
    (e.g. Istio, CertManager, DB Operators, ...)
  * Required Helm Charts for IngressRoutes, Kiali, ONAP Chart compilation

* onap

  * Application definitions for ONAP components (e.g. AAI, CDS, SO, ...)

* onap-test

  * Application definitions for ONAP Test components and tools
    (e.g. Trivy Scan, Testkube, Kafka-UI)


General hints and preparation
-----------------------------

Prerequisites
^^^^^^^^^^^^^

As prerequisite you would need a Kubernetes cluster with the required
capacity to deploy the components into.
The Infrastructure (e.g. Bare Metal servers, Virtual Hosts) and the
way of deployment  (e.g. ClusterAPI, Kubespray) is not restricted.

In the tests of the OOM team it is done:

* On a vanilla Openstack cluster
* Using Terraform to create the tenant, VMs and networking
* Using Kubespray to create the K8S cluster
* Use a GitLab-CI pipeline to orchestrate the creativecommons

At the end of the deployment you need to install ArgoCD in this cluster
for the further process of installation.

As a input parameters for the ONAP deployment you would need to provide:

* A local Git(lab) project to store the "argo" Application definitions (or the oom project)
* Storage Class the cluster provides for PVs
* (Optional) A local helm registry to store the ONAP helmcharts,
  if you don't use the installed ChartMuseum

Preparation
^^^^^^^^^^^

* Clone the OOM repository into a new Git(Lab) project
* Replace the following variables with the script 'updateVariables.sh' (in argo subdir):

  * <ONAP_ARGO_REPO_URL> with the URL of the new git repo
  * <STORAGECLASS> with the default K8S storage class
  * <BASEURL> with the base DNS zone (e.g. "simpledemo.onap.org")
  * <POSTADDR> with the postfix for the hosts (optional) (e.g. "-onap-00")
  * <DOCKER_REPO> URL of the docker repository ('docker.io')
  * <ONAP_REPO> URL of the ONAP docker repository ('nexus3.onap.org:10001')
  * <ELASTIC_REPO> URL of the Elastic docker repository ('docker.elastic.co')
  * <QUAY_REPO> URL of the Quay.io docker repository ('quay.io')
  * <GOOGLE_REPO> URL of the K8S docker repository ('gcr.io')
  * <K8S_REPO> URL of the GoogleK8S docker repository ('registry.k8s.io')
  * <GITHUB_REPO> URL of the Github docker repository ('ghcr.io')
* after setting the variables start the script in the argo dir:
  './updateVariables.sh'
* check-in the project

To allow ArgoCD to access the 
- Git Repository, which contains the application definitions,
- (optional) Helm Repository, which contains the compiled charts
you need to create secrets to define the repository and the access credentials.
E.g.:

.. collapse:: argo-secret.yaml

  .. include:: ../../resources/yaml/argo-secret.yaml
     :code: yaml

The secrets can be created e.g. via kubectl command::

  > kubectl apply -f argo-secret.yaml

or added to the ArgoCD "self-managed" definition described in the later section.

General info about the installation of applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this example we use the "App of Apps" Pattern (see `App of Apps`_) to install bundles of applications.
E.g. we create an "onap" application containing multiple ONAP component applications (e.g. so, aai).
As definition of the "onap" application an "Application" resource is sefined, which points to
the directory 'argo/onap' in the examples.

.. collapse:: argo-onap.yaml

  .. include:: ../../../argo/onap/onap.yaml
     :code: yaml

The directory contains a kustomization.yaml file, which contains a resource definition pointing to
the ONAP component application files in its subdirectories.

.. collapse:: kustomization.yaml

  .. include:: ../../../argo/onap/kustomization.yaml
     :code: yaml

To add the ONAP application to ArgoCD for management, you can add it via kubectl command::

  > kubectl apply -f argo-onap.yaml

If you don't want to use the "App of Apps" Pattern, you can also install the single applications, e.g.::

  > kubectl apply -f argo/onap/so/application.yaml

User Guide for ArgoCD example
-----------------------------

After preparation of the environment and git repository the following steps are executed:

* Installation of "self-managed" ArgoCD
* Installation of the Infrastructure Applications and compilation and storage of the ONAP charts
* Installation of the ONAP Applications
* Installation of the ONAP Test Applications

The separation of the deployment steps is done to ease the installation procedure and avoid
dependency problems. But generally it should also be possible to install all applications at once
and let ArgoCD deal with the deployment.

Installation of "self-managed" ArgoCD
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TBD

Installation of the Infrastructure Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installation of the ONAP Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installation of the ONAP Test Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
