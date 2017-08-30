cookbook_file "#{node['aai-traversal-config']['PROJECT_HOME']}/bundleconfig/etc/auth/aai_keystore" do
  source "aai_keystore-#{node['aai-traversal-config']['AAIENV']}"
  owner 'aaiadmin'
  group 'aaiadmin'
  mode '0755'
  action :create
end

