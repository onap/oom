cookbook_file "#{node['aai-resources-config']['PROJECT_HOME']}/bundleconfig/etc/auth/aai_keystore" do
  source "aai_keystore-#{node['aai-resources-config']['AAIENV']}"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
  action :create
end

