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

cleanup: destroy-eks-cluster tf-ns-delete ## cleanup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
