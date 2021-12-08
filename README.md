<!---
Copyright © 2021 Orange

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# ONAP Operations Manager

## Description

The ONAP Operations Manager (OOM) is responsible for life-cycle management of
the ONAP platform itself; components such as SO, SDNC, etc.

It is not responsible for the management of services, VNFs or infrastructure
instantiated by ONAP or used by ONAP to host such services or VNFs.

OOM uses the open-source Kubernetes container management system as a means to
manage the containers that compose ONAP where the containers are hosted either
directly on bare-metal servers or on VMs hosted by a 3rd party management
system.

OOM ensures that ONAP is easily deployable and maintainable throughout its life
cycle while using hardware resources efficiently.

Full documentation is available in ONAP documentation in [operations and
administration guides](
https://docs.onap.org/en/latest/guides/onap-operator/index.html).

## Contributing

Please see [contributing](./CONTRIBUTING.md) file to learn on how to contribute

## Issues

All issues should be filled in [ONAP Jira](https://jira.onap.org).

