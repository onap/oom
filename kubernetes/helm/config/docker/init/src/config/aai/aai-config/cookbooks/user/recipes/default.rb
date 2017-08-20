#
# Cookbook Name:: user
# Recipe:: default
#
# Copyright 2015, AT&T
#
# All rights reserved - Do Not Redistribute
#
group 'aaiadmin' do
  append                     true
#gid                        492381
  members                   members ['aaiadmin']
  action                    :create
end

user 'aaiadmin' do
  comment                    "A&AI Application User"
  gid                        "aaiadmin"
  home                       "/opt/aaihome/aaiadmin"
  manage_home                true
  non_unique                 false
  shell                      "/bin/ksh"
#uid                        341790
  username                   "aaiadmin"
  ignore_failure             true 
  action                     :create
end
directory "/opt/aaihome/aaiadmin" do 
  owner 'aaiadmin'
  group 'aaiadmin'
	mode		"0755"
	ignore_failure	true
end
