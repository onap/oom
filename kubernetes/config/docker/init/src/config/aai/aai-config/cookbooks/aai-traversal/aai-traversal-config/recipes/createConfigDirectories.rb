# Create or update the needed directories/links.
# If the directory already exists, it is updated to match
# 
# LOGROOT should already be created by the SWM installation script
# It needs to run as root 

[ 
	"#{node['aai-traversal-config']['LOGROOT']}/AAI-GQ",
  "#{node['aai-traversal-config']['LOGROOT']}/AAI-GQ/data",
	"#{node['aai-traversal-config']['LOGROOT']}/AAI-GQ/misc",
  "#{node['aai-traversal-config']['LOGROOT']}/AAI-GQ/ajsc-jetty" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0755'
    recursive=true
    action :create
  end
end

[ "#{node['aai-traversal-config']['PROJECT_HOME']}/bundleconfig/etc/auth" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0777'
    recursive=true
    action :create
  end
end
#Application logs
link "#{node['aai-traversal-config']['PROJECT_HOME']}/logs" do
  to "#{node['aai-traversal-config']['LOGROOT']}/AAI-GQ"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end

#Make a link from /opt/app/aai-traversal/scripts to /opt/app/aai-traversal/bin
link "#{node['aai-traversal-config']['PROJECT_HOME']}/scripts" do
  to "#{node['aai-traversal-config']['PROJECT_HOME']}/bin"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end
