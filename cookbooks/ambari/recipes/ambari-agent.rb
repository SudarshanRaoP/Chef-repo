# Author:: Sudarshan (<sudarshan.visham188@gmail.com>)
# Cookbook Name:: ambari
# Recipe:: ambari-agent
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
include_recipe "java_setup"
include_recipe "ambari::ambari_repo"


package "ambari-agent" do
	action :install
	notifies :run, "bash[disable_thp]", :delayed
end

bash "disable_thp" do
  action :nothing
  case node[:platform]
  when "ubuntu", "centos"
    code <<-EOH
echo "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/transparent_hugepage/defrag ;fi" >> /etc/rc.local
    EOH
  when "redhat"
  code <<-EOH
echo "if test -f /sys/kernel/mm/redhat_transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag ;fi" >> /etc/rc.local
    EOH
  else
    Chef::Log.error("Os Platform not supported by this module")
  end
  supports :run => true
end

template "/etc/ambari-agent/conf/ambari-agent.ini" do
  source "ambari-agent.ini.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[ambari-agent]", :delayed
end

py = %x(python -V)
case py
when py =~ /Python 2\.7/
  script "ambari-agent" do
    interpreter "python2.7"
    code <<-EOH
import subprocess
status = subprocess.check_output("ambari-agent status", shell=True)
if "not" in status:
        subprocess.call(["ambari-agent", "start"])
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
status = subprocess.Popen(["ambari-agent","status"], stdout=subprocess.PIPE).communicate()
if "not" in status:
        subprocess.call(["ambari-agent", "start"])
else:
        pass
    EOH
    action :run
  end
else
  Chef::Log.warn("Skipped Ambari server auto start. Could not find compatible version of Python. Please consider installing Python 2.6 or 2.7")
end

case node[:platform]
when "ubuntu","centos"
  execute "disable_thp" do
    action :run
    command "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag ;fi"
  end
when "redhat"
  execute "disable_thp" do
    action :run
    command "if test -f /sys/kernel/mm/redhat_transparent_hugepage/defrag; then echo never > /sys/kernel/mm/transparent_hugepage/defrag ;fi"
  end
else
  Chef::Log.error("OS platform #{node[:platform]} not supported by this module.")	
end

service "ambari-agent" do
  init_command "/etc/init.d/ambari-agent"
  action [:start, :enable]
  supports :restart => true
end

service "ntpd" do
  action [:start, :enable]
end

service "iptables" do
  action [:stop, :disable]
end
