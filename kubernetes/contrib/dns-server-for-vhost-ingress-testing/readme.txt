1. Motivations
	Ingress controller implementation in the ONAP cluster is based on the
	virtual host routing. Testing ONAP cluster requires a lot of entries on
	the target machines in the /etc/hosts. Adding many entries into the
	configuration files on testing machines is quite problematic and error prone.
	The better wait is to create central DNS server with entries for all
	virtual host pointed to simpledemo.onap.org and add custom DNS server as
	a target DNS server for testing machines and/or as external DNS for
	kubernetes cluster.

2. How to deploy test DNS server:
	Run script ./deploy_dns.sh

3.  How to add DNS address on testing machines:
	<See post deploy info>

4. Test DNS inside cluster (optional)
	a) You can add the following entry after DNS deploy on running cluster at
	the end of cluster.yaml file (rke)
		dns:
			provider: coredns
			upstreamnameservers:
				- <cluster_ip>:31555

	b)  You can edit coredns configuration with command:
		kubectl -n kube-system edit configmap coredns

