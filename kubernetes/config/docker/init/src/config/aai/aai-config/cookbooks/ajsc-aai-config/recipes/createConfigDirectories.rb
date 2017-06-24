# Create or update the needed directories/links.
# If the directory already exists, it is updated to match
# 
# LOGROOT should already be created by the SWM installation script
# It needs to run as root 

execute "mv logs logs.bak" do
    only_if { ::File.directory?("#{node['aai-app-config']['PROJECT_HOME']}/logs") }
    user 'aaiadmin'
    group 'aaiadmin'
    cwd "#{node['aai-app-config']['PROJECT_HOME']}"
end

[ 
	"#{node['aai-app-config']['LOGROOT']}/AAI",
  "#{node['aai-app-config']['LOGROOT']}/AAI/data",
	"#{node['aai-app-config']['LOGROOT']}/AAI/misc",
  "#{node['aai-app-config']['LOGROOT']}/AAI/ajsc-jetty" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0755'
    recursive=true
    action :create
  end
end

[ "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/auth" ].each do |path|
  directory path do
    owner 'aaiadmin'
    group 'aaiadmin'
    mode '0777'
    recursive=true
    action :create
  end
end
#Application logs
link "#{node['aai-app-config']['PROJECT_HOME']}/logs" do
  to "#{node['aai-app-config']['LOGROOT']}/AAI"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end

#Make a link from /opt/app/aai/scripts to /opt/app/aai/bin
link "#{node['aai-app-config']['PROJECT_HOME']}/scripts" do
  to "#{node['aai-app-config']['PROJECT_HOME']}/bin"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
end

#Process logs??
#ln -s ${LOGROOT}/aai/servers/${server}/logs ${TRUE_PROJECT_HOME}/servers/${server}/logs
#link "#{node['aai-app-config']['PROJECT_HOME']}/servers/aai/logs" do
# to "#{node['aai-app-config']['LOGROOT']}/aai/servers/aai/logs"
#  owner 'aaiadmin'
# group 'aaiadmin'
#  mode '0755'
#end
