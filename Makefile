.PHONY: clean help
.DEFAULT_GOAL := help

PLAYBOOKS := playbooks
DOMAINS := terraform/domains
ANSIBLE_COMMON_ROLES := roles/common
ANSIBLE_OPTS := -v

playbook-gallifrey:  ## Run the gallifrey ansible playbook
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/gallifrey ansible-playbook gallifrey.yml $(ANSIBLE_OPTS)

playbook-pi:  ## Run the pi ansible playbook
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/pi ansible-playbook pi.yml $(ANSIBLE_OPTS)

terraform-plan-ovh-domains:  ## Plan the terraforming of the ovh DNS
	@cd $(DOMAINS)/ovh && terraform plan

terraform-apply-ovh-domains:  ## Terraform the ovh DNS
	@cd $(DOMAINS)/ovh && terraform apply

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}'

clean:  ## Remove useless files
	@find -name "*.retry" -or -name "*.tfstate.backup" | xargs rm
