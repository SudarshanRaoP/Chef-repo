# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: ambari
# Recipe:: ambari_repo
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
  template "/etc/apt/sources.list.d/ambari.list" do
    source "ambari.list.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({
    :reposerver => node[:ambari][:reposerver],
    :release => node[:platform_version][/(^.{2})/],
    :version => node[:ambari][:version]
    })
  end
  execute "apt-key-add" do
    command "sudo apt-key adv --recv-keys --keyserver #{node[:apt][:key_server]} #{node[:apt][:key]} && sudo apt-get update"
    not_if do (%x(sudo apt-key list)).include? 'hortonworks' end
    notifies :run, "execute[sudo apt-get update -y]" ,:immediately
  end
  execute "sudo apt-get update -y" do
    action :nothing
    supports :run => true
  end
when "redhat", "centos"
  template "/etc/yum.repos.d/ambari.repo" do
    source "ambari.repo.erb"
    owner "root"
    group "root"
    mode "0644"
    variables({
    :reposerver => node[:ambari][:reposerver],
    :platform => "centos",
    :el => node[:platform_version][/(^.{1})/],
    :gpgkey => node[:yum][:gpgkey],
    :version => node[:ambari][:version]
    })
  end
else
  Chef::Log.error("Repository addition for #{node[:platform_family]} is not supported by this module.")
end
