SHELL := /bin/bash
.RECIPEPREFIX := >

AWS_PROFILE ?= terraform-local
AWS_REGION  ?= us-east-1

export AWS_PROFILE
export AWS_DEFAULT_PROFILE := $(AWS_PROFILE)
export AWS_REGION
export AWS_DEFAULT_REGION := $(AWS_REGION)
export AWS_SDK_LOAD_CONFIG := 1
export AWS_EC2_METADATA_DISABLED := true

.PHONY: \
	dev-init \
	dev-plan \
	dev-apply \
	dev-destroy \
	prod-init \
	prod-plan \
	prod-apply \
	prod-destroy \
	clean

# --------------------------------------------------
# Development
# --------------------------------------------------

dev-init:
> @echo "Using AWS profile: $(AWS_PROFILE)"
> @echo "Using AWS region: $(AWS_REGION)"
> @echo "Working directory: $$(pwd)"
> aws sts get-caller-identity
> terraform init \
>   -reconfigure \
>   -backend-config=environments/dev/state.tfvars

dev-plan: dev-init
> terraform fmt -recursive
> terraform validate
> terraform plan \
>   -var-file=environments/dev/main.tfvars \
>   -out=dev.tfplan

dev-apply: dev-plan
> terraform apply \
>   -auto-approve \
>   dev.tfplan

dev-destroy: dev-init
> terraform plan \
>   -destroy \
>   -var-file=environments/dev/main.tfvars \
>   -out=dev-destroy.tfplan
> terraform apply \
>   -auto-approve \
>   dev-destroy.tfplan

# --------------------------------------------------
# Production
# --------------------------------------------------

prod-init:
> @echo "Using AWS profile: $(AWS_PROFILE)"
> @echo "Using AWS region: $(AWS_REGION)"
> @echo "Working directory: $$(pwd)"
> aws sts get-caller-identity
> terraform init \
>   -reconfigure \
>   -backend-config=environments/prod/state.tfvars

prod-plan: prod-init
> terraform fmt -recursive
> terraform validate
> terraform plan \
>   -var-file=environments/prod/main.tfvars \
>   -out=prod.tfplan

prod-apply: prod-plan
> terraform apply \
>   -auto-approve \
>   prod.tfplan

prod-destroy: prod-init
> terraform plan \
>   -destroy \
>   -var-file=environments/prod/main.tfvars \
>   -out=prod-destroy.tfplan
> terraform apply \
>   -auto-approve \
>   prod-destroy.tfplan

# --------------------------------------------------
# Cleanup
# --------------------------------------------------

clean:
> /bin/rm -rf -- .terraform
> rm -f dev.tfplan
> rm -f dev-destroy.tfplan
> rm -f prod.tfplan
> rm -f prod-destroy.tfplan
> rm -f crash.log
> rm -f crash.*.log