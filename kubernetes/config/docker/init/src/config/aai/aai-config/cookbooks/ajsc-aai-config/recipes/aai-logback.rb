################
# Update logback.xml
######
  
['logback.xml'].each do |file|
  template "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/#{file}" do
    source "aai-app-config/logback.erb"
    owner "aaiadmin"
    group "aaiadmin"
    mode "0777"
    variables(
:ORG_OPENECOMP_AAI_LEVEL => node["aai-app-config"]["ORG_OPENECOMP_AAI_LEVEL"]
      )
  end
end
