.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2020, Samsung Electronics
.. Modification copyright (C) 2022 Nordix Foundation

.. Links
.. _metallb Metal Load Balancer installation: https://metallb.universe.tf/installation/

.. _oom_setup_ingress_controller:

OOM Ingress controller setup
============================

.. warning::
    This guide does not describe the Istio Ingress Gateway configuration
    required for the ONAP Production Setup in London
    The installation of Istio Ingress (and Gateway-API) is described in
    :ref:`OOM Base Platform<oom_base_setup_guide>`

This optional guide provides instruction how to setup experimental ingress controller
feature. For this, we are hosting our cluster on OpenStack VMs and using the
Rancher Kubernetes Engine (RKE) to deploy and manage our Kubernetes Cluster and
ingress controller

.. contents::
   :backlinks: top
   :depth: 1
   :local:
..

The result at the end of this tutorial will be:

#. Customization of the cluster.yaml file for ingress controller support

#. Installation and configuration test DNS server for ingress host resolution
   on testing machines

#. Installation and configuration MLB (Metal Load Balancer) required for
   exposing ingress service

#. Installation and configuration NGINX ingress controller

#. Additional info how to deploy ONAP with services exposed via Ingress
   controller

Customize cluster.yml file
--------------------------

Before setup cluster for ingress purposes DNS cluster IP and ingress provider
should be configured and following:

.. code-block:: yaml

  ---
  <...>
  restore:
    restore: false
    snapshot_name: ""
  ingress:
    provider: none
  dns:
    provider: coredns
    upstreamnameservers:
      - <custer_dns_ip>:31555

Where the <cluster_dns_ip> should be set to the same IP as the CONTROLPANE
node.

For external load balancer purposes, minimum one of the worker node should be
configured with external IP address accessible outside the cluster. It can be
done using the following example node configuration:

.. code-block:: yaml

  ---
  <...>
  - address: <external_ip>
    internal_address: <internal_ip>
    port: "22"
    role:
      - worker
    hostname_override: "onap-worker-0"
    user: ubuntu
    ssh_key_path: "~/.ssh/id_rsa"
    <...>

Where the <external_ip> is external worker node IP address, and <internal_ip>
is internal node IP address if it is required.


DNS server configuration and installation
-----------------------------------------

DNS server deployed on the Kubernetes cluster makes it easy to use services
exposed through ingress controller because it resolves all subdomain related to
the ONAP cluster to the load balancer IP. Testing ONAP cluster requires a lot
of entries on the target machines in the /etc/hosts. Adding many entries into
the configuration files on testing machines is quite problematic and error
prone. The better wait is to create central DNS server with entries for all
virtual host pointed to simpledemo.onap.org and add custom DNS server as a
target DNS server for testing machines and/or as external DNS for Kubernetes
cluster.

DNS server has automatic installation and configuration script, so installation
is quite easy::

  > cd kubernetes/contrib/dns-server-for-vhost-ingress-testing

  > ./deploy\_dns.sh

After DNS deploy you need to setup DNS entry on the target testing machine.
Because DNS listen on non standard port configuration require iptables rules
on the target machine. Please follow the configuration proposed by the deploy
scripts.
Example output depends on the IP address and example output looks like bellow::

  DNS server already deployed:
  1. You can add the DNS server to the target machine using following commands:
    sudo iptables -t nat -A OUTPUT -p tcp -d 192.168.211.211 --dport 53 -j DNAT --to-destination 10.10.13.14:31555
    sudo iptables -t nat -A OUTPUT -p udp -d 192.168.211.211 --dport 53 -j DNAT --to-destination 10.10.13.14:31555
    sudo sysctl -w net.ipv4.conf.all.route_localnet=1
    sudo sysctl -w net.ipv4.ip_forward=1
  2. Update /etc/resolv.conf file with nameserver 192.168.211.211 entry on your target machine


MetalLB Load Balancer installation and configuration
----------------------------------------------------

By default pure Kubernetes cluster requires external load balancer if we want
to expose external port using LoadBalancer settings. For this purpose MetalLB
can be used. Before installing the MetalLB you need to ensure that at least one
worker has assigned IP accessible outside the cluster.

MetalLB Load balancer can be easily installed using automatic install script::

  > cd kubernetes/contrib/metallb-loadbalancer-inst

  > ./install-metallb-on-cluster.sh


Configuration of the Nginx ingress controller
---------------------------------------------

After installation of the DNS server and ingress controller, we can install and
configure ingress controller.
It can be done using the following commands::

  > cd kubernetes/contrib/ingress-nginx-post-inst

  > kubectl apply -f nginx_ingress_cluster_config.yaml

  > kubectl apply -f nginx_ingress_enable_optional_load_balacer_service.yaml

After deploying the NGINX ingress controller, you can ensure that the ingress port is
exposed as load balancer service with an external IP address::

  > kubectl get svc -n ingress-nginx
  NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
  default-http-backend   ClusterIP      10.10.10.10   <none>           80/TCP                       25h
  ingress-nginx          LoadBalancer   10.10.10.11    10.12.13.14   80:31308/TCP,443:30314/TCP   24h


ONAP with ingress exposed services
----------------------------------

If you want to deploy onap with services exposed through ingress controller you
can use full onap deploy yaml::

  > onap/resources/overrides/onap-all-ingress-nginx-vhost.yaml

Ingress also can be enabled on any onap setup override using following code:

.. code-block:: yaml

  ---
  <...>
  global:
  <...>
    ingress:
      enabled: true
