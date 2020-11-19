.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2020 Orange.  All rights reserved.

.. _developer-guide-label:


Current given templating functions
==================================


In order to have a consistent deployments of ONAP components, several templating
functions are proposed in  `kubernets/common/common/templates` folder.
This file list them and gives examples for the most used.
All these templating functions have a description in their own file, here we
only give an overview.

* conditional functions

  +----------------------------------------------------+-----------------------+
  | Function                                           | File                  |
  +----------------------------------------------------+-----------------------+
  | `common.needPV`                                    | `_storage.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.onServiceMesh`                             | `_serviceMesh.tpl`    |
  +----------------------------------------------------+-----------------------+
  | `common.common.needTLS`                             | `_service.tpl`       |
  +----------------------------------------------------+-----------------------+

* template generation functions

  +----------------------------------------------------+-----------------------+
  | Function                                           | File                  |
  +----------------------------------------------------+-----------------------+
  | `common.masterPassword`                            | `_createPassword.tpl` |
  +----------------------------------------------------+-----------------------+
  | `common.createPassword`                            | `_createPassword.tpl` |
  +----------------------------------------------------+-----------------------+
  | `common.secret.genName`                            | `_secret.yaml`        |
  +----------------------------------------------------+-----------------------+
  | `common.secret.getSecretName`                      | `_secret.yaml`        |
  +----------------------------------------------------+-----------------------+
  | `common.secret.envFromSecret`                      | `_secret.yaml`        |
  +----------------------------------------------------+-----------------------+
  | `common.secret`                                    | `_secret.yaml`        |
  +----------------------------------------------------+-----------------------+
  | `ingress.config.port`                              | `_ingress.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `ingress.config.annotations.ssl`                   | `_ingress.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `ingress.config.annotations`                       | `_ingress.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.ingress`                                   | `_ingress.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.labels`                                    | `_labels.tpl`         |
  +----------------------------------------------------+-----------------------+
  | `common.matchLabels`                               | `_labels.tpl`         |
  +----------------------------------------------------+-----------------------+
  | `common.resourceMetadata`                          | `_labels.tpl`         |
  +----------------------------------------------------+-----------------------+
  | `common.templateMetadata`                          | `_labels.tpl`         |
  +----------------------------------------------------+-----------------------+
  | `common.selectors`                                 | `_labels.tpl`         |
  +----------------------------------------------------+-----------------------+
  | `common.name`                                      | `_name.tpl`           |
  +----------------------------------------------------+-----------------------+
  | `common.fullname`                                  | `_name.tpl`           |
  +----------------------------------------------------+-----------------------+
  | `common.fullnameExplicit`                          | `_name.tpl`           |
  +----------------------------------------------------+-----------------------+
  | `common.release`                                   | `_name.tpl`           |
  +----------------------------------------------------+-----------------------+
  | `common.chart`                                     | `_name.tpl`           |
  +----------------------------------------------------+-----------------------+
  | `common.namespace`                                 | `_namespace.tpl`      |
  +----------------------------------------------------+-----------------------+
  | `common.repository`                                | `_repository.tpl`     |
  +----------------------------------------------------+-----------------------+
  | `common.flavor`                                    | `_resources.tpl`      |
  +----------------------------------------------------+-----------------------+
  | `common.resources`                                 | `_resources.tpl`      |
  +----------------------------------------------------+-----------------------+
  | `common.storageClass`                              | `_storage.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.replicaPV`                                 | `_storage.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.servicename`                               | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.serviceMetadata`                           | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.servicePorts`                              | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.genericService`                            | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.service`                                   | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.headlessService`                           | `_service.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadb.secret.rootPassUID`                | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadb.secret.rootPassSecretName`         | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadb.secret.userCredentialsUID`         | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadb.secret.userCredentialsSecretName`  | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadbService`                            | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadbPort`                               | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadbSecret`                             | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.mariadbSecretParam`                        | `_mariadb.tpl`        |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.rootPassUID`               | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.rootPassSecretName`        | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.userCredentialsUID`        | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.userCredentialsSecretName` | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.primaryPasswordUID`        | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.postgres.secret.primaryPasswordSecretName` | `_postgres.tpl`       |
  +----------------------------------------------------+-----------------------+
  | `common.tplValue`                                  | `_tplValue.tpl`       |
  +----------------------------------------------------+-----------------------+


Passwords
---------

These functions are defined in
`kubernetes/common/common/templates/_createPassword.tpl`.

* `common.masterPassword`: Resolve the master password to be used to derive
  other passwords.
* `common.createPassword`: Generate a new password based on masterPassword.

Secrets
-------

These functions are defined in
`kubernetes/common/common/templates/_secret.yaml`.

* `common.secret.genName`: Generate a secret name based on provided name or UID.
* `common.secret.getSecretName`: Get the real secret name by UID or name, based
  on the configuration provided by user.
* `common.secret.envFromSecret`: Convenience template which can be used to
  easily set the value of environment variable to the value of a key in a
  secret.
* `common.secret`: Define secrets to be used by chart.

The most widely use templates is the last (`common.secret`).
It should be the only (except license part) line of your secret file:

.. code-block:: yaml

  {{ include "common.secret" . }}

In order to have the right values set, you need to create the right
configuration in `values.yaml` (example taken from mariadb configuration):

.. code-block:: yaml

  secrets:
  - uid: 'db-root-password'
    type: password
    externalSecret: '{{ tpl (default "" .Values.config.db.rootPasswordExternalSecret) . }}'
    password: '{{ .Values.config.dbRootPassword }}'
  - uid: 'db-user-creds'
    type: basicAuth
    externalSecret: '{{ tpl (default "" .Values.config.db.userCredentialsExternalSecret) . }}'
    login: '{{ .Values.config.db.userName }}'
    password: '{{ .Values.config.dbSdnctlPassword }}'

Ingress
-------

These functions are defined in
`kubernetes/common/common/templates/_ingress.tpl`.

* `ingress.config.port`: generate the port path on an Ingress resource.
* `ingress.config.annotations.ssl`: generate the ssl annotations of an Ingress
  resource.
* `ingress.config.annotations`: generate the annotations of an Ingress resource.
* `common.ingress`: generate an Ingress resource (if needed).

The most widely use templates is the last (`common.ingress`) .

It should be the only (except license part) line of your ingress file:

.. code-block:: yaml

  {{ include "common.ingress" . }}

In order to have the right values set, you need to create the right
configuration in `values.yaml` (example taken from clamp configuration):

.. code-block:: yaml

  ingress:
    enabled: false
    service:
      - baseaddr: "clamp"
        name: "clamp"
        port: 443
    config:
      ssl: "redirect"

Labels
------

These functions are defined in `kubernetes/common/common/templates/_labels.tpl`.

The goal of these functions is to always create the right labels for all the
resource in a consistent way.

* `common.labels`: generate the common labels for a resource
* `common.matchLabels`: generate the labels to match (to be used in conjunction
  with `common.labels` or `common.resourceMetadata`)
* `common.resourceMetadata`: generate the "top" metadatas for a resource
  (Deployment, StatefulSet, Service, ConfigMap, ...)
* `common.templateMetadata`: generate the metadata put in the template part
  (for example `spec.template.metadata` for a Deployment)
* `common.selectors`: generate the right selectors for Service / Deployment /
  StatefulSet, ... (to be used in conjunction with `common.labels` or
  `common.resourceMetadata`)


Here's an example of use of these functions in a Deployment template (example
taken on nbi):

.. code-block:: yaml

  apiVersion: apps/v1
  kind: Deployment
  metadata: {{- include "common.resourceMetadata" . | nindent 2 }}
  spec:
    selector: {{- include "common.selectors" . | nindent 4 }}
    replicas: {{ .Values.replicaCount }}
    template:
      metadata: {{- include "common.templateMetadata" . | nindent 6 }}
      spec:
        ...

Name
----

These functions are defined in `kubernetes/common/common/templates/_name.tpl`.

The goal of these functions is to always name the resource the same way.

* `common.name`: Generate the name for a chart.
* `common.fullname`: Create a default fully qualified application name.
* `common.fullnameExplicit`: The same as common.full name but based on passed
  dictionary instead of trying to figure out chart name on its own.
* `common.release`: Retrieve the "original" release from the component release.
* `common.chart`: Generate the chart name

Here's an example of use of these functions in a Deployment template (example
taken on mariadb-galera):

.. code-block:: yaml

  apiVersion: apps/v1beta1
  kind: StatefulSet
  ...
  spec:
    serviceName: {{ .Values.service.name }}
    replicas: {{ .Values.replicaCount }}
    template:
      ...
      spec:
      {{- if .Values.nodeSelector }}
        nodeSelector:
  {{ toYaml .Values.nodeSelector | indent 8 }}
      {{- end }}
        volumes:
        {{- if .Values.externalConfig }}
          - name: config
            configMap:
              name: {{ include "common.fullname" . }}-external-config
        {{- end}}
        ...
        containers:
        - name: {{ include "common.name" . }}
          image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.image }}
        ...

Namespace
---------

These functions are defined in
`kubernetes/common/common/templates/_namespace.tpl`.

The goal of these functions is to always retrieve the namespace the same way.

* `common.namespace`: Generate the namespace for a chart. Shouldn't be used
  directly but use `common.resourceMetadata` (which uses it).


Repository
----------

These functions are defined in
`kubernetes/common/common/templates/_repository.tpl`.

The goal of these functions is to generate image name the same way.

* `common.repository`: Resolve the name of the common image repository.
* `common.repository.secret`: Resolve the image repository secret token.


Resources
---------

These functions are defined in
`kubernetes/common/common/templates/_resources.tpl`.

The goal of these functions is to generate resources for pods the same way.

* `common.flavor`: Resolve the name of the common resource limit/request flavor.
  Shouldn't be used alone.
* `common.resources`: Resolve the resource limit/request flavor using the
  desired flavor value.


Storage
-------

These functions are defined in
`kubernetes/common/common/templates/_storage.tpl`.

The goal of these functions is to generate storage part of Deployment /
Statefulset and storage resource (PV, PVC, ...) in a consistent way.

* `common.storageClass`: Expand the name of the storage class.
* `common.needPV`: Calculate if we need a PV. If a storageClass is provided,
  then we don't need.
* `common.replicaPV`: Generate N PV for a statefulset


Pod
---

These functions are defined in `kubernetes/common/common/templates/_pod.tpl`.

* `common.containerPorts`: generate the port list for containers. See Service
  part to know how to declare the port list.

Here's an example of use of these functions in a Deployment template (example
taken on nbi):

.. code-block:: yaml

  apiVersion: apps/v1
  kind: Deployment
  ...
  spec:
    ...
    template:
      ...
      spec:
        containers:
        - name:  {{ include "common.name" . }}
          ports: {{- include "common.containerPorts" . | nindent 8  }


Service
-------

These functions are defined in
`kubernetes/common/common/templates/_service.tpl`.

The goal of these functions is to generate services in a consistent way.

* `common.servicename`: Expand the service name for a chart.
* `common.serviceMetadata`: Define the metadata of Service. Shouldn't be used
  directly but used through `common.service` or `common.headlessService`.
* `common.servicePorts`: Define the ports of Service. Shouldn't be used directly
  but used through `common.service` or `common.headlessService`.
* `common.genericService`: Template for creating any Service. Shouldn't be used
  directly but used through `common.service` or `common.headlessService`. May be
  used if you want to create a Service with some specificities (on the ports for
  example).
* `common.needTLS`: Calculate if we need to use TLS ports on services
* `common.service`: Create service template.
* `common.headlessService`: Create headless service template


The most widely used templates are the two last (`common.service` and
`common.headlessService`).
It should use with only one (except license part) line of your service (or
service-headless) file:

.. code-block:: yaml

  {{ include "common.service" . }}

In order to have the right values set, you need to create the right
configuration in `values.yaml` (example taken from nbi configuration + other
part):

.. code-block:: yaml

  service:
    type: NodePort
    name: nbi
    annotations:
      my: super-annotation
    ports:
      - name: api
        port: 8443
        plain_port: 8080
        port_protocol: http
        nodePort: 74
      - name: tcp-raw
        port: 8459
        nodePort: 89


would generate:

.. code-block:: yaml

  apiVersion: v1
  kind: Service
  metadata:
    annotations:
      my: super-annotation
    name: nbi
    namespace: default
    labels:
      app.kubernetes.io/name: nbi
      helm.sh/chart: nbi-7.0.0
      app.kubernetes.io/instance: release
      app.kubernetes.io/managed-by: Tiller
  spec:
    ports:
    - port: 8443
      targetPort: api
      name: https-api
      nodePort: 30274
    - port: 8459
      targetPort: tcp-raw
      name: tcp-raw
      nodePort: 30289
    type: NodePort
    selector:
      app.kubernetes.io/name: nbi
      app.kubernetes.io/instance: release


`plain_port` is used only if we mandate to use http (see ServiceMesh part).
Today a port can be http or https but not both.
headless configuration is equivalent (example taken from cassandra):

.. code-block:: yaml

  service:
    name: cassandra
    headless:
      suffix: ""
      annotations:
        service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"
      publishNotReadyAddresses: true
    headlessPorts:
    - name: tcp-intra
      port: 7000
    - name: tls
      port: 7001
    - name: tcp-jmx
      port: 7199
    - name: tcp-cql
      port: 9042
    - name: tcp-thrift
      port: 9160
    - name: tcp-agent
      port: 61621


ServiceMesh
-----------

These functions are defined in
`kubernetes/common/common/templates/_serviceMesh.tpl`.

The goal of these functions is to handle onboarding of ONAP on service mesh.

* `common.onServiceMesh`: Calculate if we if we are on service mesh



MariaDB
-------

These functions are defined in
`kubernetes/common/common/templates/_mariadb.tpl`.

The goal of these functions is to simplify use of mariadb and its different
values.

* `common.mariadb.secret.rootPassUID`: UID of mariadb root password
* `common.mariadb.secret.rootPassSecretName`: Name of mariadb root password
  secret
* `common.mariadb.secret.userCredentialsUID`: UID of mariadb user credentials
* `common.mariadb.secret.userCredentialsSecretName`: Name of mariadb user
  credentials secret
* `common.mariadbService`: Choose the name of the mariadb service to use
* `common.mariadbPort`: Choose the value of mariadb port to use
* `common.mariadbSecret`: Choose the value of secret to retrieve user value
* `common.mariadbSecretParam`: Choose the value of secret param to retrieve user
  value

PostgreSQL
----------

These functions are defined in
`kubernetes/common/common/templates/_postgres.tpl`.

The goal of these functions is to simplify use of postgres and its different
values.

* `common.postgres.secret.rootPassUID`: UID of postgres root password
* `common.postgres.secret.rootPassSecretName`: Name of postgres root password
  secret
* `common.postgres.secret.userCredentialsUID`: UID of postgres user credentials
* `common.postgres.secret.userCredentialsSecretName`: Name of postgres user
  credentials secret
* `common.postgres.secret.primaryPasswordUID`: UID of postgres primary password
* `common.postgres.secret.primaryPasswordSecretName`: Name of postgres primary
  credentials secret


Utilities
---------

These functions are defined in
`kubernetes/common/common/templates/_tplValue.tpl`.

The goal of these functions is provide utility function, usually used in other
templating functions.

* `common.tplValue`: Renders a value that contains template.
