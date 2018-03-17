['aaiEventDMaaPPublisher.properties'].each do |file|
  template "#{node['aai-traversal-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-traversal-app-config/aaiEventDMaaPPublisher.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_DMAAP_PROTOCOL => node["aai-traversal-config"]["AAI_DMAAP_PROTOCOL"],
:AAI_DMAAP_HOST_PORT => node["aai-traversal-config"]["AAI_DMAAP_HOST_PORT"],
:AAI_DMAAP_TOPIC_NAME => node["aai-traversal-config"]["AAI_DMAAP_TOPIC_NAME"]
      )
  end
end

