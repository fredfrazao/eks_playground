.DEFAULT_GOAL = help
.PHONY: help 

init-terraform:  ## Setup Terraform and validate
	 terraform init

tf-validate:  ##  Terraform and validate
	 terraform validate

tf-plan:  ## Generate Plan
	 terraform plan -out tfplan

setup-eks-cluster: init-terraform tf-plan ## Setup eks cluster
	 terraform apply "tfplan"

destroy-eks-cluster:  ## destroy eks cluster
	terraform init
	terraform destroy -auto-approve

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
