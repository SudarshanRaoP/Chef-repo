cloudera_manager Cookbook
================
This cookbook deploys mysql, postgresql,cloudera-manager-server and cloudera-manager-agent.

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
    <td><tt>['cm']['port']</tt></td>
    <td>String</td>
    <td>Cloudera Manager server port.</td>
    <td><tt>7182</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['database']</tt></td>
    <td>String</td>
    <td>Database type.</td>
    <td>mysql</td>
  </tr>
  <tr>
    <td><tt>['cm']['dbname']</tt></td>
    <td>String</td>
    <td>Cloudera Manager database name.</td>
    <td><tt>scm</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['dbuser']</tt></td>
    <td>String</td>
    <td>Cloudera Manager database user.</td>
    <td><tt>scm</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['dbpasswd']</tt></td>
    <td>String</td>
    <td>Cloudera Manager database password.</td>
    <td><tt>scm_password</tt></td>
  </tr>
  <tr>
    <td><tt>['cm_server']['hostname']</tt></td>
    <td>String</td>
    <td>Cloudera Manager server hostname.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['java_home']</tt></td>
    <td>String</td>
    <td>JAVA_HOME.</td>
    <td><tt>node[:java][:home]</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['dbhost']</tt></td>
    <td>String</td>
    <td>Database host.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['version]</tt></td>
    <td>String</td>
    <td>Cloudera Manager version</td>
    <td><tt>5</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['reposerver']</tt></td>
    <td>String</td>
    <td>Cloudera Manager repository server.</td>
    <td><tt>http://archive.cloudera.com</tt></td>
  </tr>
  <tr>
    <td><tt>['cm']['yum_gpgkey']</tt></td>
    <td>String</td>
    <td>Cloudera manager repository gpgkey..</td>
    <td><tt>RPM-GPG-KEY-cloudera</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['password']</tt></td>
    <td>String</td>
    <td>Mysql server password.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['connector']</tt></td>
    <td>String</td>
    <td>Mysql server connector.</td>
    <td><tt>mysql-connector-java.jar</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql']['connector_path']</tt></td>
    <td>String</td>
    <td>Mysql JDBC connector path.</td>
    <td><tt>/usr/share/java</tt></td>
  </tr>
</table>


Usage
-----
#### cloudera_manager::postgres
Just include `cloudera_manager::postgres` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cloudera_manager::postgres]"
  ]
}
```
#### cloudera_manager::mysql
Just include `cloudera_manager::mysql` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cloudera_manager::mysql]"
  ]
}
```
#### cloudera_manager::cm_repo
Just include `cloudera_manager::cm_repo` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cloudera_manager::cm_repo]"
  ]
}
```

#### cloudera_manager::cm_server
Just include `cloudera_manager::cm_server` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cloudera_manager::cm_server]"
  ]
}
```

#### cloudera_manager::cm_agent
Include `cloudera_manager::cm_agent` in your node's `run_list`, required recipes have been included:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cloudera_manager::cm_agent]"
  ]
}
```

License and Authors
-------------------
Author: Sudarshan

Copyright: 2015, P Sudarshan Rao <sudarshan.visham188@gmail.com>.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
