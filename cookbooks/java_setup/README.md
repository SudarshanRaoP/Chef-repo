java_setup Cookbook
================
This cookbook installs Oracle JDK 7 and JCE 7.

Requirements
------------
No Requirements

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
    <td><tt>['java']['version']</tt></td>
    <td>String</td>
    <td>JDK version</td>
    <td><tt>1.7.0_45</tt></td>
  </tr>
  <tr>
    <td><tt>['java']['base_dir']</tt></td>
    <td>String</td>
    <td>base directory to put java in.</td>
    <td><tt>/usr/java/</tt></td>
  </tr>
  <tr>
    <td><tt>['jce']['zipfile']</tt></td>
    <td>String</td>
    <td>Oracle Java Cryptography Extention (JCE) zip.</td>
    <td><tt>jce_policy.zip</tt></td>
  </tr>
</table>


Usage
-----
#### java_setup::default
Just include `java_setup` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[java_setup]"
  ]
}
```

License and Authors
-------------------
Author: Sudarshan

Copyright: 2015, P Sudarshan Rao <sudarshan.visham188@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
