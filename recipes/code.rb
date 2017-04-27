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

git_ssh_key = "#{app['app_source']['ssh_key']}"
git_url = "#{app['app_source']['url']}"
git_revision = "#{app['app_source']['revision']}" ? "#{app['app_source']['revision']}" : "master"


# Put the file on the node
file "/home/ubuntu/.ssh/id_rsa" do
  owner "ubuntu"
  mode 0400
  content "#{git_ssh_key}"
end

# Create wrapper script to use for git-ssh
file "/home/ubuntu/git_wrapper.sh" do
  owner "ubuntu"
  mode 0755
  content "#!/bin/sh\nexec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i \"/home/ubuntu/.ssh/id_rsa\" \"$@\""
end

git "/home/ubuntu/data-lexingtonky" do
  repository "#{git_url}"
  reference "#{git_revision}" # branch
  action :sync
  user "ubuntu"
  group "ubuntu"
  ssh_wrapper "/home/ubuntu/git_wrapper.sh"
end

template "/home/ubuntu/data-lexingtonky/lfucg-ckan/config.ini" do
  source "/home/ubuntu/data-lexingtonky/lfucg-ckan/config.ini.erb"
  local true
  mode 0644
  variables( :config => config )
end
