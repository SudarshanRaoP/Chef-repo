require 'socket'
#OS
if ! ["ubuntu", "redhat", "centos"].include?(node[:platform])
  Chef::Log.error("This module only supports Ubuntu and Redhat/CentOS")
  raise
end

#Ubuntu OS codename
if node[:platform] == "ubuntu"
  case node[:platform_version][/^.{2}/]
    when "10"
      default['ubuntu_release'] = "lucid"
    when "12"
      default['ubuntu_release'] = "precise"
    else
      Chef::Log.error("Cloudera Manager only support Ubuntu 12.x/10.x")
      raise
  end
end

default['mysql']['password'] = ""
default['mysql']['connector'] = "mysql-connector-java.jar"
default['mysql']['connector_path'] = "/usr/share/java"
default['mysql']['dbport'] = "3306"
default['postgres']['version'] = "9.1"
default['postgres']['dbport'] = "5432"
default['postgres']['apt_key'] = "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
#Cloudera manager Server settings
default['cm']['port'] = "7182"
default['cm']['database'] = "postgres"
default['cm']['java_home'] = "#{node[:java][:home]}" #Comes from java_setup cookbook
default['cm']['dbname'] = "scm"
default['cm']['dbuser'] = "scm"
default['cm']['dbpasswd'] = "scm"
default['cm_server']['hostname'] = "vagrant-ubuntu-precise-64"
default['cm_server']['ipaddress'] = Socket::getaddrinfo(node['cm_server']['hostname'],Socket::AF_INET)[0][3]
default['cm']['dbhost'] = "vagrant-ubuntu-precise-64"
default['cm']['version'] = "5" # Single digit

##Settings validation
#Node architecture
if node[:kernel][:machine] != "x86_64"
  Chef::Log.error("System architecture is not 64 bit.")
  raise
end
#Cloudera Manager version
if ! ["4", "5"].include?(node[:cm][:version])
  Chef::Log.error("Supported values for Cloudera Manager version are 4 and 5.")
  raise
end

#Cloudera Manager server hostname
if (node[:cm][:dbhost]).length == 0
  raise ("Cloudera Manager database hostname is not set.")
elsif (node[:cm_server][:hostname]).length == 0
  raise ("Cloudera Manager server hostname is not set")
end
#Repository
default['cm']['reposerver'] = "http://archive.cloudera.com"
default['cm']['yum_gpgkey'] = "RPM-GPG-KEY-cloudera"
default['cm']['apt_key'] = "#{node[:cm][:reposerver]}/cm#{node[:cm][:version]}/ubuntu/#{node[:ubuntu_release]}/amd64/cm/archive.key"

#Databases
case node[:cm][:version]
when "4"
default['cm']['mgmnt'] = ["amon", "smon", "rman", "hmon", "hive", "nav"]
when "5"
default['cm']['mgmnt'] = ["amon", "rman", "hive", "sentry", "nav"]
else
  Chef::Log.error("This module only supports Cloudera Manager version 4 and 5")
end
#Database settings
default['cm']['amon'] = {"dbname" => "amon", 
			"dbuser" => "amon", 
			"dbpasswd" => "amon_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['smon'] = {"dbname" => "smon", 
			"dbuser" => "smon", 
			"dbpasswd" => "smon_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['rman'] = {"dbname" => "rman", 
			"dbuser" => "rman", 
			"dbpasswd" => "rman_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['hmon'] = {"dbname" => "hmon", 
			"dbuser" => "hmon", 
			"dbpasswd" => "hmon_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['hive'] = {"dbname" => "metastore", 
			"dbuser" => "hive", 
			"dbpasswd" => "hive_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['sentry'] = {"dbname" => "sentry", 
			"dbuser" => "sentry", 
			"dbpasswd" => "sentry_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}
default['cm']['nav'] = {"dbname" => "nav", 
			"dbuser" => "nav", 
			"dbpasswd" => "nav_password", 
			"dbhost" => "#{node[:cm_server][:hostname]}"}

