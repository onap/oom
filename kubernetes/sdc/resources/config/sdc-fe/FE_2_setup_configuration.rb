jetty_base="/var/lib/jetty"
template "catalog-fe-config" do
   path "#{jetty_base}/config/catalog-fe/configuration.yaml"
   source "FE-configuration.yaml.erb"
   owner "jetty"
   group "jetty"
   mode "0755"
   variables({
      :fe_host_ip   => node['HOST_IP'],
      :be_host_ip   => "sdc-be.onap-sdc",
      :catalog_port => node['BE'][:http_port],
      :ssl_port     => node['BE'][:https_port]
   })
end

template "onboarding-fe-config" do
 path "#{jetty_base}/config/onboarding-fe/onboarding_configuration.yaml"
 source "FE-onboarding-configuration.yaml.erb"
 owner "jetty"
 group "jetty"
 mode "0755"
 variables({
    :catalog_ip   => node['HOST_IP'],
    :catalog_port => node['BE'][:http_port],
    :ssl_port     => node['BE'][:https_port]
})
end
