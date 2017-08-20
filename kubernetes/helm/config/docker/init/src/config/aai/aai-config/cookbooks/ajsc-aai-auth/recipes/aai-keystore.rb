cookbook_file "#{node['aai-app-config']['PROJECT_HOME']}/bundleconfig/etc/auth/aai_keystore" do
  source "aai_keystore-#{node['aai-app-config']['AAIENV']}"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
  action :create
end

