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

