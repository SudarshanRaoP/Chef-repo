#ROLES

## `cloudera_manager_server`

```json
"run_list": [
    "recipe[java_setup]",
    "recipe[cloudera_manager::cm_server]"
  ],
```

## `cloudera_manager_agent`

```json
"run_list": [
    "recipe[java_setup]",
    "recipe[cloudera_manager::cm_agent]"
  ],
```
