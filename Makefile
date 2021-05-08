.PHONY: clean help terraform-plan-% terraform-apply-% playbook-% playbook-%-bootstrap terraform-init terraform-plan terraform-apply
.DEFAULT_GOAL := help

PLATFORM := $(shell uname -s)
ifeq ($(PLATFORM),Darwin)
    FIND = gfind
	ECHO = echo
else
    FIND = find
	ECHO = echo -e
endif


PLAYBOOKS := playbooks
ANSIBLE_COMMON_ROLES := roles/common
ANSIBLE_OPTS := -v
ANSIBLE_PLAYBOOK_CMD=poetry run ansible-playbook


playbook-%-bootstrap:  ## Bootstrap an instance. Replace '%' by the instance playbook you want to run
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* ANSIBLE_CONFIG=./ansible-bootstrap.cfg $(ANSIBLE_PLAYBOOK_CMD) --ask-pass $*-bootstrap.yml $(ANSIBLE_OPTS)

playbook-%:  ## Configure an instance. Replace '%' by the instance playbook you want to run
	@cd $(PLAYBOOKS) && ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* $(ANSIBLE_PLAYBOOK_CMD) $*.yml $(ANSIBLE_OPTS) $(target)

playbook-lint:  ## Lint role directories and playbook files
	@cd $(PLAYBOOKS) && \
	echo $$( $(FIND) roles/ -mindepth 2 -maxdepth 2 -type d && $(FIND) . -maxdepth 1 -name "*.yml") | xargs ansible-lint

terraform-%-plan:  ## Plan all terraform changes under the target directory %
	@cd terraform && source ./env.sh && cd $* && terraform plan

terraform-%-apply:  ## Apply all terraform changes under the target directory %
	@cd terraform && source ./env.sh && cd $* && terraform apply

terraform-init:  ## Initialize all terraform workspaces
	@cd terraform && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		cd $$dir && \
		echo "[+] Initializing $$dir" && \
		terraform init \
			-backend-config=../config.hcl \
			-backend-config="key=infra/$$dir.tfstate" && \
		cd .. && \
		$(ECHO) "\n"; \
	done

terraform-plan:  ## Plan all terraform workspaces
	@cd terraform && \
	source ./env.sh && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		cd $$dir && \
		echo "[+] Planning $$dir" && \
		terraform plan ; \
		cd .. && \
		$(ECHO) "\n"; \
	done

terraform-apply:  ## Apply all terraform workspaces
	@cd terraform && \
	source ./env.sh && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		cd $$dir && \
		echo "[+] Applying $$dir" && \
		terraform apply ; \
		cd .. && \
		$(ECHO) "\n"; \
	done

help:
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

clean:  ## Remove useless files
	@find . -name "*.retry" -or -name "*.tfstate.backup" | xargs rm
