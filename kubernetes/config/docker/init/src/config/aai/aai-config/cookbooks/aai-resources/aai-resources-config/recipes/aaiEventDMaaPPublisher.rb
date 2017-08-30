['aaiEventDMaaPPublisher.properties'].each do |file|
  template "#{node['aai-resources-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-resources-config/aaiEventDMaaPPublisher.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_DMAAP_PROTOCOL => node["aai-resources-config"]["AAI_DMAAP_PROTOCOL"],
:AAI_DMAAP_HOST_PORT => node["aai-resources-config"]["AAI_DMAAP_HOST_PORT"],
:AAI_DMAAP_TOPIC_NAME => node["aai-resources-config"]["AAI_DMAAP_TOPIC_NAME"]
      )
  end
end

