# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
# Recipe:: cm_server
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
#
#Sanity check
if node[:cm_server][:hostname] != node[:fqdn]
  Chef::Log.error("Current Machine hostname and [:cm][:hostname] attribute value don't match, make sure cm-server role is assigned to the correct host")
end

include_recipe "java_setup"
include_recipe "cloudera_manager::cm_repo"

if node[:cm][:database] == "mysql"
  cookbook_file "#{node[:mysql][:connector_path]}/#{node[:mysql][:connector]}" do
    source "#{node[:mysql][:connector]}"
    mode "0755"
    owner "root"
    group "root"
  end
end

package "cloudera-manager-server"

template "/etc/cloudera-scm-server/db.properties" do
	source "db.properties.erb"
	mode "0644"
	owner "root"
	group "root"
	notifies :restart, "service[cloudera-scm-server]", :immediately
end

service "cloudera-scm-server" do
	action [:start, :enable]
	supports :start => true, :restart => true, :stop => true
end

