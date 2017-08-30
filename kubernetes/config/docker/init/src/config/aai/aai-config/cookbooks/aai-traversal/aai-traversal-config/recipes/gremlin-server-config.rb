['gremlin-server-config.yaml'].each do |file|
  template "#{node['aai-traversal-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-traversal-app-config/gremlin-server-config.yaml"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_GREMLIN_SERVER_CONFIG_HOST_LIST => node["aai-traversal-config"]["AAI_GREMLIN_SERVER_CONFIG_HOST_LIST"]
      )
  end
end