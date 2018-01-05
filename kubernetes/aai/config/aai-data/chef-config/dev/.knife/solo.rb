current_dir = File.dirname(__FILE__)
org         = ENV['CHEF_ORG']     || "aai-dev"
env         = ENV['AAI_CHEF_ENV'] || "dev"
env_path    = ENV['AAI_CHEF_LOC'] || ""
node_name                "chef-node"
cookbook_path [ "/var/chef/aai-config/cookbooks" ]
environment_path "#{env_path}"
log_level :info
log_location STDOUT
