require 'socket'

if node[:platform] == "ubuntu"
  case node[:platform_version][/^.{2}/]
    when "10"
      default['ubuntu_release'] = "lucid"
    when "12"
      default['ubuntu_release'] = "precise"
    when "14"
      default['ubuntu_release'] = "trusty"
    else
      Chef::Log.error("Ambari only support Ubuntu 14.x/12.x/10.x")
      raise
  end
end

#Repository
default['ambari']['reposerver'] = "http://public-repo-1.hortonworks.com"
default['ambari']['version'] = "2.0.0"
default['yum']['gpgkey'] = "RPM-GPG-KEY/RPM-GPG-KEY-Jenkins"

default['apt']['key_server'] = "keyserver.ubuntu.com"
default['apt']['key'] = "B9733A7A07513CAD"

#General
default['ambari']['java_home'] = "#{node[:java][:home]}"
default['ambari-server']['user'] = "root"
default['ambari-server']['hostname'] = "vagrant-ubuntu-precise-64"
default['ambari-server']['ipaddress'] = Socket::getaddrinfo(node['ambari-server']['hostname'],Socket::AF_INET)[0][3] 

#Database
default["ambari"]["database"] = "postgres"
default["ambari"]["dbname"] = "ambari"
default["ambari"]["dbuser"] = "ambari"
default["ambari"]["dbpasswd"] = "ambari_password"
default["ambari"]["dbhost"] = "vagrant-ubuntu-precise-64"   #"#{node['ambari-server']['hostname']}"

#Postgresql
default["postgres"]["version"] = "9.1"
default["postgres"]["apt_key"] = "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
default["postgres"]["username"] = "postgres"
default["postgres"]["password"] = "postgres"
default["postgres"]["dbport"] = "5432"
default["postgres"]["dbdriver"] = "org.postgresql.Driver"
default["postgres"]["schema"] = "public"
default["postgres"]["jdbc_url"] = "jdbc:postgresql://#{node[:ambari][:dbhost]}:#{node[:postgres][:dbport]}/#{node[:ambari][:dbname]}"

#MySQL
default["mysql"]["username"] = "root" 
default["mysql"]["password"] = ""
default["mysql"]["dbport"] = "3306"
default["mysql"]["dbdriver"] = "com.mysql.jdbc.Driver"
default["mysql"]["jdbc_url"] = "jdbc:mysql://#{node[:ambari][:dbhost]}:#{node[:mysql][:dbport]}/#{node[:ambari][:dbname]}"


#Database JDBC url
case node[:ambari][:database]
when "mysql"
  default["ambari-server"]["jdbc_url"]  = "#{node[:mysql][:jdbc_url]}"
  default["ambari-server"]["jdbc_driver"] = "#{node[:mysql][:dbdriver]}"
  default["ambari-server"]["dbport"] = "#{node[:mysql][:dbport]}"
when "postgres"
  default["ambari-server"]["jdbc_url"] = "#{node[:postgres][:jdbc_url]}"
  default["ambari-server"]["jdbc_driver"] = "#{node[:postgres][:dbdriver]}"
  default["ambari-server"]["dbport"] = "#{node[:postgres][:dbport]}"
else 
  Chef::Log.error("Database: #{node[:ambari][:database]} is not supported by this module.")
end


##Validations
if ! ["1.7.0", "2.0.0", "2.0.1", "2.0.2","2.1.0","2.1.1","2.1.2"].include? node[:ambari][:version]
  Chef::Log.error("Supported Ambari versions are 1.7.0, 2.0.0, 2.0.1, 2.0.2, 2.1.0, 2.1.1 and 2.1.2.")
  raise
end

if ! ["mysql", "postgres"].include? node[:ambari][:database]
  Chef::Log.error("Supported Databases are 'mysql' and 'postgres'.")
end

if (node['ambari-server']['hostname']).length == 0
  Chef::Log.error("Ambari Server hostname can not be empty.")
  raise
elsif (node[:ambari][:dbhost]).length == 0
  Chef::Log.error("Ambari Database host can not be empty.")
  raise
end

#OS
if ! ["ubuntu", "redhat", "centos"].include?(node[:platform])
  Chef::Log.error("This module only supports Ubuntu and Redhat/CentOS")
  raise
end

if ! node[:ambari][:version][/^[12]\.\d\.[012]$/]
  Chef::Log.error("Invalid Ambari version!!")
  raise
end

case node[:platform]
  when "ubuntu"
    if node[:platform_version][/^.{2}/] == "14"
      if ! node[:ambari][:version] != "2.1.2"
        Chef::Log.error("Only Ambari version 2.1.2 supports Ubuntu 14.x Operating System.")
        raise
      end
    elsif node[:platform_version][/^.{2}/] == "12"
      if ! ["2.1.2", "2.0.2", "2.0.1","2.0.0", "1.7.0"].include? node[:ambari][:version]
        Chef::Log.error("Only Ambari version 2.1.2, 2.0.2, 2.0.1, 2.0.0 and 1.7.0 are capable of running on Ubuntu 12.")
        raise
      end
    end
  when "redhat", "centos"
    if node[:platform_version][/^.{1}/] == "7"
      if ! ["2.1.2", "2.1.1", "2.1.0"].include? node[:ambari][:version]
        Chef::Log.error("Only Ambari versions 2.1.2, 2.1.1 and 2.1.0 are capable of running on Redhat/Centos 7")
        raise
      end
    elsif node[:platform_version][/^.{1}/] == "6"
      if ! ["1.7.0", "2.0.0", "2.0.1", "2.0.2","2.1.0","2.1.1","2.1.2"].include? node[:ambari][:version]
        Chef::Log.error("Only Ambari versions 1.7.0, 2.0.0, 2.0.1, 2.0.2, 2.1.0, 2.1.1 and 2.1.2 are capable of running on Redhat/Centos 6.")
        raise
      end
    elsif node[:platform_version][/^.{1}/] == "5"
      if ! ["1.7.0", "2.0.0", "2.0.1", "2.0.2"].include? node[:ambari][:version]
        Chef::Log.error("Only Ambari versions 1.7.0, 2.0.0, 2.0.1 and 2.0.2 are capable of running on Redhat/Centos 5.")
        raise
      end
    end
end
