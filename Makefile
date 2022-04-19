.DEFAULT_GOAL = help
.PHONY: help

ENV ?= dev


init-terraform:  ## Setup Terraform and validate
	 terraform init

tf-ns-create:  ##  Terraform create namespace
	 terraform workspace new $(ENV)

tf-ns-delete:  ##  Terraform  delete ns
	 terraform workspace select default
	 terraform workspace delete  $(ENV)

tf-validate:  ##  Terraform and validate
	 terraform validate

tf-plan:  tf-validate ## Generate Plan
	 terraform plan -input=false

setup-eks-cluster:  init-terraform tf-plan ## Setup eks cluster
	 terraform apply -auto-approve -input=false

destroy-eks-cluster: init-terraform  ## destroy eks cluster
	terraform destroy -auto-approve

ci-terraform-configs:   ## update eks cluster configurations
	 sed -i -e  's/prod/ci/g' eks-cluster.tf
	 sed -i -e  's/frazao/ci-frazao/g' eks-cluster.tf
	 rm -rf eks-cluster.tf-e


cleanup: destroy-eks-cluster tf-ns-delete ## cleanup

install-ansible-collections: ## install ansible collections
	ansible-galaxy collection install --collections-path ansible/collections --requirements-file ansible/collections/requirements.yml --force


ANSIBLE_PLAYBOOK :=  pipenv run  ansible-playbook  $(INVENTORIES) $(ANSIBLE_EXTRA_VARS)

install-components:  ## components installation
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_components

install-pre-components:  ## pre packages installation
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_pre

install-grafana:  ## grafana installation
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_grafana_operator

install-prometheus:  ## setup_prometheus_operator
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_prometheus_operator

install-argo-cd:  ## setup argo-cd
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_argocd

install-setup_consul:  ## setup consul
	$(ANSIBLE_PLAYBOOK) ansible/components_install.yml --tags setup_consul

get-kubeconfig:  ## get-kubeconfig
	aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
