.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018-2020 Amdocs, Bell Canada, Orange, Samsung
.. Modification copyright (C) 2022 Nordix Foundation

.. Links

.. _oom_dev_config_management:


Configuration Management
########################

ONAP is a large system composed of many components - each of which are complex
systems in themselves - that needs to be deployed in a number of different
ways.  For example, within a single operator's network there may be R&D
deployments under active development, pre-production versions undergoing system
testing and production systems that are operating live networks.  Each of these
deployments will differ in significant ways, such as the version of the
software images deployed.  In addition, there may be a number of application
specific configuration differences, such as operating system environment
variables.  The following describes how the Helm configuration management
system is used within the OOM project to manage both ONAP infrastructure
configuration as well as ONAP components configuration.

One of the artifacts that OOM/Kubernetes uses to deploy ONAP components is the
deployment specification, yet another yaml file.  Within these deployment specs
are a number of parameters as shown in the following example:

.. code-block:: yaml

  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    labels:
      app.kubernetes.io/name: zookeeper
      helm.sh/chart: zookeeper
      app.kubernetes.io/component: server
      app.kubernetes.io/managed-by: Tiller
      app.kubernetes.io/instance: onap-oof
    name: onap-oof-zookeeper
    namespace: onap
  spec:
    <...>
    replicas: 3
    selector:
      matchLabels:
        app.kubernetes.io/name: zookeeper
        app.kubernetes.io/component: server
        app.kubernetes.io/instance: onap-oof
    serviceName: onap-oof-zookeeper-headless
    template:
      metadata:
        labels:
          app.kubernetes.io/name: zookeeper
          helm.sh/chart: zookeeper
          app.kubernetes.io/component: server
          app.kubernetes.io/managed-by: Tiller
          app.kubernetes.io/instance: onap-oof
      spec:
        <...>
        affinity:
        containers:
        - name: zookeeper
          <...>
          image: gcr.io/google_samples/k8szk:v3
          imagePullPolicy: Always
          <...>
          ports:
          - containerPort: 2181
            name: client
            protocol: TCP
          - containerPort: 3888
            name: election
            protocol: TCP
          - containerPort: 2888
            name: server
            protocol: TCP
          <...>

Note that within the statefulset specification, one of the container arguments
is the key/value pair image: gcr.io/google_samples/k8szk:v3 which
specifies the version of the zookeeper software to deploy.  Although the
statefulset specifications greatly simplify statefulset, maintenance of the
statefulset specifications themselves become problematic as software versions
change over time or as different versions are required for different
statefulsets.  For example, if the R&D team needs to deploy a newer version of
mariadb than what is currently used in the production environment, they would
need to clone the statefulset specification and change this value.  Fortunately,
this problem has been solved with the templating capabilities of Helm.

The following example shows how the statefulset specifications are modified to
incorporate Helm templates such that key/value pairs can be defined outside of
the statefulset specifications and passed during instantiation of the component.

.. code-block:: yaml

  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: {{ include "common.fullname" . }}
    namespace: {{ include "common.namespace" . }}
    labels: {{- include "common.labels" . | nindent 4 }}
  spec:
    replicas: {{ .Values.replicaCount }}
    selector:
      matchLabels: {{- include "common.matchLabels" . | nindent 6 }}
    # serviceName is only needed for StatefulSet
    # put the postfix part only if you have add a postfix on the service name
    serviceName: {{ include "common.servicename" . }}-{{ .Values.service.postfix }}
    <...>
    template:
      metadata:
        labels: {{- include "common.labels" . | nindent 8 }}
        annotations: {{- include "common.tplValue" (dict "value" .Values.podAnnotations "context" $) | nindent 8 }}
        name: {{ include "common.name" . }}
      spec:
        <...>
        containers:
          - name: {{ include "common.name" . }}
            image: {{ .Values.image }}
            imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
            ports:
            {{- range $index, $port := .Values.service.ports }}
              - containerPort: {{ $port.port }}
                name: {{ $port.name }}
            {{- end }}
            {{- range $index, $port := .Values.service.headlessPorts }}
              - containerPort: {{ $port.port }}
                name: {{ $port.name }}
            {{- end }}
            <...>

This version of the statefulset specification has gone through the process of
templating values that are likely to change between statefulsets. Note that the
image is now specified as: image: {{ .Values.image }} instead of a
string used previously.  During the statefulset phase, Helm (actually the Helm
sub-component Tiller) substitutes the {{ .. }} entries with a variable defined
in a values.yaml file.  The content of this file is as follows:

.. code-block:: yaml

  <...>
  image: gcr.io/google_samples/k8szk:v3
  replicaCount: 3
  <...>


Within the values.yaml file there is an image key with the value
`gcr.io/google_samples/k8szk:v3` which is the same value used in
the non-templated version.  Once all of the substitutions are complete, the
resulting statefulset specification ready to be used by Kubernetes.

When creating a template consider the use of default values if appropriate.
Helm templating has built in support for DEFAULT values, here is
an example:

.. code-block:: yaml

  imagePullSecrets:
  - name: "{{ .Values.nsPrefix | default "onap" }}-docker-registry-key"

The pipeline operator ("|") used here hints at that power of Helm templates in
that much like an operating system command line the pipeline operator allow
over 60 Helm functions to be embedded directly into the template (note that the
Helm template language is a superset of the Go template language).  These
functions include simple string operations like upper and more complex flow
control operations like if/else.

OOM is mainly helm templating. In order to have consistent deployment of the
different components of ONAP, some rules must be followed.

Templates are provided in order to create Kubernetes resources (Secrets,
Ingress, Services, ...) or part of Kubernetes resources (names, labels,
resources requests and limits, ...).

a full list and simple description is done in
`kubernetes/common/common/documentation.rst`.

Service template
----------------

In order to create a Service for a component, you have to create a file (with
`service` in the name.
For normal service, just put the following line:

.. code-block:: yaml

  {{ include "common.service" . }}

For headless service, the line to put is the following:

.. code-block:: yaml

  {{ include "common.headlessService" . }}

The configuration of the service is done in component `values.yaml`:

.. code-block:: yaml

  service:
   name: NAME-OF-THE-SERVICE
   postfix: MY-POSTFIX
   type: NodePort
   annotations:
     someAnnotationsKey: value
   ports:
   - name: tcp-MyPort
     port: 5432
     nodePort: 88
   - name: http-api
     port: 8080
     nodePort: 89
   - name: https-api
     port: 9443
     nodePort: 90

`annotations` and `postfix` keys are optional.
if `service.type` is `NodePort`, then you have to give `nodePort` value for your
service ports (which is the end of the computed nodePort, see example).

It would render the following Service Resource (for a component named
`name-of-my-component`, with version `x.y.z`, helm deployment name
`my-deployment` and `global.nodePortPrefix` `302`):

.. code-block:: yaml

  apiVersion: v1
  kind: Service
  metadata:
    annotations:
      someAnnotationsKey: value
    name: NAME-OF-THE-SERVICE-MY-POSTFIX
    labels:
      app.kubernetes.io/name: name-of-my-component
      helm.sh/chart: name-of-my-component-x.y.z
      app.kubernetes.io/instance: my-deployment-name-of-my-component
      app.kubernetes.io/managed-by: Tiller
  spec:
    ports:
      - port: 5432
        targetPort: tcp-MyPort
        nodePort: 30288
      - port: 8080
        targetPort: http-api
        nodePort: 30289
      - port: 9443
        targetPort: https-api
        nodePort: 30290
    selector:
      app.kubernetes.io/name: name-of-my-component
      app.kubernetes.io/instance:  my-deployment-name-of-my-component
    type: NodePort

In the deployment or statefulSet file, you needs to set the good labels in
order for the service to match the pods.

here's an example to be sure it matches (for a statefulSet):

.. code-block:: yaml

  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: {{ include "common.fullname" . }}
    namespace: {{ include "common.namespace" . }}
    labels: {{- include "common.labels" . | nindent 4 }}
  spec:
    selector:
      matchLabels: {{- include "common.matchLabels" . | nindent 6 }}
    # serviceName is only needed for StatefulSet
    # put the postfix part only if you have add a postfix on the service name
    serviceName: {{ include "common.servicename" . }}-{{ .Values.service.postfix }}
    <...>
    template:
      metadata:
        labels: {{- include "common.labels" . | nindent 8 }}
        annotations: {{- include "common.tplValue" (dict "value" .Values.podAnnotations "context" $) | nindent 8 }}
        name: {{ include "common.name" . }}
      spec:
       <...>
       containers:
         - name: {{ include "common.name" . }}
           ports:
           {{- range $index, $port := .Values.service.ports }}
           - containerPort: {{ $port.port }}
             name: {{ $port.name }}
           {{- end }}
           {{- range $index, $port := .Values.service.headlessPorts }}
           - containerPort: {{ $port.port }}
             name: {{ $port.name }}
           {{- end }}
           <...>

The configuration of the service is done in component `values.yaml`:

.. code-block:: yaml

  service:
   name: NAME-OF-THE-SERVICE
   headless:
     postfix: NONE
     annotations:
       anotherAnnotationsKey : value
     publishNotReadyAddresses: true
   headlessPorts:
   - name: tcp-MyPort
     port: 5432
   - name: http-api
     port: 8080
   - name: https-api
     port: 9443

`headless.annotations`, `headless.postfix` and
`headless.publishNotReadyAddresses` keys are optional.

If `headless.postfix` is not set, then we'll add `-headless` at the end of the
service name.

If it set to `NONE`, there will be not postfix.

And if set to something, it will add `-something` at the end of the service
name.

It would render the following Service Resource (for a component named
`name-of-my-component`, with version `x.y.z`, helm deployment name
`my-deployment` and `global.nodePortPrefix` `302`):

.. code-block:: yaml

  apiVersion: v1
  kind: Service
  metadata:
    annotations:
      anotherAnnotationsKey: value
    name: NAME-OF-THE-SERVICE
    labels:
      app.kubernetes.io/name: name-of-my-component
      helm.sh/chart: name-of-my-component-x.y.z
      app.kubernetes.io/instance: my-deployment-name-of-my-component
      app.kubernetes.io/managed-by: Tiller
  spec:
    clusterIP: None
    ports:
      - port: 5432
        targetPort: tcp-MyPort
        nodePort: 30288
      - port: 8080
        targetPort: http-api
        nodePort: 30289
      - port: 9443
        targetPort: https-api
        nodePort: 30290
    publishNotReadyAddresses: true
    selector:
      app.kubernetes.io/name: name-of-my-component
      app.kubernetes.io/instance:  my-deployment-name-of-my-component
    type: ClusterIP

Previous example of StatefulSet would also match (except for the `postfix` part
obviously).

Creating Deployment or StatefulSet
----------------------------------

Deployment and StatefulSet should use the `apps/v1` (which has appeared in
v1.9).
As seen on the service part, the following parts are mandatory:

.. code-block:: yaml

  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: {{ include "common.fullname" . }}
    namespace: {{ include "common.namespace" . }}
    labels: {{- include "common.labels" . | nindent 4 }}
  spec:
    selector:
      matchLabels: {{- include "common.matchLabels" . | nindent 6 }}
    # serviceName is only needed for StatefulSet
    # put the postfix part only if you have add a postfix on the service name
    serviceName: {{ include "common.servicename" . }}-{{ .Values.service.postfix }}
    <...>
    template:
      metadata:
        labels: {{- include "common.labels" . | nindent 8 }}
        annotations: {{- include "common.tplValue" (dict "value" .Values.podAnnotations "context" $) | nindent 8 }}
        name: {{ include "common.name" . }}
      spec:
        <...>
        containers:
          - name: {{ include "common.name" . }}

Dependency Management
---------------------
These Helm charts describe the desired state
of an ONAP deployment and instruct the Kubernetes container manager as to how
to maintain the deployment in this state.  These dependencies dictate the order
in-which the containers are started for the first time such that such
dependencies are always met without arbitrary sleep times between container
startups.  For example, the SDC back-end container requires the Elastic-Search,
Cassandra and Kibana containers within SDC to be ready and is also dependent on
DMaaP (or the message-router) to be ready - where ready implies the built-in
"readiness" probes succeeded - before becoming fully operational.  When an
initial deployment of ONAP is requested the current state of the system is NULL
so ONAP is deployed by the Kubernetes manager as a set of Docker containers on
one or more predetermined hosts.  The hosts could be physical machines or
virtual machines.  When deploying on virtual machines the resulting system will
be very similar to "Heat" based deployments, i.e. Docker containers running
within a set of VMs, the primary difference being that the allocation of
containers to VMs is done dynamically with OOM and statically with "Heat".
Example SO deployment descriptor file shows SO's dependency on its mariadb
data-base component:

SO deployment specification excerpt:

.. code-block:: yaml

  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: {{ include "common.fullname" . }}
    namespace: {{ include "common.namespace" . }}
    labels: {{- include "common.labels" . | nindent 4 }}
  spec:
    replicas: {{ .Values.replicaCount }}
    selector:
      matchLabels: {{- include "common.matchLabels" . | nindent 6 }}
    template:
      metadata:
        labels:
          app: {{ include "common.name" . }}
          release: {{ .Release.Name }}
      spec:
        initContainers:
        - command:
          - /app/ready.py
          args:
          - --container-name
          - so-mariadb
          env:
  ...