['aaiWorkloadConsumer.properties'].each do |file|
  template "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-app-config/aaiWorkloadConsumer.properties"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_WORKLOAD_SERVICE_NAME => node["aai-app-config"]["AAI_WORKLOAD_SERVICE_NAME"],
:AAI_WORKLOAD_ENVIRONMENT => node["aai-app-config"]["AAI_WORKLOAD_ENVIRONMENT"],
:AAI_WORKLOAD_USERNAME => node["aai-app-config"]["AAI_WORKLOAD_USERNAME"],
:AAI_WORKLOAD_PASSWORD => node["aai-app-config"]["AAI_WORKLOAD_PASSWORD"],
:AAI_WORKLOAD_HOST => node["aai-app-config"]["AAI_WORKLOAD_HOST"],
:AAI_WORKLOAD_AFT_DME2_EXCHANGE_REQUEST_HANDLERS => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_EXCHANGE_REQUEST_HANDLERS"],
:AAI_WORKLOAD_AFT_DME2_EXCHANGE_REPLY_HANDLERS => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_EXCHANGE_REPLY_HANDLERS"],
:AAI_WORKLOAD_AFT_DME2_REQ_TRACE_ON => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_REQ_TRACE_ON"],
:AAI_WORKLOAD_AFT_ENVIRONMENT => node["aai-app-config"]["AAI_WORKLOAD_AFT_ENVIRONMENT"],
:AAI_WORKLOAD_AFT_DME2_EP_CONN_TIMEOUT => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_EP_CONN_TIMEOUT"],
:AAI_WORKLOAD_AFT_DME2_ROUNDTRIP_TIMEOUT_MS => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_ROUNDTRIP_TIMEOUT_MS"],
:AAI_WORKLOAD_AFT_DME2_EP_READ_TIMEOUT_MS => node["aai-app-config"]["AAI_WORKLOAD_AFT_DME2_EP_READ_TIMEOUT_MS"],
:AAI_WORKLOAD_SESSION_STICKINESS_REQUIRED => node["aai-app-config"]["AAI_WORKLOAD_SESSION_STICKINESS_REQUIRED"],
:AAI_WORKLOAD_DME2_PREFERRED_ROUTER_FILE_PATH => node["aai-app-config"]["AAI_WORKLOAD_DME2_PREFERRED_ROUTER_FILE_PATH"],
:AAI_WORKLOAD_PARTNER => node["aai-app-config"]["AAI_WORKLOAD_PARTNER"], 
:AAI_WORKLOAD_ROUTE_OFFER => node["aai-app-config"]["AAI_WORKLOAD_ROUTE_OFFER"], 
:AAI_WORKLOAD_PROTOCOL => node["aai-app-config"]["AAI_WORKLOAD_PROTOCOL"],
:AAI_WORKLOAD_FILTER => node["aai-app-config"]["AAI_WORKLOAD_FILTER"],
:AAI_WORKLOAD_TOPIC => node["aai-app-config"]["AAI_WORKLOAD_TOPIC"],
:AAI_WORKLOAD_ID => node["aai-app-config"]["AAI_WORKLOAD_ID"],
:AAI_WORKLOAD_TIMEOUT => node["aai-app-config"]["AAI_WORKLOAD_TIMEOUT"],
:AAI_WORKLOAD_LIMIT => node["aai-app-config"]["AAI_WORKLOAD_LIMIT"]
      )
  end
end