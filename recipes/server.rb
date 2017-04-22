#
# Cookbook:: chef-lfucg
# Recipe:: system
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# package "nginx"
include_recipe "apache2"
include_recipe 'python'
include_recipe "python::pip"

package "apache2-dev"

if Dir.exists? "/home/vagrant"
  user = "vagrant"
  domain = "localhost:8000"
else
  user = "ubuntu"
  app = search("aws_opsworks_app").first
  domain = "#{app['domains'][0]}"
end

virtualenv = "/home/#{user}/env"

python_pip "mod_wsgi" do
  version "4.5.2"
  virtualenv "#{virtualenv}"
end

bash "install_wsgi" do
  code "#{virtualenv}/bin/mod_wsgi-express install-module"
end

apache_module "wsgi_express" do
  identifier "wsgi_module"
  filename "mod_wsgi-py27.so"
end

web_app 'lfucg-ckan' do
  template "vhost.conf.erb"
  server_name "#{domain}"
  user "#{user}"
  docroot "/home/#{user}/data-lexingtonky/lfucg-ckan"
  project 'lfucg-ckan'
end

apache_site 'default' do
  enable false
end

service "apache2" do
    action [ :restart ]
end
