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

# Install CKAN to virtualenv
python_pip "-e 'git+https://github.com/ckan/ckan.git@ckan-2.6.2#egg=ckan'" do
    virtualenv "#{virtualenv}"
    user "#{user}"
    group "#{user}"
end
python_pip "--exists-action w -r #{virtualenv}/src/ckan/requirements.txt" do
    virtualenv "#{virtualenv}"
    user "#{user}"
    group "#{user}"
end

# Setup Jetty
cookbook_file "/etc/default/jetty" do
  source 'jetty'
end

bash 'jetty schema' do
    code <<-EOH
    if [[ ! -L "/etc/solr/conf/schema.xml" ]]; then
      sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
      sudo ln -s #{virtualenv}/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
      sudo sed -i '/ROTATELOGS=\/usr\/sbin\/rotatelogs/c\ROTATELOGS=\/usr\/bin\/rotatelogs' /etc/init.d/jetty
    fi
    EOH
end
service "jetty" do
    action [ :restart ]
end