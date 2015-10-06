# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: java_setup
# Recipe:: jce_install
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

cookbook_file "#{node[:java][:base_dir]}/#{node[:jce][:zipfile]}" do
  source "#{node[:jce][:zipfile]}"
  owner "root"
  group "root"
  mode "775"
  action :create
end

execute "jce_install" do
  cwd "#{node[:java][:base_dir]}"
  command "unzip #{node[:jce][:zipfile]} && mv -f Unlimited*/*_policy.jar #{node[:java][:home]}/jre/lib/security/"
  creates "#{node[:java][:home]}/jre/lib/security/US_export_policy.jar"
  creates "#{node[:java][:home]}/jre/lib/security/local_policy.jar"    
end
