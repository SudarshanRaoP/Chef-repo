# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: java_setup
# Recipe:: default
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
#Installing 'tar'
package "tar"
#Creating Java Base directory
directory "#{node[:java][:base_dir]}" do
        mode "775"
        owner "root"
        group "root"
end
#Maintaning jdk<version>.tar.gz in Java base directory
cookbook_file "#{node[:java][:base_dir]}/#{node[:java][:tarfile]}" do
	source "#{node[:java][:tarfile]}"
	owner "root"
	group "root"
	mode "775"
	action :create
end
#Extracting Java from tar.gz.
execute "jdk_install" do
	cwd "#{node[:java][:base_dir]}"
	command "tar xzvf #{node[:java][:tarfile]}"
	creates "#{node[:java][:home]}"
end
#Calling recipies to install jce and to set JAVA_HOME
include_recipe "java_setup::jce_install"
include_recipe "java_setup::set_java_home"
