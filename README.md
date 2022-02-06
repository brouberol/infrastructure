This project defines my personal infrastucture as a set of terraform manifests and ansible playbooks, as detailed in the [following blogpost](https://blog.balthazar-rouberol.com/managing-my-infra-like-its-2019).

The main idea is to centralize all configuration, whether they apply to instances or cloud services, and make it easy to add new services, secure and monitor them properly.

![infra](https://user-images.githubusercontent.com/480131/150144356-3c6f946e-bb21-4f7e-8964-5cdca8deb473.png)

## Terraforming the cloud resources

### Credentials setup

The first step is to create API keys for every single terraform provider being used, and add them to local config files:

- [aws](https://www.terraform.io/docs/providers/aws/index.html)
- [scaleway](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file)
- [ovh](https://www.terraform.io/docs/providers/ovh/index.html#configuration-of-the-provider)
- [datadog](https://www.terraform.io/docs/providers/datadog/index.html#argument-reference) (the Datadog provider does not yet support parsing the `~/.dogrc` configuration file, meaning I had to [hack](https://github.com/brouberol/infrastructure/blob/master/terraform/env.sh#L1) something together)

### Creating cloud resources

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
HostName home.balthazar-rouberol.com

Host gallifrey
HostName balthazar-rouberol.com
```

and list the hosts in `/etc/ansible/hosts`:

```console
$ cat /etc/ansible/hosts
gallifrey
pi
```

To bootstrap a given instance (`gallifrey` in that example), run its bootstrap playbook (the first time only):

```console
$ make playbook-gallifrey-bootstrap
```

Once bootstraped, the instance can be configured via its regular playbook, run by

```console
$ make playbook-gallifrey
```
