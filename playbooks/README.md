## Configuring the instances

We're using `ansible` (specifically `ansible-playbook`and `ansible-vault`) to configure the cloud instances.

Each host has a bootstrap and regular playbook:
* the bootstrap playbook allows us to create the user used in the regular playbook, allow it to SSH, deny root ssh, etc
* the regular playbook does the rest

The ansible role layout is slighty different from a usual ansible layout:

```
playbooks
├── group_vars     # variables used by all hosts
├── host_vars      # per-host variables
├── macros         # jinja macros
└── roles
    ├── common     # roles used by several roles
    ├── gallifrey  # roles unique to gallifrey
    └── pi         # roles unique to pi
    ...
```

The ansible path is dynamically tweaked in the `Makefile` to include the roles for the host being deployed.
