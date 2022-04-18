

# Prerequisites
```
- a AWS account 
- a configured AWS CLI
- AWS IAM Authenticator
- terraform >= 0.14
- kubectl to interact with the elk 
```
# config AWS CLI
```
aws configure
AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
Default region name [None]: YOUR_AWS_REGION
Default output format [None]: json
```
# Set up and initialize your workspace
```
make init-terraform
```

# Provision an EKS Cluster
```
make setup-eks-cluster
```

# Get and Configure kubeconfig
```
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) 
```

# Destroy an EKS Cluster
```
make destroy-eks-cluster
```
