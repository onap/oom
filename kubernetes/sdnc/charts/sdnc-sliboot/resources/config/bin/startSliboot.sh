#!/bin/bash

###
# ============LICENSE_START=======================================================
# ONAP : CCSDK
# ================================================================================
# Copyright (C) 2020 AT&T Intellectual Property. All rights
#                             reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###

export CCSDK_HOME=${CCSDK_HOME:-/opt/onap/ccsdk}
export CCSDK_CONFIG_DIR=${CCSDK_CONFIG_DIR:-/opt/onap/ccsdk/config}
export SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
export SDNC_CONFIG_DIR=${SDNC_CONFIG_DIR:-/opt/onap/sdnc/config}
export SLIBOOT_JAR=${SLIBOOT_JAR:-${ccsdk.sliboot.jar}}
export SVCLOGIC_DIR=${SVCLOGIC_DIR:-opt/onap/sdnc/svclogic/graphs}
export LOG_PATH=${LOG_PATH:-/var/log/onap/sdnc}
export JAVA_SECURITY_DIR=${JAVA_SECURITY_DIR:-/etc/ssl/certs/java}


# Install ssl and java certificates
if $SDNC_AAF_ENABLED; then
	export SDNC_AAF_STORE_DIR=/opt/app/osaaf/local
	export SDNC_AAF_CONFIG_DIR=/opt/app/osaaf/local
	export SDNC_KEYPASS=`cat /opt/app/osaaf/local/.pass`
	export SDNC_KEYSTORE=org.onap.sdnc.p12
  	sudo cp $SDNC_AAF_STORE_DIR/truststoreONAPall.jks $JAVA_SECURITY_DIR
 	sudo keytool -importkeystore -srckeystore $JAVA_SECURITY_DIR/truststoreONAPall.jks -srcstorepass changeit -destkeystore $JAVA_SECURITY_DIR/cacerts  -deststorepass changeit
  	echo -e "\nCerts ready"
fi

cd $SDNC_HOME
java -DserviceLogicDirectory=${SVCLOGIC_DIR} -Dcadi_prop_files=${SDNC_AAF_CONFIG_DIR}/org.onap.sdnc.props -Dserver.ssl.key-store=${SDNC_AAF_STORE_DIR}/org.onap.sdnc.p12 -Dserver.ssl.key-store-password=${SDNC_KEYPASS} -Dserver.ssl.key-password=${SDNC_KEYPASS} -DLOG_PATH=${LOG_PATH} -jar ${CCSDK_HOME}/lib/${SLIBOOT_JAR}
