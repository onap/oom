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
