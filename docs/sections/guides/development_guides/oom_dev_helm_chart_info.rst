.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018-2020 Amdocs, Bell Canada, Orange, Samsung
.. Modification copyright (C) 2022 Nordix Foundation

.. Links
.. _Helm Charts: https://artifacthub.io/packages/search
.. _aai: https://github.com/onap/oom/tree/master/kubernetes/aai
.. _name.tpl: https://github.com/onap/oom/blob/master/kubernetes/common/common/templates/_name.tpl
.. _namespace.tpl: https://github.com/onap/oom/blob/master/kubernetes/common/common/templates/_namespace.tpl

.. _oom_helm_chart_info:

Helm Charts
###########

A Helm chart is a collection of files that describe a related set of Kubernetes
resources. A simple chart might be used to deploy something simple, like a
memcached pod, while a complex chart might contain many micro-service arranged
in a hierarchy as found in the `aai`_ ONAP component.

Charts are created as files laid out in a particular directory tree, then they
can be packaged into versioned archives to be deployed. There is a public
archive of `Helm Charts`_ on ArtifactHUB that includes many technologies applicable
to ONAP. Some of these charts have been used in ONAP and all of the ONAP charts
have been created following the guidelines provided.

An example structure of the OOM common helm charts is shown below:

.. code-block:: bash

  common
  ├── cassandra
  │   ├── Chart.yaml
  │   ├── resources
  │   │   ├── config
  │   │   │   └── docker-entrypoint.sh
  │   │   ├── exec.py
  │   │   └── restore.sh
  │   ├── templates
  │   │   ├── backup
  │   │   │   ├── configmap.yaml
  │   │   │   ├── cronjob.yaml
  │   │   │   ├── pv.yaml
  │   │   │   └── pvc.yaml
  │   │   ├── configmap.yaml
  │   │   ├── pv.yaml
  │   │   ├── service.yaml
  │   │   └── statefulset.yaml
  │   └── values.yaml
  ├── common
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── _createPassword.tpl
  │   │   ├── _ingress.tpl
  │   │   ├── _labels.tpl
  │   │   ├── _mariadb.tpl
  │   │   ├── _name.tpl
  │   │   ├── _namespace.tpl
  │   │   ├── _repository.tpl
  │   │   ├── _resources.tpl
  │   │   ├── _secret.yaml
  │   │   ├── _service.tpl
  │   │   ├── _storage.tpl
  │   │   └── _tplValue.tpl
  │   └── values.yaml
  ├── ...
  └── postgres-legacy
      ├── Chart.yaml
      ├── charts
      └── configs

The common section of charts consists of a set of templates that assist with
parameter substitution (`name.tpl`_, `namespace.tpl`_, etc) and a set of
charts for components used throughout ONAP.  When the common components are used
by other charts they are instantiated each time or we can deploy a shared
instances for several components.

All of the ONAP components have charts that follow the pattern shown below:

.. code-block:: bash

  name-of-my-component
  ├── Chart.yaml
  ├── component
  │   └── subcomponent-folder
  ├── charts
  │   └── subchart-folder
  ├── resources
  │   ├── folder1
  │   │   ├── file1
  │   │   └── file2
  │   └── folder1
  │       ├── file3
  │       └── folder3
  │           └── file4
  ├── templates
  │   ├── NOTES.txt
  │   ├── configmap.yaml
  │   ├── deployment.yaml
  │   ├── ingress.yaml
  │   ├── job.yaml
  │   ├── secrets.yaml
  │   └── service.yaml
  └── values.yaml

Note that the /components sub dir may include a hierarchy of sub
components and in themselves can be quite complex.

You can use either `charts` or `components` folder for your subcomponents.
`charts` folder means that the subcomponent will always been deployed.

`components` folders means we can choose if we want to deploy the subcomponent.

This choice is done in root `values.yaml`:

.. code-block:: yaml

  ---
  global:
    key: value

  component1:
    enabled: true
  component2:
    enabled: true

Then in `Chart.yaml` dependencies section, you'll use these values:

.. code-block:: yaml

  ---
  dependencies:
    - name: common
      version: ~x.y-0
      repository: '@local'
    - name: component1
      version: ~x.y-0
      repository: 'file://components/component1'
      condition: component1.enabled
    - name: component2
      version: ~x.y-0
      repository: 'file://components/component2'
      condition: component2.enabled

Configuration of the components varies somewhat from component to component but
generally follows the pattern of one or more `configmap.yaml` files which can
directly provide configuration to the containers in addition to processing
configuration files stored in the `config` directory.  It is the responsibility
of each ONAP component team to update these configuration files when changes
are made to the project containers that impact configuration.

The following section describes how the hierarchical ONAP configuration system
is key to management of such a large system.


.. MISC
.. ====
.. Note that although OOM uses Kubernetes facilities to minimize the effort
.. required of the ONAP component owners to implement a successful rolling
.. upgrade strategy there are other considerations that must be taken into
.. consideration.
.. For example, external APIs - both internal and external to ONAP - should be
.. designed to gracefully accept transactions from a peer at a different
.. software version to avoid deadlock situations. Embedded version codes in
.. messages may facilitate such capabilities.
..
.. Within each of the projects a new configuration repository contains all of
.. the project specific configuration artifacts.  As changes are made within
.. the project, it's the responsibility of the project team to make appropriate
.. changes to the configuration data.
