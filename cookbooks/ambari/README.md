ambari Cookbook
================
This cookbook deploys mysql, postgresql, ambari-server and ambari-agent.

Supported OS:
Ubuntu 14*, 12
Redhat/CentOS 7*, 6, 5

Supported Ambari versions:
2.1.2 - 1.7.0

Supported Databases:
MySQL and Postgres

Requirements
------------
java_setup cookbook

Attributes
----------
<table>
  <tr>
  <th>Key</th>
  <th>Type</th>
  <th>Description</th>
  <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ambari']['reposerver']</tt></td>
    <td>String</td>
    <td>http url of Ambari public repo.</td>
    <td><tt>http://public-repo-1.hortonworks.com</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['version]</tt></td>
    <td>String</td>
    <td>Ambari Version to install. Supports Ambari 1.7.0 - 2.0.2</td>
    <td><tt>2.0.0</tt></td>
  </tr>
  <tr>
    <td><tt>['yum']['gpgkey']</tt></td>
    <td>String</td>
    <td>GPGKEY for YUM.</td>
    <td><tt>RPM-GPG-KEY/RPM-GPG-KEY-Jenkins</tt></td>
  </tr>
  <tr>
    <td><tt>['apt']['key_server']</tt></td>
    <td>String</td>
    <td>Key server fqdn for apt.</td>
    <td><tt>keyserver.ubuntu.com</tt></td>
  </tr>
  <tr>
    <td><tt>['apt']['key']</tt></td>
    <td>String</td>
    <td>Hortonworks apt key</td>
    <td><tt>B9733A7A07513CAD</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['java_home']</tt></td>
    <td>String</td>
    <td>JAVA_HOME</td>
    <td><tt>/usr/java/jdk1.7.0_45 (controlled from java_setup cookbook's `[:java][:home]` attribute)</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari-server']['user']</tt></td>
    <td>String</td>
    <td>User to start ambari server as.</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari-server']['hostname']</tt></td>
    <td>String</td>
    <td>FQDN of ambari server machine</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['database']</tt></td>
    <td>String</td>
    <td>Database for Ambari</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['dbname']</tt></td>
    <td>String</td>
    <td>Ambari Database name.</td>
    <td><tt>ambari</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['dbuser']</tt></td>
    <td>String</td>
    <td>Ambari database user</td>
    <td><tt>ambari</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['dbpasswd']</tt></td>
    <td>String</td>
    <td>Password for ambari database</td>
    <td><tt>ambari_password</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['dbhost']</tt></td>
    <td>String</td>
    <td>FQDN for Ambari Database machine.</td>
    <td><tt>Ambari server host.</tt></td>
  </tr>
  <tr>
    <td><tt>['postgres']['username']</tt></td>
    <td>String</td>
    <td>Superuser for Postgresql server</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['postgres']['password']</tt></td>
    <td>String</td>
    <td>Password for postgres user.</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['postgres']['dbport']</tt></td>
    <td>String</td>
    <td>postgresql server port</td>
    <td><tt>5432</tt></td>
  </tr>
  <tr>
  <td><tt>['postgres']['dbdriver']</tt></td>
    <td>String</td>
    <td>JDBC driver class for postgresql.</td>
    <td><tt>org.postgresql.Driver</tt></td>
  </tr>
  <tr>
  <td><tt>['postgres']['schema']</tt></td>
    <td>String</td>
    <td>Ambari database schema</td>
    <td><tt>public</tt></td>
  </tr>
  <tr>
  <td><tt>['postgres]['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC url for postgresql server.</td>
    <td><tt>jdbc:postgresql://database_host:port/ambari</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['username']</tt></td>
    <td>String</td>
    <td>Superuser for MySQL server</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['password']</tt></td>
    <td>String</td>
    <td>Password for root user.</td>
    <td><tt>]</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['dbport']</tt></td>
    <td>String</td>
    <td>MySQL server port</td>
    <td><tt>3306</tt></td>
  </tr>
  <tr>
  <td><tt>['mysql']['dbdriver']</tt></td>
    <td>String</td>
    <td>JDBC driver class for MySQL.</td>
    <td><tt>com.mysql.jdbc.Driver</tt></td>
  </tr>
  <tr>
  <td><tt>['mysql']['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC url for postgresql server.</td>
    <td><tt>jdbc:mysql://database_host:port/ambari</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC url for Ambari database</td>
    <td><tt>MySQL JDBC url or Postgres JDBC url based on ['ambari']['database']</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['dbport']</tt></td>
    <td>String</td>
    <td>Database port for Ambari database</td>
    <td><tt>MySQL port or Postgres port based on ['ambari']['database']</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['jdbc_driver']</tt></td>
    <td>String</td>
    <td>Driver class to use.</td>
    <td><tt>MySQL driver class or Postgres driver class based on ['ambari']['database']</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['version']</tt></td>
    <td>String</td>
    <td>Ambari Version.</td>
    <td><tt>2.0.0</tt></td>
  </tr>
</table>


Usage
-----
#### ambari::postgres
Just include `ambari::postgres` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::postgres]"
  ]
}
```
#### ambari::mysql
Just include `ambari::mysql` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::mysql]"
  ]
}
```

#### ambari::ambari-server
Just include `ambari::ambari-server` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::ambari_server]"
  ]
}
```

#### ambari::ambari-agent
Include `ambari::ambari-agent` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::ambari_agent]"
  ]
}
```

License and Authors
-------------------
Author: Sudarshan

Copyright: 2015, P Sudarshan Rao (<sudarshan.visham188@gmail.com>).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
