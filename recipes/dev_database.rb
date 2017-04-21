#
# Cookbook Name:: chef-lfucg
# Recipe:: dev_database
#
# Copyright (C) 2017 Chris Allen
#
# All rights reserved - Do Not Redistribute

execute "apt-get update" do
  action :nothing
end.run_action(:run)
include_recipe "postgresql::server"
include_recipe "database::postgresql"

postgresql_connection_info = {
  :host => '127.0.0.1',
  :port => '5432',
  :username => 'postgres',
  :password => 'password'
}

postgresql_database 'lfucg' do
  connection postgresql_connection_info
  action [:drop, :create]
end

if Dir.exists? "/home/vagrant"
  user = "vagrant"
else
  user = "ubuntu"
end
virtualenv = "/home/#{user}/env"

bash "dbinit" do
  user "#{user}"
  code "#{virtualenv}/bin/paster --plugin=ckan db init -c config.ini"
  cwd "/home/#{user}/data-lexingtonky/lfucg-ckan"
end