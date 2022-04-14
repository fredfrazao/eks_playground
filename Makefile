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

tf-plan:  ## Generate Plan
	 terraform plan -out tfplan

setup-eks-cluster: tf-ns-create init-terraform tf-plan ## Setup eks cluster
	 terraform apply "tfplan"

destroy-eks-cluster:  ## destroy eks cluster
	terraform init
	terraform destroy -auto-approve

cleanup: destroy-eks-cluster tf-ns-delete ## cleanup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
