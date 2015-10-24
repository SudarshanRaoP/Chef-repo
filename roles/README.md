#ROLES

`cloudera_manager_server` : Cloudera Manager Server, does not include database module. Must be added before `role[cloudera_manager_server]` if database is to exist on the same machine as server.

```json
"run_list": [
    "recipe[java_setup]",
    "recipe[cloudera_manager::cm_server]"
  ],
```

`cloudera_manager_agent`

```json
"run_list": [
    "recipe[java_setup]",
    "recipe[cloudera_manager::cm_agent]"
  ],
```
