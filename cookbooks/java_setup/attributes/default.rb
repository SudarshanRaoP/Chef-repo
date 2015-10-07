##Attribute file of 'java_setup' cookbook
#JDK 7 Update 45 tarball Linux 64 Bit.
default['java']['version'] = '1.7.0_45'
default['java']['base_dir'] = "/usr/java"
default['java']['tarfile'] = "jdk#{node[:java][:version]}.tar.gz" #jdk1.7.0_45.tar.gz
default['java']['remote_url'] = 'https://www.dropbox.com/s/a5giqphpj38uo1i/jdk1.7.0_45.tar.gz'
default['java']['home'] = "#{node[:java][:base_dir]}/jdk#{node[:java][:version]}"#/usr/java/jdk1.7.0_45
#JCE 7 zip
default['jce']['zipfile'] = "jce_policy.zip"

