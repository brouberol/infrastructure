.PHONY: clean help terraform-plan-% terraform-apply-% playbook-% playbook-%-bootstrap
.DEFAULT_GOAL := help

PLAYBOOKS := playbooks
ANSIBLE_COMMON_ROLES := roles/common
ANSIBLE_OPTS := -v

playbook-%:  ## Configure an instance. Replace '%' by the instance playbook you want to run
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* ansible-playbook $*.yml $(ANSIBLE_OPTS)

playbook-%-bootstrap:  ## Bootstrap an instance. Replace '%' by the instance playbook you want to run
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* ansible-playbook $*-bootstrap.yml $(ANSIBLE_OPTS)

terraform-%-plan:  ## Plan all terraform changes under the target directory %
	@cd terraform/$* && terraform plan

terraform-%-apply:  ## Apply all terraform changes under the target directory %
	@cd terraform/$* && terraform apply

help:
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

clean:  ## Remove useless files
	@find -name "*.retry" -or -name "*.tfstate.backup" | xargs rm
