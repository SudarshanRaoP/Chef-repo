# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: ambari
# Recipe:: ambari-server
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
if node['ambari-server']['hostname']} != node[:fqdn]
	Chef::Log.error("Current host and ['ambari-server']['hostname'] mentioned in attribute do not match. Make sure role[ambari-server] is assigned to the correct machine.")
	raise
end

include_recipe "java_setup"
include_recipe "ambari::ambari_repo"

package "ambari-server" do
	action :install
	notifies :run, "bash[ambari-DDL]", :immediately
end


bash "ambari-DDL" do
case node[:ambari][:database]
when "postgres"
	code <<-EOF
	psql -h #{node[:ambari][:dbhost]} -U #{node[:ambari][:dbuser]} #{node[:ambari][:dbpasswd]} -d #{node[:ambari][:dbname]} -f /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql
	EOF
when "mysql"
	code <<-EOF
	mysql -u #{node[:ambari][:dbuser]} -h #{node[:ambari][:dbhost]} -p#{node[:ambari][:dbpasswd]} -D #{node[:ambari][:dbname]} -e "source /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql;"
	EOF
else
  Chef::Log.error("Unsupported Database!!")
end
	action :nothing
	supports :run => true
end

file "/etc/ambari-server/conf/password.dat" do
	content "#{node['ambari']['dbpasswd']}"
	mode '0440'
	owner "#{node['ambari-server']['user']}"
	group "#{node['ambari-server']['user']}"
end

template "/etc/ambari-server/conf/ambari.properties" do
	source "ambari.properties.erb"
	mode "0644"
	group "root"
	owner "root"
	notifies :restart, "service[ambari-server]", :delayed
	variables({
	:javahome => node[:ambari][:java_home],
	:jdbcurl => node['ambari-server']['jdbc_url'],
	:dbname => node[:ambari][:dbname],
	:dbdriver => node['ambari-server']['jdbc_driver'],
	:dbhost => node[:ambari][:dbhost],
	:dbuser => node[:ambari][:dbuser],	
	:ambari_user => node['ambari-server']['user'],
	:dbport => node['ambari-server']['dbport']
	})
end

py = %x(python -V)
case py
when py =~ /Python 2\.7/
  script "ambari-server" do
    interpreter "python2.7"
    code <<-EOH
import subprocess
status = subprocess.check_output("ambari-server status", shell=True)
if "not" in status:
	subprocess.call(["ambari-server", "start"])
else:
	pass
    EOH
    action :run
  end
when py =~ /Python 2\.6/
  script "ambari-server" do
    interpreter "python2.6"
    code <<-EOH
import subprocess
status = subprocess.Popen(["ambari-server","status"], stdout=subprocess.PIPE).communicate()
if "not" in status:
        subprocess.call(["ambari-server", "start"])
else:
        pass
    EOH
    action :run
  end
else
  Chef::Log.warn("Skipped Ambari server auto start. Could not find compatible version of Python. Please consider installing Python 2.6 or 2.7")
end

service "ambari-server" do
	init_command "/etc/init.d/ambari-server"
	action [:start, :enable]
	supports :restart => true
end
