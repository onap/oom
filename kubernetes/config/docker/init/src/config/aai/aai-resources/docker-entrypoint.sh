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

cd /var/chef;

CHEF_CONFIG_REPO=${CHEF_CONFIG_REPO:-aai-config};

CHEF_GIT_URL=${CHEF_GIT_URL:-http://nexus.onap.org/r/aai};

CHEF_CONFIG_GIT_URL=${CHEF_CONFIG_GIT_URL:-$CHEF_GIT_URL};
CHEF_DATA_GIT_URL=${CHEF_DATA_GIT_URL:-$CHEF_GIT_URL};

if [ ! -d "aai-config" ]; then

    git clone --depth 1 -b ${CHEF_BRANCH} --single-branch ${CHEF_CONFIG_GIT_URL}/${CHEF_CONFIG_REPO}.git aai-config || {
        echo "Error: Unable to clone the aai-config repo with url: ${CHEF_GIT_URL}/${CHEF_CONFIG_REPO}.git";
        exit;
    }

    (cd aai-config/cookbooks/aai-resources/ && \
        for f in $(ls); do mv $f ../; done && \
        cd ../ && rmdir aai-resources);
fi


chef-solo \
    -c /var/chef/aai-data/chef-config/dev/.knife/solo.rb \
    -j /var/chef/aai-config/cookbooks/runlist-aai-resources.json \
    -E ${AAI_CHEF_ENV};

# TODO: If this runs, startup hangs and logs errors indicating aaiGraph.dev already exists in HBASE.
# Commenting out until we figure out whether it is needed or not.
# /opt/app/aai-resources/bin/createDBSchema.sh || {
#     echo "Error: Unable to create the db schema, please check if the hbase host is configured and up";
#     exit;
# }


java -cp ${CLASSPATH}:/opt/app/commonLibs/*:/opt/app/aai-resources/etc:/opt/app/aai-resources/lib/*:/opt/app/aai-resources/extJars/logback-access-1.1.7.jar:/opt/app/aai-resources/extJars/logback-core-1.1.7.jar:/opt/app/aai-resources/extJars/aai-core-${AAI_CORE_VERSION}.jar -server -XX:NewSize=512m -XX:MaxNewSize=512m -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -verbose:gc -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:-UseBiasedLocking -XX:ParallelGCThreads=4 -XX:LargePageSizeInBytes=128m -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Dsun.net.inetaddr.ttl=180 -XX:+HeapDumpOnOutOfMemoryError -Dhttps.protocols=TLSv1.1,TLSv1.2 -DSOACLOUD_SERVICE_VERSION=1.0.1 -DAJSC_HOME=/opt/app/aai-resources/ -DAJSC_CONF_HOME=/opt/app/aai-resources/bundleconfig -DAJSC_SHARED_CONFIG=/opt/app/aai-resources/bundleconfig -DAFT_HOME=/opt/app/aai-resources -DAAI_CORE_VERSION=${AAI_CORE_VERSION} -Daai-core.version=${AAI_CORE_VERSION} -Dlogback.configurationFile=/opt/app/aai-resources/bundleconfig/etc/logback.xml -Xloggc:/opt/app/aai-resources/logs/ajsc-jetty/gc/graph-query_gc.log com.att.ajsc.runner.Runner context=/ port=8087 sslport=8447