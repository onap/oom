.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2021 Nokia

.. Links

.. _oom_customize_overrides:

Customizing OOM overrides
#########################



**Step 4.** Customize the Helm charts like `oom/kubernetes/onap/values.yaml` or
an override file like `onap-all.yaml`, `onap-vfw.yaml` or `openstack.yaml` file
to suit your deployment with items like the OpenStack tenant information.

.. note::
  Standard and example override files (e.g. `onap-all.yaml`, `openstack.yaml`)
  can be found in the `oom/kubernetes/onap/resources/overrides/` directory.


 a. You may want to selectively enable or disable ONAP components by changing
    the ``enabled: true/false`` flags.


 b. Encrypt the OpenStack password using the shell tool for Robot and put it in
    the Robot Helm charts or Robot section of `openstack.yaml`


 c. Encrypt the OpenStack password using the java based script for SO Helm
    charts or SO section of `openstack.yaml`.


 d. Update the OpenStack parameters that will be used by Robot and SO Helm
    charts or use an override file to replace them.

 e. Add in the command line a value for the global master password
    (global.masterPassword).



a. Enabling/Disabling Components:
Here is an example of the nominal entries that need to be provided.
We have different values file available for different contexts.

.. literalinclude:: ../kubernetes/onap/values.yaml
   :language: yaml


b. Generating ROBOT Encrypted Password:
The Robot encrypted Password uses the same encryption.key as SO but an
openssl algorithm that works with the python based Robot Framework.

.. note::
  To generate Robot ``openStackEncryptedPasswordHere``::

    cd so/resources/config/mso/
    /oom/kubernetes/so/resources/config/mso# echo -n "<openstack tenant password>" | openssl aes-128-ecb -e -K `cat encryption.key` -nosalt | xxd -c 256 -p``

c. Generating SO Encrypted Password:
The SO Encrypted Password uses a java based encryption utility since the
Java encryption library is not easy to integrate with openssl/python that
Robot uses in Dublin and upper versions.

.. note::
  To generate SO ``openStackEncryptedPasswordHere`` and ``openStackSoEncryptedPassword``
  ensure `default-jdk` is installed::

    apt-get update; apt-get install default-jdk

  Then execute::

    SO_ENCRYPTION_KEY=`cat ~/oom/kubernetes/so/resources/config/mso/encryption.key`
    OS_PASSWORD=XXXX_OS_CLEARTESTPASSWORD_XXXX

    git clone http://gerrit.onap.org/r/integration
    cd integration/deployment/heat/onap-rke/scripts

    javac Crypto.java
    java Crypto "$OS_PASSWORD" "$SO_ENCRYPTION_KEY"

d. Update the OpenStack parameters:

There are assumptions in the demonstration VNF Heat templates about the
networking available in the environment. To get the most value out of these
templates and the automation that can help confirm the setup is correct, please
observe the following constraints.


``openStackPublicNetId:``
  This network should allow Heat templates to add interfaces.
  This need not be an external network, floating IPs can be assigned to the
  ports on the VMs that are created by the heat template but its important that
  neutron allow ports to be created on them.

``openStackPrivateNetCidr: "10.0.0.0/16"``
  This ip address block is used to assign OA&M addresses on VNFs to allow ONAP
  connectivity. The demonstration Heat templates assume that 10.0 prefix can be
  used by the VNFs and the demonstration ip addressing plan embodied in the
  preload template prevent conflicts when instantiating the various VNFs. If
  you need to change this, you will need to modify the preload data in the
  Robot Helm chart like integration_preload_parameters.py and the
  demo/heat/preload_data in the Robot container. The size of the CIDR should
  be sufficient for ONAP and the VMs you expect to create.

``openStackOamNetworkCidrPrefix: "10.0"``
  This ip prefix mush match the openStackPrivateNetCidr and is a helper
  variable to some of the Robot scripts for demonstration. A production
  deployment need not worry about this setting but for the demonstration VNFs
  the ip asssignment strategy assumes 10.0 ip prefix.

Example Keystone v2.0

.. literalinclude:: yaml/example-integration-override.yaml
   :language: yaml

Example Keystone v3  (required for Rocky and later releases)

.. literalinclude:: yaml/example-integration-override-v3.yaml
   :language: yaml

