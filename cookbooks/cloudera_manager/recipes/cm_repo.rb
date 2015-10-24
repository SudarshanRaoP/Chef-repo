# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
# Recipe:: cm_repo
#
# Copyright 2015, P Sudarshan Rao.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

case node[:platform]
when "ubuntu"
  template "/etc/apt/sources.list.d/cloudera.list" do
    source "cloudera.list.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({
    :reposerver => node[:cm][:reposerver],
    :version => node[:cm][:version],
    :release_tag => node[:ubuntu_release]
    }) 
  end
execute "apt-key-add" do
  command "curl -s #{node[:cm][:apt_key]} |sudo apt-key add -"
  not_if do ((%x(sudo apt-key list)).include? 'Cloudera Apt Repository') end
  notifies :run, "execute[sudo apt-get update -y]"
end
execute "sudo apt-get update -y" do
  action :nothing
  supports :run => true
end
when "redhat", "centos"
  template "/etc/yum.repos.d/cloudera-manager.repo" do
    source "cloudera-manager.repo.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({
    :reposerver => node[:cm][:reposerver],
    :version => node[:cm][:version],
    :gpgkey => node[:cm][:yum_gpgkey],
    :el => node[:platform_version][/(^.{1})/]	
    })
  end
else
  Chef::Log.error("#{node[:platform_family]} systems are not supported  by this module.")
end
