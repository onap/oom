current_dir = File.dirname(__FILE__)
log_level :info
log_location STDOUT
node_name "mso"
syntax_check_cache_path "#{current_dir}/syntaxcache"
cookbook_path ["/var/berks-cookbooks"]
environment_path "/var/berks-cookbooks/CHEF_REPO_NAME_TO_REPLACE/environments"
environment "mso-docker"

