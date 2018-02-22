# Copyright © 2017 Amdocs
# Copyright © 2017 Bell Canada
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

['titan-realtime.properties'].each do |file|
  template "#{node['aai-resources-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-resources-config/titan-realtime.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:STORAGE_HOSTNAME => node["aai-resources-config"]["STORAGE_HOSTNAME"],
:STORAGE_HBASE_TABLE => node["aai-resources-config"]["STORAGE_HBASE_TABLE"],
:STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT => node["aai-resources-config"]["STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT"]
      )
  end
end

