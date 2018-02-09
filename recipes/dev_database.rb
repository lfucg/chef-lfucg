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

if Dir.exists? "/home/vagrant"
  user = "vagrant"
else
  user = "ubuntu"
end
virtualenv = "/home/#{user}/env"

bash "drop db" do
  user "#{user}"
  code "PGPASSWORD=password psql -U postgres -h 127.0.0.1 -c 'drop database lfucg'"
  ignore_failure true
end

bash "create db" do
  user "#{user}"
  code "PGPASSWORD=password psql -U postgres -h 127.0.0.1 -c 'create database lfucg'"
end

bash "db clean" do
  user "#{user}"
  code "#{virtualenv}/bin/paster --plugin=ckan db clean -c config.ini"
  cwd "/home/#{user}/data-lexingtonky/lfucg-ckan"
end

bash "db load" do
  user "#{user}"
  code "#{virtualenv}/bin/paster --plugin=ckan db load chef-lfucg/files/ckan_dev.sql  -c lfucg-ckan/config.ini"
  cwd "/home/#{user}/data-lexingtonky"
end

directory "/home/#{user}/uploads" do
    mode 0777
end
