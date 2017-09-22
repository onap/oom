###
# ============LICENSE_START=======================================================
# org.openecomp.aai
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
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

# Set the current path to be the application home and common libs home
APP_HOME=$(pwd);
COMMONLIBS_HOME="/opt/app/commonLibs";

export CHEF_CONFIG_REPO=${CHEF_CONFIG_REPO:-aai-config};
export CHEF_GIT_URL=${CHEF_GIT_URL:-http://gerrit.onap.org/r/aai};
export CHEF_CONFIG_GIT_URL=${CHEF_CONFIG_GIT_URL:-$CHEF_GIT_URL};
export CHEF_DATA_GIT_URL=${CHEF_DATA_GIT_URL:-$CHEF_GIT_URL};

USER_ID=${LOCAL_USER_ID:-9001}

if [ $(cat /etc/passwd | grep aaiadmin | wc -l) -eq 0 ]; then
	useradd --shell=/bin/bash -u ${USER_ID} -o -c "" -m aaiadmin || {
		echo "Unable to create the user id for ${USER_ID}";
		exit 1;
	}
fi;

chown -R aaiadmin:aaiadmin /opt/app /var/chef /opt/aai/logroot

gosu aaiadmin ./init-chef.sh

httpPort=8087;
httpsPort=8447;

cd ${APP_HOME};

CP=${COMMONLIBS_HOME}/*;
CP="$CP":${APP_HOME}/etc;
CP="$CP":${APP_HOME}/lib/*;
CP="$CP":${APP_HOME}/extJars/logback-access-1.1.7.jar;
CP="$CP":${APP_HOME}/extJars/logback-core-1.1.7.jar;
CP="$CP":${APP_HOME}/extJars/aai-core-${AAI_CORE_VERSION}.jar;

# You can add additional jvm options by adding environment variable JVM_PRE_OPTS
# If you need to add more jvm options at the end then you can use JVM_POST_OPTS
JVM_OPTS="${JVM_PRE_OPTS} ${JVM_OPTS}";
JVM_OPTS="${JVM_OPTS} -server -XX:NewSize=512m -XX:MaxNewSize=512m";
JVM_OPTS="${JVM_OPTS} -XX:SurvivorRatio=8";
JVM_OPTS="${JVM_OPTS} -XX:+DisableExplicitGC -verbose:gc -XX:+UseParNewGC";
JVM_OPTS="${JVM_OPTS} -XX:+CMSParallelRemarkEnabled -XX:+CMSClassUnloadingEnabled";
JVM_OPTS="${JVM_OPTS} -XX:+UseConcMarkSweepGC -XX:-UseBiasedLocking";
JVM_OPTS="${JVM_OPTS} -XX:ParallelGCThreads=4";
JVM_OPTS="${JVM_OPTS} -XX:LargePageSizeInBytes=128m ";
JVM_OPTS="${JVM_OPTS} -XX:+PrintGCDetails -XX:+PrintGCTimeStamps";
JVM_OPTS="${JVM_OPTS} -Xloggc:${APP_HOME}/logs/gc/graph-query_gc.log";
JVM_OPTS="${JVM_OPTS} -XX:+HeapDumpOnOutOfMemoryError";
JVM_OPTS="${JVM_OPTS} ${JVM_POST_OPTS}";

# You can add additional java options by adding environment variable JAVA_PRE_OPTS
# If you need to add more jvm options at the end then you can use JAVA_POST_OPTS
JAVA_OPTS="${JAVA_PRE_OPTS} ${JAVA_OPTS}";
JAVA_OPTS="${JAVA_OPTS} -Dsun.net.inetaddr.ttl=180";
JAVA_OPTS="${JAVA_OPTS} -Dhttps.protocols=TLSv1.1,TLSv1.2";
JAVA_OPTS="${JAVA_OPTS} -DSOACLOUD_SERVICE_VERSION=1.0.1";
JAVA_OPTS="${JAVA_OPTS} -DAJSC_HOME=${APP_HOME}";
JAVA_OPTS="${JAVA_OPTS} -DAJSC_CONF_HOME=${APP_HOME}/bundleconfig";
JAVA_OPTS="${JAVA_OPTS} -DAJSC_SHARED_CONFIG=${APP_HOME}/bundleconfig";
JAVA_OPTS="${JAVA_OPTS} -DAFT_HOME=${APP_HOME}";
JAVA_OPTS="${JAVA_OPTS} -DAAI_CORE_VERSION=${AAI_CORE_VERSION}";
JAVA_OPTS="${JAVA_OPTS} -Daai-core.version=${AAI_CORE_VERSION}";
JAVA_OPTS="${JAVA_OPTS} -Dlogback.configurationFile=${APP_HOME}/bundleconfig/etc/logback.xml";
JAVA_OPTS="${JAVA_OPTS} ${JAVA_POST_OPTS}";

JAVA_ARGS="${JAVA_PRE_ARGS} ${JAVA_ARGS}";
JAVA_ARGS="${JAVA_ARGS} context=/";
JAVA_ARGS="${JAVA_ARGS} port=$httpPort";
JAVA_ARGS="${JAVA_ARGS} sslport=$httpsPort";
JAVA_ARGS="${JAVA_ARGS} ${JAVA_POST_ARGS}";

JAVA_CMD="exec gosu aaiadmin java";
# Run the following command as aai-admin using gosu and make that process main
${JAVA_CMD} -cp ${CLASSPATH}:${CP} ${JVM_OPTS} ${JAVA_OPTS} com.att.ajsc.runner.Runner ${JAVA_ARGS} "$@"
