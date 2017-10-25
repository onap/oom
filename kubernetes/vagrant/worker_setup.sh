#!/bin/bash

set -ex
sudo kubeadm join --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443 || true
