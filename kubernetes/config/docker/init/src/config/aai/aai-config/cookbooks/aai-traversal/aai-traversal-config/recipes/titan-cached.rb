['titan-cached.properties'].each do |file|
  template "#{node['aai-traversal-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-traversal-app-config/titan-cached.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:STORAGE_HOSTNAME => node["aai-traversal-config"]["STORAGE_HOSTNAME"],
:STORAGE_HBASE_TABLE => node["aai-traversal-config"]["STORAGE_HBASE_TABLE"],
:STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT => node["aai-traversal-config"]["STORAGE_HBASE_ZOOKEEPER_ZNODE_PARENT"],
:DB_CACHE_CLEAN_WAIT => node["aai-traversal-config"]["DB_CACHE_CLEAN_WAIT"],
:DB_CACHE_TIME => node["aai-traversal-config"]["DB_CACHE_TIME"],
:DB_CACHE_SIZE => node["aai-traversal-config"]["DB_CACHE_SIZE"]
      )
  end
end

