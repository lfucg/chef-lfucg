#
# Cookbook:: chef-lfucg
# Recipe:: ckan
#
# Copyright:: 2017, The Authors, All Rights Reserved.


if Dir.exists? "/home/vagrant"
    user = "vagrant"
else
  user = "ubuntu"
end

directory "/home/#{user}/uploads" do
    recursive true
    mode 0777
end
