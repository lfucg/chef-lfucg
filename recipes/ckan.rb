#
# Cookbook Name:: chef-lfucg
# Recipe:: ckan
#
# Copyright (C) 2017 Chris Allen
#
# All rights reserved - Do Not Redistribute

include_recipe 'python'
include_recipe "python::pip"

if Dir.exists? "/home/vagrant"
  user = "vagrant"
else
  user = "ubuntu"
end
virtualenv = "/home/#{user}/env"

python_pip "-e 'git+https://github.com/ckan/ckan.git@ckan-2.6.2#egg=ckan'" do
    virtualenv "#{virtualenv}"
    user "#{user}"
    group "#{user}"
end

python_pip "--exists-action w -r #{virtualenv}/default/src/ckan/requirements.txt" do
    virtualenv "#{virtualenv}"
    user "#{user}"
    group "#{user}"
end