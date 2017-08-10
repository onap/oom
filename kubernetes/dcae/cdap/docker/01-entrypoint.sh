#!/bin/bash

dpkg --install /tmp/dcae-apod-cdap-small-hadoop_1.1.0.deb
dpkg --install /tmp/dcae-apod-analytics-tca_1.1.0.deb

bash /opt/app/dcae-cdap-small-hadoop/install.sh
su dcae -c "/opt/app/dcae-controller-service-cdap-cluster-manager/bin/manager.sh config"
su dcae -c "/opt/app/dcae-controller-service-cdap-cluster-manager/bin/manager.sh restart"