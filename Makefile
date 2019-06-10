.PHONY: help
.DEFAULT_GOAL := help

PLAYBOOKS := playbooks
DOMAINS := terraform/domains

playbook-gallifrey:  ## Run the gallifrey ansible playbook
	@cd $(PLAYBOOKS) && ansible-playbook gallifrey/deploy.yml

playbook-pi:  ## Run the pi ansible playbook
	@cd $(PLAYBOOKS) && ansible-playbook pi/deploy.yml

terraform-plan-domains-balthazar-rouberol:  ## Plan the terraforming of the balthazar-rouberol.com DNS
	@cd $(DOMAINS)/balthazar-rouberol.com && terraform plan

terraform-apply-domains-balthazar-rouberol:  ## Terraform the balthazar-rouberol.com DNS
	@cd $(DOMAINS)/balthazar-rouberol.com && terraform apply

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
