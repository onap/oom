# Copyright © 2018 Amdocs, Bell Canada
#
# This file is licensed under the CREATIVE COMMONS ATTRIBUTION 4.0 INTERNATIONAL LICENSE
#
# Full license text at https://creativecommons.org/licenses/by/4.0/legalcode

This directory contains all external configuration files that
need to be mounted into an application container.

See the configmap.yaml in the templates directory for an example
of how to load (ie map) config files from this directory, into
Kubernetes, for distribution within the k8s cluster.

See deployment.yaml in the templates directory for an example
of how the 'config mapped' files are then mounted into the
containers.
