# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: cloudera_manager
# Recipe:: postgres
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
  Chef::Log.error("Current host and [:cm][:dbhost] don't match. Make sure recipe[cloudera_manager::postgres] is assigned to correct machine")
end

if node[:cm][:database] != "postgres"
  Chef::Log.error("[:cm][:database] is not set to 'postgres'.!!")
end

case node[:platform]
when "ubuntu"
  template "/etc/apt/sources.list.d/pgdg.list" do
    source "pgdg.list.erb"
    owner "root"
    mode "755"
    group "root"
    variables ({
    :release_tag => node[:ubuntu_release]
    })
  end
  execute "apt-key-add" do
  command "curl -s #{node[:postgres][:apt_key]} |sudo apt-key add -"
  not_if do ((%x(sudo apt-key list)).include? 'PostgreSQL Debian Repository') end
  end
  apt_package "postgresql-#{node[:postgres][:version]}" do
    notifies :run, "bash[cm_db_user_setup_pg]", :delayed
  end
  service "postgresql" do
    action [:start, :enable]
    supports :restart => true, :reload => true
  end

  template "/etc/postgres/#{node[:postgres][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf.erb"
    mode "0640"
    owner "postgres"
    group "postgres"
    notifies :reload, "service[postgresql]", :immediately
  end
  template "/etc/postgres/#{node[:postgres][:version]}/main/postgresql.conf" do
    source "postgresql.conf.erb"
    mode "0644"
    owner "postgres"
    group "postgres"
    notifies :restart, "service[postgresql]", :immediately
  end
when "redhat", "centos"
  package "postgresql-server"
  execute "postgresql" do
    action :run
    command "service postgresql initdb"
    creates "/var/lib/pgsql/data"
    notifies :create, "template[/var/lib/pgsql/data/pg_hba.conf]", :immediately
    notifies :start, "service[postgresql]", :immediately
  end
  template "/var/lib/pgsql/data/pg_hba.conf" do
    source "pg_hba.conf.erb"
    mode '0640'
    owner "postgres"
    group "postgres"
    notifies :reload, "service[postgresql]", :immediately
  end
  template "/var/lib/pgsql/data/postgresql.conf" do
    source 'postgresql.conf.erb'
    mode '0644'
    owner 'postgres'
    group 'postgres'
    notifies :restart, "service[postgresql]", :immediately
  end
  service "postgresql" do
    action [:start, :enable]
    supports :start => true, :restart => true, :reload => true
  end
else
  Chef::Log.error("Operating System #{node[:platform]} is not yet supported by this module.")
end

bash "cm_db_user_setup_pg" do
  code <<-EOH
sudo -u postgres createuser -d -s -r #{node[:cm][:dbuser]}
sudo -u postgres createdb -O #{node[:cm][:dbuser]} #{node[:cm][:dbname]} 
echo -e "#{node[:cm][:dbpasswd]}\n#{node[:cm][:dbpasswd]}\n" | sudo -u postgres psql -c "\password #{node[:cm][:dbuser]};"
EOH
  action :run
  not_if do (%x(sudo -u postgres psql -c "\\l")).include? node[:cm][:dbname] end
end

include_recipe "cloudera_manager::mgmnt_DDL"
