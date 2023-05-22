## Configuring the instances

We're using `ansible` (specifically `ansible-playbook`and `ansible-vault`) to configure the cloud instances.

Each host has a bootstrap and regular playbook:
* the bootstrap playbook allows us to create the user used in the regular playbook, allow it to SSH, deny root ssh, etc
* the regular playbook does the rest

The project layout is slighty different from the usual one:

```
├── ansible-bootstrap.cfg   # ansible config file used for bootstrap playbooks
├── ansible.cfg             # ansible config file used for regular playbooks
├── inventory               # hosts and host/group variables
│   ├── group_vars          # variables defined for specific groups
│   │   ├── all
│   │   ├── mac
│   │   └── rpi
│   ├── host_vars           # variables defined for specific hosts
│   │   ├── chambonas
│   │   ├── gallifrey
│   │   ├── mac-perso
│   │   ├── mac-pro
│   │   ├── pi
│   │   └── pistou
│   └── hosts               # definition of hosts and groups
├── playbooks               # 2 playbooks per host: bootstrap and regular
│   ├── gallifrey-bootstrap.yml
│   ├── gallifrey.yml
│   ...
├── roles
...
│   ├── common              # common roles, usable from any playbook
│   │   ...
│   │   ├── macros          # macros usable from any role
│   │   │   ├── nginx_proxy_pass.j2
│   │   │   ├── nginx_static.j2
│   │   │   ├── ssh_user_authorized_keys.j2
│   │   │   └── systemd_user_service.j2
│   └── pistou              # host-specific roles
│       ├── bazarr
│       │   └── tasks
│       │       └── main.yml
│       ├── jackett
│       │   └── tasks
│       │       └── main.yml
│       ├── radarr
│       │   └── tasks
│       │       └── main.yml
...
```

The ansible path is dynamically tweaked in the `Makefile` to include the roles for the host being deployed, and we rely on an [unofficial patch](https://github.com/brouberol/infrastructure/blob/b55bd2737526dc2501fdf0b4fddf50d0c85a0f62/misc/ansible-role-searchpath.diff) to make the common macros discoverable from any role, after (what I think is) a regression in Ansible.
