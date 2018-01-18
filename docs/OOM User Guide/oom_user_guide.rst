.. This work is licensed under a Creative Commons Attribution 4.0 International License.

OOM User Guide
##############
.. contents::
   :depth: 3
..

Introduction
============

The ONAP Operations Manager (OOM) is responsible for life-cycle
management of the ONAP platform itself; components such as MSO, SDNC,
etc. It is not responsible for the management of services, VNFs or
infrastructure instantiated by ONAP or used by ONAP to host such
services or VNFs. OOM uses the open-source Kubernetes container
management system as a means to manage the Docker containers that
compose ONAP where the containers are hosted either directly on
bare-metal servers or on VMs hosted by a 3rd party management system.
OOM ensures that ONAP is easily deployable and maintainable throughout
its life cycle while using hardware resources efficiently. There are two
deployment options for OOM:

-  A minimal deployment where single instances of the ONAP components
   are instantiated with no resource reservations, and

-  | A production deployment where ONAP components are deployed with
     redundancy and anti-affinity rules such that single faults do not
     interrupt ONAP operation.
   | When deployed as containers directly on bare-metal, the minimal
     deployment option requires a single host (32GB memory with 12
     vCPUs) however further optimization should allow this deployment to
     target a laptop computer. Production deployments will require more
     resources as determined by anti-affinity and geo-redundancy
     requirements.

OOM deployments of ONAP provide many benefits:

-  Life-cycle Management Kubernetes is a comprehensive system for
   managing the life-cycle of containerized applications. Its use as a
   platform manager will ease the deployment of ONAP, provide fault
   tolerance and horizontal scalability, and enable seamless upgrades.

-  Hardware Efficiency ONAP can be deployed on a single host using less
   than 32GB of memory. As opposed to VMs that require a guest operating
   system be deployed along with the application, containers provide
   similar application encapsulation with neither the computing, memory
   and storage overhead nor the associated long term support costs of
   those guest operating systems. An informal goal of the project is to
   be able to create a development deployment of ONAP that can be hosted
   on a laptop.

-  Rapid Deployment With locally cached images ONAP can be deployed from
   scratch in 7 minutes. Eliminating the guest operating system results
   in containers coming into service much faster than a VM equivalent.
   This advantage can be particularly useful for ONAP where rapid
   reaction to inevitable failures will be critical in production
   environments.

-  Portability OOM takes advantage of Kubernetes' ability to be hosted
   on multiple hosted cloud solutions like Google Compute Engine, AWS
   EC2, Microsoft Azure, CenturyLink Cloud, IBM Bluemix and more.

-  Minimal Impact As ONAP is already deployed with Docker containers
   minimal changes are required to the components themselves when
   deployed with OOM.

Features of OOM:

-  Platform Deployment Automated deployment/un-deployment of ONAP
   instance(s) / Automated deployment/un-deployment of individual
   platform components using docker containers & kubernetes

-  Platform Monitoring & healing Monitor platform state, Platform health
   checks, fault tolerance and self-healing using docker containers &
   kubernetes

-  Platform Scaling Platform horizontal scalability through using docker
   containers & kubernetes

-  Platform Upgrades Platform upgrades using docker containers &
   kubernetes

-  Platform Configurations Manage overall platform components
   configurations using docker containers & kubernetes

-  | Platform migrations Manage migration of platform components using
     docker containers & kubernetes
   | Please note that the ONAP Operations Manager does not provide
     support for containerization of services or VNFs that are managed
     by ONAP; the OOM orchestrates the life-cycle of the ONAP platform
     components themselves.

Container Background
--------------------

Linux containers allow for an application and all of its operating
system dependencies to be packaged and deployed as a single unit without
including a guest operating system as done with virtual machines. The
most popular container solution
is \ `Docker <https://www.docker.com/>`__ which provides tools for
container management like the Docker Host (dockerd) which can create,
run, stop, move, or delete a container. Docker has a very popular
registry of containers images that can be used by any Docker system;
however, in the ONAP context, Docker images are built by the standard
CI/CD flow and stored
in \ `Nexus <https://nexus.onap.org/#welcome>`__ repositories. OOM uses
the "standard" ONAP docker containers and three new ones specifically
created for OOM.

Containers are isolated from each other primarily via name spaces within
the Linux kernel without the need for multiple guest operating systems.
As such, multiple containers can be deployed with little overhead such
as all of ONAP can be deployed on a single host. With some optimization
of the ONAP components (e.g. elimination of redundant database
instances) it may be possible to deploy ONAP on a single laptop
computer.

Life Cycle Management via Kubernetes
====================================

As with the VNFs deployed by ONAP, the components of ONAP have their own
life-cycle where the components are created, run, healed, scaled,
stopped and deleted. These life-cycle operations are managed by
the \ `Kubernetes <https://kubernetes.io/>`__ container management
system which maintains the desired state of the container system as
described by one or more deployment descriptors - similar in concept to
OpenStack HEAT Orchestration Templates. The following sections describe
the fundamental objects managed by Kubernetes, the network these
components use to communicate with each other and other entities outside
of ONAP and the templates that describe the configuration and desired
state of the ONAP components.

ONAP Components to Kubernetes Object Relationships
--------------------------------------------------

Kubernetes deployments consist of multiple objects:

-  nodes - a worker machine - either physical or virtual - that hosts
   multiple containers managed by kubernetes.

-  services - an abstraction of a logical set of pods that provide a
   micro-service.

-  pods - one or more (but typically one) container(s) that provide
   specific application functionality. 

-  persistent volumes - One or more permanent volumes need to be
   established to hold non-ephemeral configuration and state data.

The relationship between these objects is shown in the following figure:

.. figure:: ../kubernetes_objects.png

OOM uses these kubernetes objects as described in the following
sections.

Nodes
~~~~~

OOM works with both physical and virtual worker machines.  

-  Virtual Machine Deployments - If ONAP is to be deployed onto a set of
   virtual machines, the creation of the VMs is outside of the scope of
   OOM and could be done in many ways, such as:

   -  manually, for example by a user using the OpenStack Horizon
      dashboard or `AWS
      EC2 <https://wiki.onap.org/display/DW/ONAP+on+AWS#ONAPonAWS-Option0:DeployOOMKubernetestoaspotVM>`__,
      or

   -  automatically, for example with the use of a OpenStack Heat
      Orchestration Template which builds an ONAP stack, or

   -  orchestrated, for example with Cloudify creating the VMs from a
      TOSCA template and controlling their life cycle for the life of
      the ONAP deployment.

-  Physical Machine Deployments - If ONAP is to be deployed onto
   physical machines there are several options but the recommendation is
   to use
   `Rancher <http://rancher.com/docs/rancher/v1.6/en/quick-start-guide/>`__
   along with `Helm <https://github.com/kubernetes/helm/releases>`__ to
   associate hosts with a kubernetes cluster.

Pods
~~~~

A group of containers with shared storage and networking can be grouped
together into a kubernetes pod.  All of the containers within a pod are
co-located and co-scheduled so they operate as a single unit.  Within
ONAP Amsterdam release, pods are mapped one-to-one to docker containers
although this may change in the future.  As explained in the Services
section below the use of Pods within each ONAP component is abstracted
from other ONAP components.

Services
~~~~~~~~

OOM uses the kubernetes service abstraction to provide a consistent
access point for each of the ONAP components independent of the pod or
container architecture of that component.  For example, the SDNC
component may introduce OpenDaylight clustering as some point and change
the number of pods in this component to three or more but this change
will be isolated from the other ONAP components by the service
abstraction.  A service can include a load balancer on its ingress to
distribute traffic between the pods and even react to dynamic changes in
the number of pods if they are part of a replica set (see the MSO
example below for a brief explanation of replica sets).

Persistent Volumes
~~~~~~~~~~~~~~~~~~

As pods and containers are ephemeral, any data that must be persisted
across pod restart events needs to be stored outside of the pod in a
persistent volume(s).  Kubernetes supports a wide variety of types of
persistent volumes such as: Fibre Channel, NFS, iSCSI, CephFS, and
GlusterFS (for a full list look
`here <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes>`__)
so there are many options as to how storage is configured when deploying
ONAP via OOM.

OOM Networking with Kubernetes
------------------------------

-  DNS

-  Ports - Flattening the containers also expose port conflicts between
   the containers which need to be resolved.

Name Spaces
~~~~~~~~~~~

Within the namespaces are kubernete's services that provide external
connectivity to pods that host Docker containers. The following is a
list of the namespaces and the services within:

-  onap-aai

   -  aai-service

   -  *hbase*

   -  model-loader-service

   -  aai-resources

   -  aai-traversal

   -  data-router

   -  elasticsearch

   -  gremlin

   -  search-data-service

   -  sparky-be

-  onap-appc

   -  appc

   -  *appc-dbhost*

   -  appc-dgbuilder

-  clamp

   - clamp

   - clamp-mariadb


-  onap-dcae

   -  cdap0

   -  cdap1

   -  cdap2

   -  dcae-collector-common-event

   -  dcae-collector-dmaapbc

   -  dcae-controller

   -  dcae-pgaas

   -  dmaap

   -  kafka

   -  zookeeper

-  onap-message-router

   -  dmaap

   -  *global-kafka*

   -  *zookeeper*

-  onap-mso

   -  mso

   -  *mariadb*

-  onap-multicloud

   - multicloud-vio

   - framework

-  onap-policy

   -  brmsgw

   -  drools

   -  *mariadb*

   -  *nexus*

   -  pap

   -  pdp

-  onap-portal

   -  portalapps

   -  *portaldb*

   - portalwidgets

   -  vnc-portal

-  onap-robot

   -  robot

-  onap-sdc

   -  sdc-be

   -  *sdc-cs*

   -  *sdc-es*

   -  sdc-fe

   -  *sdc-kb*

-  onap-sdnc

   -  sdnc

   -  *sdnc-dbhost*

   -  sdnc-dgbuilder

   -  sdnc-portal

-  onap-vid

   -  *vid-mariadb*

   -  vid-server

Note that services listed in \ *italics* are local to the namespace
itself and not accessible from outside of the namespace.

Kubernetes Deployment Specifications for ONAP
---------------------------------------------

Each of the ONAP components are deployed as described in a deployment
specification.  This specification documents key parameters and
dependencies between the pods of an ONAP components such that kubernetes
is able to repeatably startup the component.  The components artifacts
are stored here in the oom/kubernetes repo in \ `ONAP
gerrit <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes;h=4597d09dbce86d7543174924322435c30cb5b0ee;hb=refs/heads/master>`__.
The mso project is a relatively simple example, so let's start there.

MSO Example
~~~~~~~~~~~

Within
the \ `oom/kubernetes/templates/mso <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/templates/mso;h=d8b778a16381d6695f635c14b9dcab72fb9fcfcd;hb=refs/heads/master>`__ repo,
one will find four files in yaml format:

-  `all-services.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob_plain;f=kubernetes/mso/templates/all-services.yaml;hb=refs/heads/master>`__

-  `db-deployment.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob_plain;f=kubernetes/mso/templates/db-deployment.yaml;hb=refs/heads/master>`__

-  `mso-deployment.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob_plain;f=kubernetes/mso/templates/db-deployment.yaml;hb=refs/heads/master>`__

-  `mso-pv-pvc.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob_plain;f=kubernetes/mso/templates/mso-pv-pvc.yaml;hb=refs/heads/master>`__

The db-deployment.yaml file describes deployment of the database
component of mso.  Here is the contents:

**db-deployment.yaml**::

  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: mariadb
    namespace: "{{ .Values.nsPrefix }}-mso"
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: mariadb
    template:
      metadata:
        labels:
          app: mariadb
        name: mariadb
      spec:
        hostname: mariadb
        containers:
        - args:
          image: {{ .Values.image.mariadb }}
          imagePullPolicy: {{ .Values.pullPolicy }}
          name: "mariadb"
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: password
            - name: MARIADB_MAJOR
              value: "10.1"
            - name: MARIADB_VERSION
              value: "10.1.11+maria-1~jessie"
          volumeMounts:
          - mountPath: /etc/localtime
            name: localtime
            readOnly: true
          - mountPath: /etc/mysql/conf.d
            name: mso-mariadb-conf
          - mountPath: /docker-entrypoint-initdb.d
            name: mso-mariadb-docker-entrypoint-initdb
          - mountPath: /var/lib/mysql
            name: mso-mariadb-data
          ports:
          - containerPort: 3306
            name: mariadb
          readinessProbe:
            tcpSocket:
              port: 3306
            initialDelaySeconds: 5
            periodSeconds: 10
        volumes:
          - name: localtime
            hostPath:
              path: /etc/localtime
          - name: mso-mariadb-conf
            hostPath:
              path: /dockerdata-nfs/{{ .Values.nsPrefix }}/mso/mariadb/conf.d
          - name: mso-mariadb-docker-entrypoint-initdb
            hostPath:
              path: /dockerdata-nfs/{{ .Values.nsPrefix }}/mso/mariadb/docker-entrypoint-initdb.d
          - name: mso-mariadb-data
            persistentVolumeClaim:
              claimName: mso-db
        imagePullSecrets:
        - name: "{{ .Values.nsPrefix }}-docker-registry-key"


The first part of the yaml file simply states that this is a deployment
specification for a mariadb pod.

The spec section starts off with 'replicas: 1' which states that only 1
'replica' will be use here.  If one was to change the number of replicas
to 3 for example, kubernetes would attempt to ensure that three replicas
of this pod are operational at all times.  One can see that in a
clustered environment the number of replicas should probably be more
than 1 but for simple deployments 1 is sufficient.

The selector label is a grouping primitive of kubernetes but this simple
example doesn't exercise it's full capabilities.

The template/spec section is where the key information required to start
this pod is found.

-  image: is a reference to the location of the docker image in nexus3

-  name: is the name of the docker image

-  env is a section supports the creation of operating system
   environment variables within the container and are specified as a set
   of key/value pairs.  For example, MYSQL\_ROOT\_PASSWORD is set to
   "password".

-  volumeMounts: allow for the creation of custom mount points

-  ports: define the networking ports that will be opened on the
   container.  Note that further in the all-services.yaml file ports
   that are defined here can be exposed outside of ONAP component's name
   space by creating a 'nodePort' - a mechanism used to resolve port
   duplication.

-  readinessProbe: is the mechanism kubernetes uses to determine the
   state of the container. 

-  volumes: a location to define volumes required by the container, in
   this case configuration and initialization information.

-  imagePullSecrets: an key to access the nexus3 repo when pulling
   docker containers.

As one might image, the mso-deployment.yaml file describes the
deployment artifacts of the mso application.  Here are the contents:

**mso-deployment.yaml**::

  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: mso
    namespace: "{{ .Values.nsPrefix }}-mso"
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: mso
    template:
      metadata:
        labels:
          app: mso
        name: mso
        annotations:
          pod.beta.kubernetes.io/init-containers: '[
            {
                "args": [
                    "--container-name",
                    "mariadb"
                ],
                "command": [
                    "/root/ready.py"
                ],
                "env": [
                    {
                        "name": "NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }
                ],
                "image": "{{ .Values.image.readiness }}",
                "imagePullPolicy": "{{ .Values.pullPolicy }}",
                "name": "mso-readiness"
            }
            ]'
      spec:
        containers:
        - command:
          - /docker-files/scripts/start-jboss-server.sh
          image: {{ .Values.image.mso }}
          imagePullPolicy: {{ .Values.pullPolicy }}
          name: mso
          volumeMounts:
          - mountPath: /etc/localtime
            name: localtime
            readOnly: true
          - mountPath: /shared
            name: mso
          - mountPath: /docker-files
            name: mso-docker-files
          env:
          - name: JBOSS_DEBUG
            value: "false"
          ports:
          - containerPort: 3904
          - containerPort: 3905
          - containerPort: 8080
          - containerPort: 9990
          - containerPort: 8787
          readinessProbe:
            tcpSocket:
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
        volumes:
          - name: localtime
            hostPath:
              path: /etc/localtime
          - name: mso
            hostPath:
              path: /dockerdata-nfs/{{ .Values.nsPrefix }}/mso/mso
          - name: mso-docker-files
            hostPath:
              path: /dockerdata-nfs/{{ .Values.nsPrefix }}/mso/docker-files
        imagePullSecrets:
        - name: "{{ .Values.nsPrefix }}-docker-registry-key"

Much like the db deployment specification the first and last part of
this yaml file describe meta-data, replicas, images, volumes, etc.  The
template section has an important new functionality though, a deployment
specification for a new "initialization" container .  The entire purpose
of the init-container is to allow dependencies to be resolved in an
orderly manner such that the entire ONAP system comes up every time.
Once the dependencies are met and the init-containers job is complete,
this container will terminate.  Therefore, when OOM starts up ONAP one
is able to see a number of init-containers start and then disappear as
the system stabilizes. Note that more than one init-container may be
specified, each completing before starting the next, if complex startup
relationships need to be specified.

In this particular init-container, the command '/root/ready.py' will be
executed to determine when mariadb is ready, but this could be a simple
bash script. The image/name section describes where and how to get the
docker image from the init-container.

To ensure that data isn't lost when an ephemeral container undergoes
life-cycle events (like being restarted), non-volatile or persistent
volumes can be attached to the service.  The following pv-pvc.yaml
file defines the persistent volume as 2 GB storage claimed by the
mso namespace.

**pv-pvc.yaml**::

  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: "{{ .Values.nsPrefix }}-mso-db"
    namespace: "{{ .Values.nsPrefix }}-mso"
    labels:
      name: "{{ .Values.nsPrefix }}-mso-db"
  spec:
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    persistentVolumeReclaimPolicy: Retain
    hostPath:
      path: /dockerdata-nfs/{{ .Values.nsPrefix }}/mso/mariadb/data
  ---
  kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: mso-db
    namespace: "{{ .Values.nsPrefix }}-mso"
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
    selector:
      matchLabels:
        name: "{{ .Values.nsPrefix }}-mso-db"

The last of the four files is the all-services.yaml file which defines
the kubernetes service(s) that will be exposed in this name space. Here
is the contents of the file:

**all-services.yaml**::

  apiVersion: v1
  kind: Service
  metadata:
    name: mariadb
    namespace: "{{ .Values.nsPrefix }}-mso"
    labels:
      app: mariadb
  spec:
    ports:
      - port: 3306
        nodePort: {{ .Values.nodePortPrefix }}52
    selector:
      app: mariadb
    type: NodePort
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: mso
    namespace: "{{ .Values.nsPrefix }}-mso"
    labels:
      app: mso
    annotations:
      msb.onap.org/service-info: '[
        {
            "serviceName": "so",
            "version": "v1",
            "url": "/ecomp/mso/infra",
            "protocol": "REST"
            "port": "8080",
            "visualRange":"1"
        },
        {
            "serviceName": "so-deprecated",
            "version": "v1",
            "url": "/ecomp/mso/infra",
            "protocol": "REST"
            "port": "8080",
            "visualRange":"1",
            "path":"/ecomp/mso/infra"
        }
        ]'
  spec:
    selector:
      app: mso
    ports:
      - name: mso1
        port: 8080
        nodePort: {{ .Values.nodePortPrefix }}23
      - name: mso2
        port: 3904
        nodePort: {{ .Values.nodePortPrefix }}25
      - name: mso3
        port: 3905
        nodePort: {{ .Values.nodePortPrefix }}24
      - name: mso4
        port: 9990
        nodePort: {{ .Values.nodePortPrefix }}22
      - name: mso5
        port: 8787
        nodePort: {{ .Values.nodePortPrefix }}50
    type: NodePort

First of all, note that this file is really two service specification in
a single file: the mariadb service and the mso service.  In some
circumstances it may be possible to hide some of the complexity of the
containers/pods by hiding them behind a single service.

The mariadb service specification is quite simple; other than the name
the only section of interest is the nodePort specification.  When
containers require exposing ports to the world outside of a kubernetes
namespace, there is a potential for port conflict. To resolve this
potential port conflict kubernetes uses the concept of a nodePort that
is mapped one-to-one with a port within the namespace.  In this case the
port 3306 (which was defined in the db-deployment.yaml file) is mapped
to 30252 externally thus avoiding the conflict that would have arisen
from deployment multiple mariadb containers.

The mso service definition is largely the same as the mariadb service
with the exception that the ports are named.

Customizing Deployment Specifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For each ONAP component deployed by OOM, a set of deployment
specifications are required.  Use fortunately there are many examples to
use as references such that the previous
'`mso <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/mso;h=d8b778a16381d6695f635c14b9dcab72fb9fcfcd;hb=refs/heads/master>`__'
example, as well as:
`aai <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/aai;h=243ff90da714459a07fa33023e6655f5d036bfcd;hb=refs/heads/master>`__,
`appc <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/appc;h=d34eaca8a17fc28033a491d3b71aaa1e25673f9e;hb=refs/heads/master>`__,
`message-router <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/message-router;h=51fcb23fb7fbbfab277721483d01c6e3f98ca2cc;hb=refs/heads/master>`__,
`policy <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/policy;h=8c29597b23876ea2ae17dbf747f4ab1e3b955dd9;hb=refs/heads/master>`__,
`portal <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/portal;h=371db03ddef92703daa699014e8c1c9623f7994d;hb=refs/heads/master>`__,
`robot <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/robot;h=46445652d43d93dc599c5108f5c10b303a3c777b;hb=refs/heads/master>`__,
`sdc <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/sdc;h=1d59f7b5944d4604491e72d0b6def0ff3f10ba4d;hb=refs/heads/master>`__,
`sdnc <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/sdnc;h=dbaab2ebd62190edcf489b5a5f1f52992847a73a;hb=refs/heads/master>`__
and
`vid <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/vid;h=e91788c8504f2da12c086e802e1e7e8648418c66;hb=refs/heads/master>`__.
If your components isn't already deployed by OOM, you can create your
own set of deployment specifications that can be easily added to OOM.

Development Deployments
~~~~~~~~~~~~~~~~~~~~~~~

For the Amsterdam release, the deployment specifications represent a
simple simplex deployment of ONAP that may not have the robustness
typically required of a full operational deployment.  Follow on releases
will enhance these deployment specifications as follows:

-  Load Balancers - kubernets has built in support for user defined or
   simple 'ingress' load balances at the service layer to hide the
   complexity of multi-pod deployments from other components.

-  Horizontal Scaling - replica sets can be used to dynamically scale
   the number of pods behind a service to that of the offered load.

-  Stateless Pods - using concepts such as DBaaS (database as a service)
   database technologies could be removed (where appropriate) from the
   services thus moving to the 'cattle' model so common in cloud
   deployments.

Kubernetes Under-Cloud Deployments
==================================

The automated ONAP deployment depends on a fully functional kubernetes
environment being available prior to ONAP installation. Fortunately,
kubenetes is supported on a wide variety of systems such as Google
Compute Engine, `AWS
EC2 <https://wiki.onap.org/display/DW/ONAP+on+AWS#ONAPonAWS-Option0:DeployOOMKubernetestoaspotVM>`__,
Microsoft Azure, CenturyLink Cloud, IBM Bluemix and more.  If you're
setting up your own kubernetes environment, please refer to \ `ONAP on
Kubernetes <file:///C:\display\DW\ONAP+on+Kubernetes>`__ for a walk
through of how to set this environment up on several platforms.

ONAP 'OneClick' Deployment Walk-though
======================================

Once a kubernetes environment is available and the deployment artifacts
have been customized for your location, ONAP is ready to be installed. 

The first step is to setup
the \ `/oom/kubernetes/config/onap-parameters.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters.yaml;h=7ddaf4d4c3dccf2fad515265f0da9c31ec0e64b1;hb=refs/heads/master>`__ file
with key-value pairs specific to your OpenStack environment.  There is
a \ `sample  <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters-sample.yaml;h=3a74beddbbf7f9f9ec8e5a6abaecb7cb238bd519;hb=refs/heads/master>`__\ that
may help you out or even be usable directly if you don't intend to
actually use OpenStack resources.  Here is the contents of this file:

**onap-parameters-sample.yaml**

  .. literalinclude:: https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob_plain;f=kubernetes/config/onap-parameters-sample.yaml;hb=refs/heads/amsterdam

.. code-block::

    #################
    # COMMON CONFIG #
    #################

    # NEXUS
    NEXUS_HTTP_REPO: https://nexus.onap.org/content/sites/raw
    NEXUS_DOCKER_REPO: nexus3.onap.org:10001
    NEXUS_USERNAME: docker
    NEXUS_PASSWORD: docker

    # Networking
    OPENSTACK_PUBLIC_NET_ID: "af6880a2-3173-430a-aaa2-6229df57ee15"
    OPENSTACK_PUBLIC_NET_NAME: "vlan200_net_ext"
    # Could be reduced, it needs 15 IPs for DCAE VMs
    OPENSTACK_OAM_NETWORK_CIDR: "10.0.0.0/16"

    # Authentication
    OPENSTACK_USERNAME: "nso"
    OPENSTACK_API_KEY: "Password"
    OPENSTACK_TENANT_NAME: "nso-rancher"
    OPENSTACK_TENANT_ID: "5c59f02201d54a9af1f2207f7be2c1"
    OPENSTACK_REGION: "RegionOne"
    # Either v2.0 or v3
    OPENSTACK_API_VERSION: "v2.0"
    OPENSTACK_KEYSTONE_URL: "http://10.1.1.2:5000"
    OPENSTACK_SERVICE_TENANT_NAME: "service"

    # Flavors's name
    OPENSTACK_FLAVOUR_SMALL: "m1.small"
    OPENSTACK_FLAVOUR_MEDIUM: "m1.medium"
    OPENSTACK_FLAVOUR_LARGE: "m1.large"

    # Images' name
    OPENSTACK_UBUNTU_14_IMAGE: "trusty"
    OPENSTACK_UBUNTU_16_IMAGE: "xenial"
    OPENSTACK_CENTOS_7_IMAGE: "centos-7"

    # ONAP config
    # Do not change unless you know what you're doing
    DMAAP_TOPIC: "AUTO"
    DEMO_ARTIFACTS_VERSION: "1.1.1"


    ########
    # DCAE #
    ########

    # Whether or not to deploy DCAE
    # If set to false, all the parameters bellow can be left empty or removed
    # If set to false, update ../dcaegen2/values.yaml disableDcae value to true,
    # this is to avoid deploying the DCAE deployments and services.
    DEPLOY_DCAE: "true"

    DCAE_IP_ADDR: "10.0.4.1"

    # Config
    # Do not change unless you know what you're doing
    DCAE_DOCKER_VERSION: v1.1.1
    DCAE_VM_BASE_NAME: "dcae"

    # Can be the same as OPENSTACK_KEYSTONE_URL/OPENSTACK_API_VERSION
    DCAE_KEYSTONE_URL: "http://10.195.4.2:5000/v2.0"

    # The private key needs to be in a specific format so it's formatted properly
    # when ending up in the DCAE HEAT stack. The best way is to do the following:
    # - copy paste your key
    # - surround it with quote
    # - add \n at the end of each line
    # - escape the result using https://www.freeformatter.com/java-dotnet-escape.html#ad-output
    OPENSTACK_KEY_NAME: "onap_key"
    OPENSTACK_PUB_KEY: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQAAABAQC7G5MqLJvkchuD/YGS/lUlTXXkPqdBLz8AhF/Dosln4YpVg9oD2X2fH2Nxs6Gz0wjB6w1pIqQm7ypz3kk2920PiRV2W1L0/mTF/9Wmi9ReVJzkC6VoBxL20MhRi0dx/Wxg4vmbAT4NGk+8ufqA45oFB6l0bQIdtmjzZH/WZFVB+rc1CtX6Ia0hrMyeLbzLM7IzLdVeb411hxumsQ1N0L4dQWY0E1SeynS2azQNU61Kbxjmm4b89Kw/y9iNW9GdFUodOFWbhK8XU/duSLS+NpoQ/kPJXuBzgPFCy6B7DCJhqZ20j0oXGPqZzXcKApZUJdgeLGML3q4DyiNkXAP4okaN Generated-by-Nova"
    OPENSTACK_PRIVATE_KEY: \"-----BEGIN RSA PRIVATE KEY-----\\n\r\nMIIEpQIBACAQEAuxuTKiyb5HIbg/2Bkv5VJU115D6nQS8/AIRfw6LJZ+GKVYPa\\n\r\nA9l9nx9jcbOhs9MIwesNaSKkJu8qc95JNvdtD4kVdltS9P5kxf/VpovUXlSc5Aul\\n\r\naAcS9tDIUYtHcf1sYOL5mwE+DRpPvLn6gOOaBQepdG0CHbZo82R/1mRVQfq3NQrV\\n\r\n+iGtIazMni28yzOyMy3VXm+NdYcbprENTdC+HUFmNBNUnsp0tms0DVOtSm8Y5puG\\n\r\n/PSsP8vYjVvRnRVKHThVm4SvF1P3bki0vjaaEP5DyV7gc4DxQsugewwiYamdtI9K\\n\r\nFxj6mc13CgKWVCXYHixjC96uA8ojZFwD+KJGjQIDAQABAoIBAG5sLqTEINhoMy7p\\n\r\nLFAowu050qp6A1En5eGTPcUCTCR/aZlgMAj3kPiYmKKgpXyvvcpbwtVaOVA083Pg\\n\r\nKotC6F0zxLPN355wh96GRnt8qD9nZhP7f4luK1X4D1B4hxiRvCVNros453rqHUa+\\n\r\n50SrjdkMFYh9ULNiVHvXws4u9lXx81K+M+FzIcf5GT8Cm9PSG0JiwGG2rmwv++fp\\n\r\nJDH3Z2k+B940ox6RLvoh68CXNYolSnWQ/GI0+o1nv2uncRE9wuAhnVN4JmvWw/zR\\n\r\nqA7k305LgfbeJrma6dE4GOZo5cVbUcVKTD+rilCE13DCYx0yCEhxmDBMizNb83nH\\n\r\nge5AXI0CgYEA3oRVKnTBUSLrLK0ft5LJRz91aaxMUemzCqoQBpM7kaaGSf+gg2Z7\\n\r\nBTRp4fyLrYKyXACZGAXjhw2SVsTjntVACA+pIJQNim4vUNo03hcDVraxUMggvsJx\\n\r\nSKnwDe4zpGbIo7VEJVBgUhWccHKbBo0dB26VOic8xtUI/pDWeR9ryEMCgYEA10M6\\n\r\nrgFhvb4fleS0bzMe+Yv7YsbvEWeHDEgO060n050eIpcvrDtpnc4ag1BFKy9MSqnY\\n\r\n4VUIjIWI9i5Gq7rwxahduJfH/MgjagLtSmvIXA2uYni7unOKarqq75Nko9NG93b7\\n\r\np0nRKxFMm2hCVL7/gy6KzEuLkUhtok8+HOc3cO8CgYEAt/Fs9cvOguP6xNPYhEgz\\n\r\nW1J6HQDxlkU6XHZ5CPZtJ9og6MsIRZdR2tuZK9c5IBYKm0NjSxiTHfF6J4BbKdHf\\n\r\nPMq1ZNj+2JB9TLkVOwKLIAOmUMEfUJIsU4UnjFx9FEpjUfFmg/INrc1vpQUYYjIE\\n\r\n7T/c3FXTSAqThNz2buoqj0ECgYEAx9TiWXxw5vrjSXw5wG0dmR3I7aatcmPAK7eN\\n\r\nBBZfvYPC4Oum1uWEo3kchcBzpaZP1ZQdAPm2aPTh8198PZnaQDOPZXiJr/F/Zr92\\n\r\n1zp9km8k7scTxv/RhEjrvGIA8FCHNd1fuqm9IpT5n99GjHOOsZH4SbTryKALHr0f\\n\r\ndSd0AUMCgYEAi36u1D0Ht40WgGHp+T8AVaYHnXvx+IlH2EXqMDwwv0aINOcHfsUG\\n\r\nG7OrxyJAVaEgwtxgskS7LLp9ANvccyI+F9KLZbBoe2aYcCHjWdtvnc9bJUUs+ERk\\n\r\nJpJwR9NyQ5iObsnAEebILOLP+4yLGAxBz18ZvTRrSz1To456+EO+E+k=\\n\r\n-----END RSA PRIVATE KEY-----\\n\"


    # This settings allows one to configure the /etc/resolv.conf nameserver resolution for all the DCAE VMs.
    # -
    # In the HEAT setup, it's meant to be a list, as the HEAT setup deploys a DNS Server VM in addition to DNS Designate
    # and this DNS Server is setup to forward request to the DNS Designate backend when it cannot resolve, hence the
    # DNS_FORWARDER config here. The DCAE Boostrap requires both inputs, even though they are now similar, we have to pass
    # them.
    # -
    # ATTENTION: Assumption is made the DNS Designate backend is configure to forward request to a public DNS (e.g. 8.8.8.8)
    # -
    # Put the IP of the DNS Designate backend (e.g. the OpenStack IP supporting DNS Designate)
    DNS_LIST : "10.195.1.1"
    DNS_FORWARDER: "10.195.1.1"

    # Do not change - Public DNS - not used but required by the DCAE boostrap container
    EXTERNAL_DNS: "8.8.8.8"

    # Proxy DNS Designate is only supportted for windriver-multicloud adapter (limitation from DCAE)
    # Set to true if you wish to use it (e.g. Integration lab)
    DNSAAS_PROXY_ENABLE: "false"

    # Possibility to have DNS Designate installed in another OpenStack, if not, provide the same values
    # as the OPENSTACK_* ones above.
    DNSAAS_REGION: "RegionOne"
    DNSAAS_KEYSTONE_URL: "http://10.1.1.2:5000/v2.0"
    DNSAAS_TENANT_NAME: "nso-rancher"
    DNSAAS_USERNAME: "nso"
    DNSAAS_PASSWORD: "Password"

    # DNS domain for the DCAE VMs
    DCAE_DOMAIN: "dcaeg2.onap.org"


Note that these values are required or the following steps will fail.

In-order to be able to support multiple ONAP instances within a single
kubernetes environment a configuration set is required.  The
`createConfig.sh <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/createConfig.sh;h=f226ccae47ca6de15c1da49be4b8b6de974895ed;hb=refs/heads/master>`__
script is used to do this.

**createConfig.sh**::

  > ./createConfig.sh -n onapTrial

The bash
script \ `createAll.bash <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/oneclick/createAll.bash;h=5e5f2dc76ea7739452e757282e750638b4e3e1de;hb=refs/heads/master>`__ is
used to create an ONAP deployment with kubernetes. It has two primary
functions:

-  Creating the namespaces used to encapsulate the ONAP components, and

-  Creating the services, pods and containers within each of these
   namespaces that provide the core functionality of ONAP.

**createAll.bash**::

  > ./createAll.bash -n onapTrial

Namespaces provide isolation between ONAP components as ONAP release 1.0
contains duplicate application (e.g. mariadb) and port usage. As
such createAll.bash requires the user to enter a namespace prefix string
that can be used to separate multiple deployments of onap. The result
will be set of 10 namespaces (e.g. onapTrial-sdc, onapTrial-aai,
onapTrial-mso, onapTrial-message-router, onapTrial-robot, onapTrial-vid,
onapTrial-sdnc, onapTrial-portal, onapTrial-policy, onapTrial-appc)
being created within the kubernetes environment.  A prerequisite pod
config-init (\ `pod-config-init.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/pod-config-init.yaml;h=b1285ce21d61815c082f6d6aa3c43d00561811c7;hb=refs/heads/master>`__)
may editing to match you environment and deployment into the default
namespace before running createAll.bash.

Integration with MSB
====================

The \ `Microservices Bus
Project <https://wiki.onap.org/pages/viewpage.action?pageId=3246982>`__ provides
facilities to integrate micro-services into ONAP and therefore needs to
integrate into OOM - primarily through Consul which is the backend of
MSB service discovery. The following is a brief description of how this
integration will be done:

A registrator to push the service endpoint info to MSB service
discovery. 

-  The needed service endpoint info is put into the kubernetes yaml file
   as annotation, including service name, Protocol,version, visual
   range,LB method, IP, Port,etc.

-  OOM deploy/start/restart/scale in/scale out/upgrade ONAP components

-  Registrator watch the kubernetes event

-  When an ONAP component instance has been started/destroyed by OOM,
   Registrator get the notification from kubernetes

-  Registrator parse the service endpoint info from annotation and
   register/update/unregister it to MSB service discovery

-  MSB API Gateway uses the service endpoint info for service routing
   and load balancing.

Details of the registration service API can be found at \ `Microservice
Bus API
Documentation <https://wiki.onap.org/display/DW/Microservice+Bus+API+Documentation>`__.

How to define the service endpoints using annotation \ `ONAP Services
List#OOMIntegration <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-OOMIntegration>`__

A preliminary view of the OOM-MSB integration is as follows:

.. figure:: ../MSB-OOM-Diagram.png

A message sequence chart of the registration process:

.. figure:: ../MSB-OOM-MSC.png

MSB Usage Instructions
----------------------
MSB provides kubernetes charts in OOM, so it can be spun up by oom oneclick command. 

Please note that kubernetes authentication token must be set at *kubernetes/kube2msb/values.yaml* so the kube2msb registrator can get the access to watch the kubernetes events and get service annotation by kubernetes APIs. The token can be found in the kubectl configuration file *~/.kube/config*

MSB and kube2msb can be spun up with all the ONAP components together, or separately using the following commands.

**Start MSB services**::

  createAll.bash -n onap -a msb

**Start kube2msb registrator**::

  createAll.bash -n onap -a kube2msb

More details can be found here `MSB installation <http://onap.readthedocs.io/en/latest/submodules/msb/apigateway.git/docs/platform/installation.html>`__.

FAQ (Frequently Asked Questions)
================================

Does OOM enable the deployment of VNFs on containers?

-  No. OOM provides a mechanism to instantiate and manage the ONAP
   components themselves with containers but does not provide a
   Multi-VIM capability such that VNFs can be deployed into containers.
   The Multi VIM/Cloud Project may provide this functionality at some point.

Configuration Parameters
========================

Configuration parameters that are specific to the ONAP deployment, for example
hard coded IP addresses, are parameterized and stored in a OOM specific
set of configuration files.

More information about ONAP configuration can be found in the Configuration Management
section.

References
==========

-  Docker - http://docker.com

-  Kubernetes - http://kubernetes.io

-  Helm - https://helm.sh
