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

# Create or update the needed directories/links.
# If the directory already exists, it is updated to match
# 
# LOGROOT should already be created by the SWM installation script
# It needs to run as root 

[ 
	"#{node['aai-resources-config']['LOGROOT']}/AAI-RES",
  "#{node['aai-resources-config']['LOGROOT']}/AAI-RES/data",
	"#{node['aai-resources-config']['LOGROOT']}/AAI-RES/misc",
  "#{node['aai-resources-config']['LOGROOT']}/AAI-RES/ajsc-jetty" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0755'
    recursive=true
    action :create
  end
end

[ "#{node['aai-resources-config']['PROJECT_HOME']}/bundleconfig/etc/auth" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0777'
    recursive=true
    action :create
  end
end
#Application logs
link "#{node['aai-resources-config']['PROJECT_HOME']}/logs" do
  to "#{node['aai-resources-config']['LOGROOT']}/AAI-RES"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end

#Make a link from /opt/app/aai-resources/scripts to /opt/app/aai-resources/bin
link "#{node['aai-resources-config']['PROJECT_HOME']}/scripts" do
  to "#{node['aai-resources-config']['PROJECT_HOME']}/bin"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end
