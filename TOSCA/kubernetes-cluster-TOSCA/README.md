[![Build Status](https://circleci.com/gh/cloudify-examples/simple-kubernetes-blueprint.svg?style=shield&circle-token=:circle-token)](https://circleci.com/gh/cloudify-examples/simple-kubernetes-blueprint)


##  Kubernetes Cluster Example

This blueprint creates an example Kubernetes cluster. It is intended as an example. The underlying Kubernetes configuration method used is [Kubeadm](https://kubernetes.io/docs/admin/kubeadm/), which is not considered production-ready.

Regardless of your infrastructure choice, this blueprint installs and configures on each VM:
- The Kubernetes Yum repo will be installed on your VMs.
- Docker, version 1.12.6-28.git1398f24.el7.centos
- kubelet, version 1.8.6-0.
- kubeadm, version 1.8.6-0.
- kubernetes-cni, version 0.5.1-1.
- weave


## prerequisites

You will need a *Cloudify Manager* running in either AWS, Azure, or Openstack. The Cloudify manager should be setup using the [Cloudify environment setup](https://github.com/cloudify-examples/cloudify-environment-setup) - that's how we test this blueprint. The following are therefore assumed:
* You have uploaded all of the required plugins to your manager in order to use this blueprint. (See the imports section of the blueprint.yaml file to check that you are using the correct plugins and their respective versions.)
* You have created all of the required secrets on your manager in order to use this blueprint. (See #secrets.)
* A Centos 7.X image. If you are running in AWS or Openstack, your image must support [Cloud-init](https://cloudinit.readthedocs.io/en/latest/).


#### Secrets

* Common Secrets:
  * agent_key_private
  * agent_key_public

* Openstack Secrets:
  * external_network_name: This is the network on your Openstack that represents the internet gateway network.
  * public_network_name: An openstack network. (Inbound is expected, outbound is required.)
  * public_subnet_name: A subnet on the public network.
  * private_network_name: An openstack network. (Inbound is not expected, outbound is required.)
  * private_subnet_name: A subnet on the network. (Inbound is not expected, outbound is required.)
  * router_name: This is a router that is attached to your Subnets designated in the secrets public_subnet_name and private_subnet_name.
  * region: Your Keystone V2 region.
  * keystone_url: Your Keystone V2 auth URL.
  * keystone_tenant_name: Your Keystone V2 tenant name.
  * keystone_password: Your Keystone V2 password.
  * keystone_username:Your Keystone V2 username.


### Step 1: Install the Kubernetes cluster

#### For Openstack run:

Please follow the instruction on wiki
https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Cloudify#ONAPonKubernetesonCloudify-OpenStack


### Step 2: Verify the demo installed and started.

Once the workflow execution is complete, verify that these secrets were created:


```shell
(Incubator)UNICORN:Projects trammell$ cfy secrets list
Listing all secrets...

Secrets:
+------------------------------------------+--------------------------+--------------------------+------------+----------------+------------+
|                   key                    |        created_at        |        updated_at        | permission |  tenant_name   | created_by |
+------------------------------------------+--------------------------+--------------------------+------------+----------------+------------+
| kubernetes-admin_client_certificate_data | 2017-08-09 14:58:06.421  | 2017-08-09 14:58:06.421  |            | default_tenant |   admin    |
|     kubernetes-admin_client_key_data     | 2017-08-09 14:58:06.513  | 2017-08-09 14:58:06.513  |            | default_tenant |   admin    |
|  kubernetes_certificate_authority_data   | 2017-08-09 14:58:06.327  | 2017-08-09 14:58:06.327  |            | default_tenant |   admin    |
|           kubernetes_master_ip           | 2017-08-09 14:56:12.359  | 2017-08-09 14:56:12.359  |            | default_tenant |   admin    |
|          kubernetes_master_port          | 2017-08-09 14:56:12.452  | 2017-08-09 14:56:12.452  |            | default_tenant |   admin    |
+------------------------------------------+--------------------------+--------------------------+------------+----------------+------------+
```

