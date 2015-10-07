# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: java_setup
# Recipe:: set_java_home
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
#Setting JAVA_HOME environment variable.
ruby_block "java_home" do
	block do
		ENV["JAVA_HOME"] = "#{node[:java][:home]}"
	end
	not_if { ENV["JAVA_HOME"] == "#{node[:java][:home]}" }
end
#Creating 'jdk.sh' to set JAVA_HOME
file "/etc/profile.d/jdk.sh" do
	content "export JAVA_HOME=#{node[:java][:home]}"
	mode '0755'
end