.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Kubernetes LoadBalancer: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
.. _Kubernetes NodePort: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport

.. _oom_access_info_guide:

OOM Access Info
###############

.. figure:: ../../resources/images/oom_logo/oomLogoV2-medium.png
   :align: right

Access via Ingress (production)
*******************************

Using Ingress as access method requires the installation of an Ingress
controller and the configuration of the ONAP deployment to use it.

For "ONAP on ServiceMesh" you can find the instructions in:

- :ref:`oom_base_optional_addons`
- :ref:`oom_customize_overrides`

In the ServiceMesh deployment the Istio IngressGateway is the only access point
for ONAP component interfaces.
Usually the Ingress is accessed via a LoadBalancer IP (<ingress-IP>),
which is used as central address.
All APIs/UIs are provided via separate URLs which are routed to the component service.
To use these URLs they need to be resolvable via DNS or via /etc/hosts.

The domain name is usually defined in the `global` section of the ONAP helm-charts,
`virtualhost.baseurl` (here "simpledemo.onap.org") whereas the hostname of
the service (e.g. "sdc-fe-ui") is defined in the component's chart.

.. code-block:: none

  <ingress-IP> kiali.simpledemo.onap.org
  <ingress-IP> cds-ui.simpledemo.onap.org
  <ingress-IP> sdc-fe-ui.simpledemo.onap.org
  ...

To access e.g. the SDC UI now the new ssl-encrypted URL:

``https://sdc-fe-ui.simpledemo.onap.org/sdc1``

Access via NodePort/Loadbalancer (development)
**********************************************

In the development setop OOM operates in a private IP network that isn't
publicly accessible (i.e. OpenStack VMs with private internal network) which
blocks access to the ONAP User Interfaces.
To enable direct access to a service from a user's own environment (a laptop etc.)
the application's internal port is exposed through a `Kubernetes NodePort`_ or
`Kubernetes LoadBalancer`_ object.

Typically, to be able to access the Kubernetes nodes publicly a public address
is assigned. In OpenStack this is a floating IP address.

Most ONAP applications use the `NodePort` as predefined `service:type`,
which opens allows access to the service through the the IP address of each
Kubernetes node.
When using  the `Loadbalancer` as `service:type` `Kubernetes LoadBalancer`_ object
which gets a separate IP address.

When e.g. the `sdc-fe` chart is deployed a Kubernetes service is created that
instantiates a load balancer.  The LB chooses the private interface of one of
the nodes as in the example below (10.0.0.4 is private to the K8s cluster only).
Then to be able to access the portal on port 8989 from outside the K8s &
OpenStack environment, the user needs to assign/get the floating IP address that
corresponds to the private IP as follows::

  > kubectl -n onap get services|grep "sdc-fe"
  sdc-fe  LoadBalancer   10.43.142.201   10.0.0.4   8181:30207/TCP


In this example, use the 10.0.0.4 private address as a key find the
corresponding public address which in this example is 10.12.6.155. If you're
using OpenStack you'll do the lookup with the horizon GUI or the OpenStack CLI
for your tenant (openstack server list).  That IP is then used in your
`/etc/hosts` to map the fixed DNS aliases required by the ONAP Portal as shown
below::

  10.43.142.201 sdc.fe.simpledemo.onap.org

Ensure you've disabled any proxy settings the browser you are using to access
the portal and then simply access now the new ssl-encrypted URL:
``http://sdc.fe.simpledemo.onap.org:30207sdc1/portal``

.. note::
  Besides the ONAP SDC the Components can deliver additional user interfaces,
  please check the Component specific documentation.

.. note::

   | Alternatives Considered:

   -  Kubernetes port forwarding was considered but discarded as it would
      require the end user to run a script that opens up port forwarding tunnels
      to each of the pods that provides a portal application widget.

   -  Reverting to a VNC server similar to what was deployed in the Amsterdam
      release was also considered but there were many issues with resolution,
      lack of volume mount, /etc/hosts dynamic update, file upload that were
      a tall order to solve in time for the Beijing release.

   Observations:

   -  If you are not using floating IPs in your Kubernetes deployment and
      directly attaching a public IP address (i.e. by using your public provider
      network) to your K8S Node VMs' network interface, then the output of
      'kubectl -n onap get services | grep "portal-app"'
      will show your public IP instead of the private network's IP. Therefore,
      you can grab this public IP directly (as compared to trying to find the
      floating IP first) and map this IP in /etc/hosts.

Some relevant information regarding accessing OOM from outside the cluster etc

ONAP Nodeports
==============

NodePorts are used to allow client applications, that run outside of
Kubernetes, access to ONAP components deployed by OOM.
A NodePort maps an externally reachable port to an internal port of an ONAP
microservice.
It should be noted that the use of NodePorts is temporary.
An alternative solution based on Ingress Controller, which initial support is
already in place. It is planned to become a default deployment option in the
London release.

More information from official Kubernetes documentation about
`Kubernetes NodePort`_.

The following table lists all the NodePorts used by ONAP.

.. csv-table:: NodePorts table
   :file: ../../resources/csv/nodeports.csv
   :widths: 20,20,20,20,20
   :header-rows: 1


This table retrieves information from the ONAP deployment using the following
Kubernetes command:

.. code-block:: bash

  kubectl get svc -n onap -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{.}}{{"\n"}}{{end}}{{end}}{{end}}'

