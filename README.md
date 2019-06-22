This project defines my personal infrastucture as a set of terraform manifests and ansible playbooks.

## Terraforming the cloud resources

The terraform resources are organized by cloud provider (OVH, AWS, Scaleway, etc). To initialize each environment, run

```console
$ make terraform-init
```

To plan or apply all terraform resources from all workspaces, run

```console
$ make terraform-plan
$ make terraform-apply
```

To plan the terraforming of the resources of a given cloud provider (in that example, Scaleway), run

```console
$ make terraform-scaleway-plan
```

To apply these changes, run

```console
$ make terraform-scaleway-apply
```

## Configuring the instances

Before being able to configure the instances with the playbooks, we need to define their SSH configuration in `~/.ssh/config`, along with a common configuration

```
Host *
User br
ForwardX11 no
IdentityFile ~/.ssh/id_rsa
ControlPersist 30m
ControlMaster auto
ControlPath ~/.ssh/cm/control:%h:%p:%r

Host pi
HostName pi.balthazar-rouberol.com

Host gallifrey
HostName balthazar-rouberol.com

Host sophro
HostName sophrologie-chalon.com
```

and list the hosts in `/etc/ansible/hosts`:

```console
$ cat /etc/ansible/hosts
gallifrey
pi
sophro
```

To bootstrap a given instance (`gallifrey` in that example), run its bootstrap playbook (the first time only):

```console
$ make playbook-gallifrey-bootstrap
```

Once bootstraped, the instance can be configured via its regular playbook, run by

```console
$ make playbook-gallifrey
```