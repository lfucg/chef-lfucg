#
# Cookbook Name:: chef-lfucg
# Recipe:: code
#
# Copyright (C) 2017 Chris Allen
#
# All rights reserved - Do Not Redistribute
#

# Never run in vagrant, so assume AWS:
app = search("aws_opsworks_app").first
config = app['environment']

user = node['mobileserve']['user']
git_ssh_key = "#{app['app_source']['ssh_key']}"
git_url = "#{app['app_source']['url']}"
git_revision = "#{app['app_source']['revision']}" ? "#{app['app_source']['revision']}" : "master"


# Put the file on the node
file "/home/#{user}/.ssh/id_rsa" do
  owner "#{user}"
  mode 0400
  content "#{git_ssh_key}"
end

# Create wrapper script to use for git-ssh
file "/home/#{user}/git_wrapper.sh" do
  owner "#{user}"
  mode 0755
  content "#!/bin/sh\nexec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i \"/home/#{user}/.ssh/id_rsa\" \"$@\""
end

git "/home/#{user}/data-lexingtonky" do
  repository "#{git_url}"
  reference "#{git_revision}" # branch
  action :sync
  user "#{user}"
  group "#{user}"
  ssh_wrapper "/home/#{user}/git_wrapper.sh"
end

template "/home/#{user}/data-lexingtonky/lfucg-ckan/config.ini" do
  source "/home/#{user}/data-lexingtonky/lfucg-ckan/config.ini.erb"
  local true
  mode 0644
  variables( :config => config )
end
