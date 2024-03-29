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

VAULT_PASSWORD_FILEPATH =
ANSIBLE_DIR := ansible
PLAYBOOKS_DIR := playbooks
ANSIBLE_COMMON_ROLES := $$HOME/.ansible/roles:roles/common
ANSIBLE_OPTS := -v --inventory inventory/hosts
ANSIBLE_chambonas_OPTS = --ask-become-pass
ANSIBLE_mac-perso_OPTS = --ask-become-pass
ANSIBLE_mac-pro_OPTS = --ask-become-pass
ANSIBLE_PLAYBOOK_CMD=poetry run ansible-playbook

ifneq ("$(wildcard $(ANSIBLE_DIR)/vault-password.txt)","")
    VAULT_PASS_OPTS = --vault-pass-file vault-password.txt
else
	VAULT_PASS_OPTS =
endif


playbook-%-bootstrap:  ## Bootstrap an instance. Replace '%' by the instance playbook you want to run
	@cd $(ANSIBLE_DIR) && \
		ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* \
		ANSIBLE_CONFIG=./ansible-bootstrap.cfg \
		$(ANSIBLE_PLAYBOOK_CMD) \
		$(PLAYBOOKS_DIR)/$*-bootstrap.yml \
		$(ANSIBLE_OPTS)


playbook-%:  ## Configure an instance. Replace '%' by the instance playbook you want to run
	@TAGS_OPTS=""
	@if [[ -n "${tags}" ]]; then TAGS_OPTS="-t ${tags}"; fi && \
		cd $(ANSIBLE_DIR) && \
		ANSIBLE_ROLES_PATH=$(ANSIBLE_COMMON_ROLES):roles/$* \
			$(ANSIBLE_PLAYBOOK_CMD) \
			$(PLAYBOOKS_DIR)/$*.yml \
			$(ANSIBLE_OPTS) \
			$(VAULT_PASS_OPTS) \
			$(ANSIBLE_$*_OPTS) \
			$$TAGS_OPTS

playbook-lint:  ## Lint role directories and playbook files
	@cd $(ANSIBLE_DIR) && \
	echo $$( $(FIND) roles/ -mindepth 2 -maxdepth 2 -type d && $(FIND) . -maxdepth 1 -name "*.yml") | xargs ansible-lint

terraform-%-plan:  ## Plan all terraform changes under the target directory %
	@cd terraform && source ./env.sh && cd $* && terraform plan

terraform-%-apply:  ## Apply all terraform changes under the target directory %
	@cd terraform && source ./env.sh && cd $* && terraform apply

terraform-init:  ## Initialize all terraform workspaces
	@cd terraform && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		pushd $$dir && \
		echo "[+] Initializing $$dir" && \
		terraform init \
			-backend-config=../config.hcl \
			-backend-config="key=infra/$$dir.tfstate" && \
		popd && \
		$(ECHO) "\n"; \
	done

terraform-plan:  ## Plan all terraform workspaces
	@cd terraform && \
	source ./env.sh && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		pushd $$dir && \
		echo "[+] Planning $$dir" && \
		terraform plan ; \
		popd && \
		$(ECHO) "\n"; \
	done

terraform-apply:  ## Apply all terraform workspaces
	@cd terraform && \
	source ./env.sh && \
	for dir in $$($(FIND) . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v global_vars); do \
		pushd $$dir && \
		echo "[+] Applying $$dir" && \
		terraform apply ; \
		podp && \
		$(ECHO) "\n"; \
	done


dependencies:  ## Install python and ansible dependencies
	@poetry install
	@poetry run ansible-galaxy install -r $(ANSIBLE_DIR)/requirements.yaml


patch-ansible:  ## Patch ansible to allow jinja templates to be discoverable in the ansible role path
	# cf https://github.com/ansible/ansible/issues/20442#issuecomment-276091389
	@patch $$(poetry run python -c 'import site;print(site.getsitepackages()[0])')/ansible/plugins/action/template.py < misc/ansible-role-searchpath.diff

install: dependencies patch-ansible  ## Install all dependencies and setup ansible

help:
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

clean:  ## Remove useless files
	@find . -name "*.retry" -or -name "*.tfstate.backup" | xargs rm
