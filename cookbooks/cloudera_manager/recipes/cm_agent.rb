# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
# Recipe:: cm_agent
#
# Copyright 2015, Cloudwick Inc.
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

include_recipe "java_setup"
include_recipe "cloudera_manager::cm_repo"

package "cloudera-manager-agent"

template "/etc/cloudera-scm-agent/config.ini" do
  source "config.ini.erb"
  mode "0644"
  owner "root"
  group "root"
  variables ({
  :cm_server => "#{node[:cm_server][:hostname]}",
  :cm_port => "#{node[:cm][:port]}"
  })
  notifies :restart, "service[cloudera-scm-agent]"
end

service "cloudera-scm-agent" do
  action [:start, :enable]
  supports :restart => true
end
