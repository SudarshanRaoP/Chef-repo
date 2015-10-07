ambari Cookbook
================
This cookbook deploys postgresql, ambari-server and ambari-agent.

Requirements
------------
jdk_jce cookbook

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
    <td><tt>['ambari']['postgres']['dbuser']</tt></td>
    <td>String</td>
    <td>Usename for postgres Superuser.</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['dbpasswd']</tt></td>
    <td>String</td>
    <td>Password for postgres user.</td>
  </tr>
  <tr>
    <td><tt>['ambari']['database']</tt></td>
    <td>String</td>
    <td>Type of database for Ambari.</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['username']</tt></td>
    <td>String</td>
    <td>Username for postgesql superuser.</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['password']</tt></td>
    <td>String</td>
    <td>Password for postgresql superuser.</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['dbport']</tt></td>
    <td>String</td>
    <td>Listen port for postgresql server.</td>
    <td><tt>5432</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['dbdirver']</tt></td>
    <td>String</td>
    <td>Driver class for postgresql.</td>
    <td><tt>org.postgresql.Driver</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['schema']</tt></td>
    <td>String</td>
    <td>Postgresql database schema.</td>
    <td><tt>public</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['postgres']['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC url for postgresql server</td>
    <td><tt>jdbc:postgresql://server_hostname:5432/ambari</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['mysql']['username']</tt></td>
    <td>String</td>
    <td>Username for mysql superuser.</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['mysql']['password']</tt></td>
    <td>String</td>
    <td>Password for mysql superuser.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['mysql']['dbport']</tt></td>
    <td>String</td>
    <td>Listen port for Mysql server.</td>
    <td><tt>3306</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['mysql']['dbdirver']</tt></td>
    <td>String</td>
    <td>Driver class for postgresql.</td>
    <td><tt>org.mysql.jdbc.Driver</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['mysql']['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC url for postgresql server</td>
    <td><tt>jdbc:mysql//server_hostname:3306/ambari</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari-server']['jdbc_url']</tt></td>
    <td>String</td>
    <td>JDBC driver for database.</td>
    <td><tt>Auto assigned based on type of database.</tt></td>
  </tr>
  <tr>
    <td><tt>['ambari']['dbname']</tt></td>
    <td>String</td>
    <td>Database name for Ambari</td>
    <td><tt>ambari</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['dbuser']</tt></td>
    <td>String</td>
    <td>Username for ambari database.</td>
    <td><tt>ambari</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['dbpasswd']</tt></td>
    <td>String</td>
    <td>Password for ambari database.</td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['jdbc_driver']</tt></td>
    <td>String</td>
    <td>Database driver class name.</td>
    <td><tt>Auto assigned based on type of database selected</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['dbhost']</tt></td>
    <td>String</td>
    <td>Database machine hostname</td>
    <td><tt>server.domain</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['dbport']</tt></td>
    <td>String</td>
    <td>Database listen port</td>
    <td><tt>5432</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['reposerver']</tt></td>
    <td>String</td>
    <td>Ambari public repository server.</td>
    <td><tt>http://public-repo-1.hortonworks.com</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['version']</tt></td>
    <td>String</td>
    <td>Ambari Version.</td>
    <td><tt>2.0.0</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['gpgkey']</tt></td>
    <td>String</td>
    <td>Repository gpgkey.</td>
    <td><tt>RPM-GPG-KEY/RPM-GPG-KEY-Jenkins</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['user']</tt></td>
    <td>String</td>
    <td>User to start Ambari server as.</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari']['java_home']</tt></td>
    <td>String</td>
    <td>Java home for ambari. Must be same as `[:jdk][:extracteddir]` from jdk_jce cookbook.</td>
    <td><tt>/usr/jdk64/jdk1.7.0_79</tt></td>
  </tr>
  <tr>
  <td><tt>['ambari-server']['hostname']</tt></td>
    <td>String</td>
    <td>Hostname of Ambari-server.</td>
    <td><tt>ambari-server.mydomain</tt></td>
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
    "recipe[ambari::postgres]"
  ]
}
```
#### ambari::ambari_repo
Just include `ambari::ambari_repo` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::ambari_repo]"
  ]
}
```

#### ambari::ambari-server
Just include `ambari::ambari-server` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::ambari-server]"
  ]
}
```

#### ambari::ambari-agent
Include `ambari::ambari-agent` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ambari::ambari-agent]"
  ]
}
```

License and Authors
-------------------
Author: Sudarshan

Copyright: 2015, Cloudwick Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
