# Starter Helm Chart for ONAP Applications

Clone the onap-app directory and rename it to the name for your new Helm Chart.

Helm Charts for specific applications should be moved into the oom/kubernetes
directory. If the application is a common reusable Helm Chart (eg. mariadb), a
more appropriate location might be the oom/kubernetes/common directory.

Edit each yaml file in the new Helm Chart directoy, substituing real values
for those inside brackets (eg. `<onap-app>`). Some comments have been provided in
the file to help guide changes that need to be made. This starter Helm Chart is
in no way complete. It can serve as the basis for creating a new Helm Chart that
attempts to apply Helm best practices to ONAP applications being configured,
deployed and managed in Kubernetes.
