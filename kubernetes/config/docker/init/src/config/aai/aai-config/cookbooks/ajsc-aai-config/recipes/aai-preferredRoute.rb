['preferredRoute.txt'].each do |file|
  template "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/appprops/#{file}" do
    source "aai-app-config/preferredRoute.txt"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0644"
    variables(
:AAI_WORKLOAD_PREFERRED_ROUTE_KEY => node["aai-app-config"]["AAI_WORKLOAD_PREFERRED_ROUTE_KEY"]
      )
  end
end