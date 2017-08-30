################
# Update aaiResourcesConfig.properties 
################
include_recipe 'aai-resources-config::createConfigDirectories'
  
['aaiconfig.properties'].each do |file|
  template "#{node['aai-resources-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-resources-config/aaiconfig.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_SERVER_URL_BASE => node["aai-resources-config"]["AAI_SERVER_URL_BASE"],
:AAI_SERVER_URL => node["aai-resources-config"]["AAI_SERVER_URL"],
:AAI_GLOBAL_CALLBACK_URL => node["aai-resources-config"]["AAI_GLOBAL_CALLBACK_URL"],
:AAI_TRUSTSTORE_FILENAME => node["aai-resources-config"]["AAI_TRUSTSTORE_FILENAME"],
:AAI_TRUSTSTORE_PASSWD_X => node["aai-resources-config"]["AAI_TRUSTSTORE_PASSWD_X"],
:AAI_KEYSTORE_FILENAME => node["aai-resources-config"]["AAI_KEYSTORE_FILENAME"],
:AAI_KEYSTORE_PASSWD_X => node["aai-resources-config"]["AAI_KEYSTORE_PASSWD_X"],
:APPLICATION_SERVERS => node["aai-resources-config"]["APPLICATION_SERVERS"],
:TXN_HBASE_TABLE_NAME => node["aai-resources-config"]["TXN_HBASE_TABLE_NAME"],
:TXN_ZOOKEEPER_QUORUM => node["aai-resources-config"]["TXN_ZOOKEEPER_QUORUM"],
:TXN_ZOOKEEPER_PROPERTY_CLIENTPORT => node["aai-resources-config"]["TXN_ZOOKEEPER_PROPERTY_CLIENTPORT"],
:TXN_HBASE_ZOOKEEPER_ZNODE_PARENT => node["aai-resources-config"]["TXN_HBASE_ZOOKEEPER_ZNODE_PARENT"],
:RESOURCE_VERSION_ENABLE_FLAG => node["aai-resources-config"]["RESOURCE_VERSION_ENABLE_FLAG"],
    :AAI_NOTIFICATION_CURRENT_PACKAGE => node["aai-resources-config"]["AAI_NOTIFICATION_CURRENT_PACKAGE"],
    :AAI_NOTIFICATION_CURRENT_VERSION => node["aai-resources-config"]["AAI_NOTIFICATION_CURRENT_VERSION"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_STATUS => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_STATUS"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_TYPE => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_EVENT_TYPE"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_DOMAIN => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_DOMAIN"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_SOURCE_NAME => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SOURCE_NAME"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_SEQUENCE_NUMBER => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SEQUENCE_NUMBER"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_SEVERITY => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_SEVERITY"],
    :AAI_NOTIFICATION_EVENT_DEFAULT_VERSION => node["aai-resources-config"]["AAI_NOTIFICATION_EVENT_DEFAULT_VERSION"],
:AAI_DEFAULT_API_VERSION => node["aai-resources-config"]["AAI_DEFAULT_API_VERSION"]
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
