# Copyright © 2018 Amdocs, Bell Canada
#
# This file is licensed under the CREATIVE COMMONS ATTRIBUTION 4.0 INTERNATIONAL LICENSE
#
# Full license text at https://creativecommons.org/licenses/by/4.0/legalcode

# Starter Helm Chart for ONAP Applications

Clone the onap-app directory and rename it to the name for your new Helm Chart.

Helm Charts for specific applications should be moved into the oom/kubernetes
directory. If the application is a common reusable Helm Chart (eg. mariadb), a
more appropriate location might be the oom/kubernetes/common directory.

Edit each yaml file in the new Helm Chart directory, substituting real values
for those inside brackets (e.g. `<onap-app>`). Some comments have been provided in
the file to help guide changes that need to be made. This starter Helm Chart is
in no way complete. It can serve as the basis for creating a new Helm Chart that
attempts to apply Helm best practices to ONAP applications being configured,
deployed and managed in Kubernetes.
