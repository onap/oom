################
# Update aaiconfig.properties 
######
include_recipe 'ajsc-aai-config::createConfigDirectories'
  
['aaiconfig.properties'].each do |file|
  template "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-app-config/#{file}"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:TOMCAT_SHUTDOWN_PORT_1 => node["aai-app-config"]["TOMCAT_SHUTDOWN_PORT_1"],
:TOMCAT_HTTP_SERVER_PORT_1 => node["aai-app-config"]["TOMCAT_HTTP_SERVER_PORT_1"],
:TOMCAT_HTTPS_SERVER_PORT_1 => node["aai-app-config"]["TOMCAT_HTTPS_SERVER_PORT_1"],
:TOMCAT_AJP13_CONNECTOR_PORT_1 => node["aai-app-config"]["TOMCAT_AJP13_CONNECTOR_PORT_1"],
:AAI_SERVER_URL_BASE => node["aai-app-config"]["AAI_SERVER_URL_BASE"],
:AAI_SERVER_URL => node["aai-app-config"]["AAI_SERVER_URL"],
:AAI_OLDSERVER_URL => node["aai-app-config"]["AAI_OLDSERVER_URL"],
:AAI_GLOBAL_CALLBACK_URL => node["aai-app-config"]["AAI_GLOBAL_CALLBACK_URL"],
:AAI_TRUSTSTORE_FILENAME => node["aai-app-config"]["AAI_TRUSTSTORE_FILENAME"],
:AAI_TRUSTSTORE_PASSWD_X => node["aai-app-config"]["AAI_TRUSTSTORE_PASSWD_X"],
:AAI_KEYSTORE_FILENAME => node["aai-app-config"]["AAI_KEYSTORE_FILENAME"],
:AAI_KEYSTORE_PASSWD_X => node["aai-app-config"]["AAI_KEYSTORE_PASSWD_X"],
:STORAGE_HOSTNAME => node["aai-app-config"]["STORAGE_HOSTNAME"],
:STORAGE_BACKEND => node["aai-app-config"]["STORAGE_BACKEND"],
:STORAGE_HBASE_TABLE => node["aai-app-config"]["STORAGE_HBASE_TABLE"],
:STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT => node["aai-app-config"]["STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT"],
:HBASE_COLUMN_TTL_DAYS => node["aai-app-config"]["HBASE_COLUMN_TTL_DAYS"],
:TXN_HBASE_TABLE_NAME => node["aai-app-config"]["TXN_HBASE_TABLE_NAME"],
:TXN_ZOOKEEPER_QUORUM => node["aai-app-config"]["TXN_ZOOKEEPER_QUORUM"],
:TXN_ZOOKEEPER_PROPERTY_CLIENTPORT => node["aai-app-config"]["TXN_ZOOKEEPER_PROPERTY_CLIENTPORT"],
:TXN_HBASE_ZOOKEEPER_ZNODE_PARENT => node["aai-app-config"]["TXN_HBASE_ZOOKEEPER_ZNODE_PARENT"],
:NOTIFICATION_HBASE_TABLE_NAME => node["aai-app-config"]["NOTIFICATION_HBASE_TABLE_NAME"],
:APPLICATION_SERVERS => node["aai-app-config"]["APPLICATION_SERVERS"],
:AAI_NOTIFICATION_CURRENT_VERSION => node["aai-app-config"]["AAI_NOTIFICATION_CURRENT_VERSION"],
:AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_STATUS => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_STATUS"],
:AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_TYPE => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_TYPE"],
:AAI_NOTIFICATION_EVENT_DEFAULT_DOMAIN => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_DOMAIN"],
:AAI_NOTIFICATION_EVENT_DEFAULT_SOURCE_NAME => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SOURCE_NAME"],
:AAI_NOTIFICATION_EVENT_DEFAULT_SEQUENCE_NUMBER => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SEQUENCE_NUMBER"],
:AAI_NOTIFICATION_EVENT_DEFAULT_SEVERITY => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SEVERITY"],
:AAI_NOTIFICATION_EVENT_DEFAULT_VERSION => node["aai-app-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_VERSION"],
:RESOURCE_VERSION_ENABLE_FLAG => node["aai-app-config"]["RESOURCE_VERSION_ENABLE_FLAG"],
:AAI_DEFAULT_API_VERSION => node["aai-app-config"]["AAI_DEFAULT_API_VERSION"],
:AAI_DMAPP_WORKLOAD_ENABLE_EVENT_PROCESSING => node["aai-app-config"]["AAI_DMAPP_WORKLOAD_ENABLE_EVENT_PROCESSING"]
      )
  end
end

#remote_directory "/opt/mso/etc/ecomp/mso/config/" do
#  source "mso-asdc-controller-config"
#  #cookbook "default is current"
#  files_mode "0700"
#  files_owner "jboss"
#  files_group "jboss"
#  mode "0755"
#  owner "jboss"
#  group "jboss"
#  overwrite true
#  recursive true
#  action :create
#end


################
# Alternative example1
# This updates all the timestamps
# Seting preserve never changes the timestamp when the file is changed
######
# ruby_block "copy_recurse" do
#   block do
#     FileUtils.cp_r("#{Chef::Config[:file_cache_path]}/cookbooks/mso-config/files/default/mso-api-handler-config/.",\
#       "/opt/mso/etc/ecomp/mso/config/", :preserve => true)  
#   end
#   action :run
# end

################
# Alternative example2
######
# Dir.glob("#{Chef::Config[:file_cache_path]}/cookbooks/mso-config/files/default/mso-api-handler-config/*").sort.each do |entry|
#   cookbook_file "/opt/mso/etc/ecomp/mso/config/#{entry}" do
#     source entry
#     owner "root"
#     group "root"
#     mode 0755
#   end
# end 
