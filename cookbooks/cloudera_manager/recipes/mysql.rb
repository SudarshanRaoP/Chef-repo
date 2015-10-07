# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
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
if node[:fqdn] != node[:cm][:dbhost]
  Chef::Log.error("Current host and [:cm][:dbhost] don't match. Make sure recipe[cloudera-manager::mysql] is assigned to correct machine")
end

if node[:cm][:database] != "mysql"
  Chef::Log.error("[:cm][:database] is not set to 'mysql'.!!")
end


case node[:platform]
when "ubuntu"
  apt_package ["openssl", "libssl-dev"]
  execute "set_mysql_root_pw" do
    command "sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password #{node[:mysql][:password]}';sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password #{node[:mysql][:password]}'"
    action :run
  end
  apt_package ["mysql-server", "libmysql-java"]
  service "mysql" do
    action [:start, :enable]
  end
  template "/etc/my.cnf" do
    source "my.cnf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :run, "execute[ib_logfiles_delete]", :immediately
    notifies :restart, "service[mysql]", :immediately
  end
when "redhat", "centos"
  yum_package ["openssl", "openssl-devel", "mysql-server"]
  service "mysqld" do
    action [:start, :enable]
  end
  template "/etc/my.cnf" do
    source "my.cnf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :run, "execute[ib_logfiles_delete]", :immediately
    notifies :restart, "service[mysqld]", :immediately
  end
else
  Chef::Log.error("OS Family '#{node[:platform_family]}' is not supported by this module.")
end
execute "ib_logfiles_delete" do
  command "rm -rf /var/lib/mysql/ib_logfile*"
  action :nothing
  supports :run => true
end

execute "scm_db_setup_mysql" do
  command "echo #{node[:mysql][:password]} | mysql -u root -p -e ""CREATE DATABASES #{node[:cm][:dbname]};CREATE USER '#{node[:cm][:dbuser]}'@'localhost' identified by #{node[:cm][:dbpasswd]};GRANT ALL ON #{node[:cm][:dbname]}.* TO '#{node[:cm][:dbuser]}'@'localhost';CREATE USER '#{node[:cm][:dbuser]}'@'#{node[:cm][:hostname]}' identified by #{node[:cm][:dbpasswd]};GRANT ALL ON #{node[:cm][:dbname]}.* TO '#{node[:cm][:dbuser]}'@'#{node[:cm][:hostname]}';"""
  action :run
  creates "/var/lib/mysql/#{node[:cm][:dbname]}"
end

include_recipe "cloudera_manager::mgmnt_DDL"
