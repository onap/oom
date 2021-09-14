#============LICENSE_START========================================================
# ================================================================================
# Copyright (c) 2018 AT&T Intellectual Property. All rights reserved.
# Modifications Copyright © 2018 Amdocs, Bell Canada
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================

# DCAE Cloudify Manager Chart

This chart is used to deploy a containerized version of
[Cloudify Manager](http://docs.getcloudify.org/4.3.0/intro/cloudify-manager/),
the orchestration tool used by DCAE.  DCAE uses Cloudify Manager ("CM") to
deploy the rest of the DCAE platform as well to deploy DCAE monitoring and
analytics services dynamically, in response to network events such as VNF startups.

Deployment of CM is the first of two steps in deploying DCAE into ONAP.  After this chart
brings up CM, a second chart (the "bootstrap" chart) installs some plugin extensions onto CM
and uses CM to deploy some DCAE components.

## Prerequisites
The chart requires one Kubernetes secret to be available in the namespace where it is
being deployed:
  - `<namespace_name>-docker-registry-key`, the docker registry secret needed to pull images
  from the Docker repository.  This is the same secret used by other OOM charts.

## DCAE Namespace
DCAE will use CM deploy a number of containers into the ONAP Kubernetes cluster.  In a production
environment, DCAE's dynamic deployment of monitoring and analytics services could result in dozens
of containers being launched.  This chart allows the configuration, through the `dcae_ns` property
in the `values.yaml` of a separate namespace used by CM when it needs to deploy containers into
Kubernetes.  If `dcae_ns` is set, this chart will:
  - create the namespace.
  - create the Docker registry key secret in the namespace.
  - create some Kubernetes `Services` (of the `ExternalName` type) to map some addresses from the common namespace into the DCAE namespace.

## Use of Consul
DCAE uses [Consul](http://consul.io) to store configuration data for DCAE components.  In R1, DCAE
deployed its own Consul cluster.  In R2, DCAE will use the Consul server deployed by OOM.
