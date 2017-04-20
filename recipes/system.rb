#
# Cookbook:: chef-lfucg
# Recipe:: system
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'python'
include_recipe "python::pip"
python_pip "virtualenv" do
  action :install
end

if Dir.exists? "/home/vagrant"
    user = "vagrant"
else
  user = "ubuntu"
end
virtualenv = "/home/#{user}/env"

package "my packages" do
  package_name [
    "git",
    "nginx",
    "libpq-dev",
    "solr-jetty",
    "redis-server"
  ]
  action :install
end

# NOTE: This will fail with SSL errors if owner/group isn't specified
python_virtualenv "#{virtualenv}" do
    # interpreter "/usr/bin/python"
    owner "#{user}"
    group "#{user}"
    options "--no-site-packages"
    action :create
end