Vagrant
=======

vagrant is to create kubernetes cluster using kubeadm.
kubernetes installation by kubeadm can be refered to
https://kubernetes.io/docs/getting-started-guides/kubeadm

Vagrant Setup
-------------

sudo apt-get install -y virtualbox
wget --no-check-certificate https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i vagrant_1.8.7_x86_64.deb

K8s Setup
---------

vagrant up

K8s Cleanup
-----------

vagrant destroy -f
