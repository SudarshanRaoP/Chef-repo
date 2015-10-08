# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: ambari
# Recipe:: mysql
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
#Sanity check
if node[:fqdn] != node[:ambari][:dbhost]
  Chef::Log.error("Current host and [:ambari][:dbhost] don't match. Make sure recipe[ambari::mysql] is assigned to correct machine")
end

if node[:ambari][:database] != "mysql"
  Chef::Log.error("[:ambari][:database] is not set to 'mysql'.!!")
end

case node[:platform]
when "ubuntu"
  apt_package ["openssl", "libssl-dev"]
  execute "set_mysql_root_pw" do
    command "sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password #{node[:mysql][:password]}';sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password #{node[:mysql][:password]}'"
    action :nothing
    supports  :run => true
  end
  apt_package ["mysql-server", "libmysql-java"] do
    notifies :run, "execute[set_mysql_root_pw]", :immediately
    action :install
  end
  service "mysql" do
    action [:start, :enable]
  end
when "redhat", "centos"
  yum_package ["openssl", "openssl-devel", "mysql-server", "mysql-connector-java" ]
  service "mysqld" do 
    action [:start, :enable]
  end
else
  Chef::Log.error("OS Family '#{node[:platform_family]}' is not supported by this module.")
end
password = (node[:mysql][:password]) ? node[:mysql][:password] : ""
execute "ambari_db_user_setup_mysql" do
  command "echo #{password} | mysql -u root -p -e ""CREATE DATABASE #{node[:ambari][:dbname]};CREATE USER '#{node[:ambari][:dbuser]}'@'%' identified by '#{node[:ambari][:dbpasswd]}';GRANT ALL ON *.* TO '#{node[:ambari][:dbuser]}'@'%';CREATE USER '#{node[:ambari][:dbuser]}'@'localhost' identified by '#{node[:ambari][:dbpasswd]}';GRANT ALL ON *.* TO '#{node[:ambari][:dbuser]}'@'localhost';CREATE USER '#{node[:ambari][:dbuser]}'@'#{node["ambari-server"]["hostname"]}' identified by '#{node[:ambari][:dbpasswd]}';GRANT ALL ON *.* TO '#{node[:ambari][:dbuser]}'@'#{node["ambari-server"]["hostname"]}';"""
  action :run
  creates "/var/lib/mysql/#{node[:ambari][:dbname]}"
end
