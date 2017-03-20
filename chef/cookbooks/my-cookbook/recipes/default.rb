#
# Cookbook Name:: my-cookbook
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.default['nginx']['repo_source'] = 'distro'

apt_update 'update'

package 'curl'

include_recipe 'chef_nginx::default'

directory node['nginx']['default_root'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
end

template "#{node['nginx']['default_root']}/index.html" do
  source 'index.html.erb'
  owner node['nginx']['user']
  group node['nginx']['group']
  mode 00744
end

nginx_site 'default' do
  action :disable
end

nginx_site 'Enable the test_site' do
  template 'site.erb'
  name 'test_site'
  action :enable
end
