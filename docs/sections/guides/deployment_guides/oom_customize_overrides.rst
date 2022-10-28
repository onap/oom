.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _helm deploy: https://github.com/onap/oom/blob/master/kubernetes/helm/plugins/deploy/deploy.sh

.. _oom_customize_overrides:

OOM Custom Overrides
####################

The OOM `helm deploy`_ plugin requires deployment configuration as input, usually in the form of override yaml files.
These input files determine what ONAP components get deployed, and the configuration of the OOM deployment.

Other helm config options like `--set log.enabled=true|false` are available.

See the `helm deploy`_ plugin usage section for more detail, or it the plugin has already been installed, execute the following::

    > helm deploy --help

Users can customize the override files to suit their required deployment.

.. note::
  Standard and example override files (e.g. `onap-all.yaml`, `onap-all-ingress-istio.yaml`)
  can be found in the `oom/kubernetes/onap/resources/overrides/` directory.

 * Users can selectively enable or disable ONAP components by changing the ``enabled: true/false`` flags.

 * Add to the command line a value for the global master password (ie. --set global.masterPassword=My_superPassw0rd).


Enabling/Disabling Components
-----------------------------
Here is an example of the nominal entries that need to be provided.
Different values files are available for different contexts.

.. collapse:: Default ONAP values.yaml

    .. include:: ../../../../kubernetes/onap/values.yaml
       :code: yaml

|

Some other heading
------------------
adva