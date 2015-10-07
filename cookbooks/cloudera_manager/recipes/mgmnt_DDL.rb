# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
# Recipe:: mgmnt_DDL
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

case node[:cm][:database]
when "mysql"
node[:cm][:mgmnt].each do |mgmnt|
  execute "cm_mgmnt_db_setup_mysql" do
    command "echo #{node[:mysql][:password]} | mysql -u root -p -e ""CREATE DATABASE #{node[:cm][mgmnt][:dbname]};CREATE USER '#{node[:cm][mgmnt]['dbuser']}'@'%' identified by '#{node[:cm][mgmnt][:dbpasswd]}';GRANT ALL ON #{node[:cm][mgmnt][:dbname]}.* to '#{node[:cm][mgmnt][:dbuser]}'@'%';CREATE USER '#{node[:cm][mgmnt]['dbuser']}'@'localhost' identified by '#{node[:cm][mgmnt][:dbpasswd]}';GRANT ALL ON #{node[:cm][mgmnt][:dbname]}.* to '#{node[:cm][mgmnt][:dbuser]}'@'localhost';CREATE USER '#{node[:cm][mgmnt]['dbuser']}'@'#{node[:cm][mgmnt][:dbhost]}' identified by '#{node[:cm][mgmnt][:dbpasswd]}';GRANT ALL ON #{node[:cm][mgmnt][:dbname]}.* to '#{node[:cm][mgmnt][:dbuser]}'@'#{node[:cm][mgmnt][:dbhost]}';"""
  creates "/var/lib/mysql/#{node[:cm][mgmnt][:dbname]}"
  end
end
when "postgres"
node[:cm][:mgmnt].each do |mgmnt|
  bash "cm_mgmnt_db_setup_postgres" do
    code <<-EOH 
sudo -u postgres createuser -d -s -r #{node[:cm][mgmnt][:dbuser]}
sudo -u postgres createdb -O #{node[:cm][mgmnt][:dbuser]} #{node[:cm][mgmnt][:dbname]}
echo -e "#{node[:cm][mgmnt][:dbpasswd]}\n#{node[:cm][mgmnt][:dbpasswd]}\n" | sudo -u postgres psql -c "\password #{node[:cm][mgmnt][:dbuser]};"
    EOH
   action :run
   not_if do (%x(sudo -u postgres psql -c "\\l")).include? node[:cm][mgmnt][:dbname] end
   end
end
else
  Chef::Log.error("Unsupported Database! #{node[:cm][:database]}")
end


