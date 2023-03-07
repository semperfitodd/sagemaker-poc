# sagemaker-poc

## Use TerraForm to build the following:
* VPC
* Endpoints
* Security Groups
* SageMaker Domain
* SageMaker User
* SageMaker Studio
* IAM policies and roles
## Set variables in variables.tf
* cidr block range
* other variables
## Set backend
* give valid S3 bucket and key where you want your state held
## Run Terraform
```
terraform init
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```
## Run SageMaker Studio
Go to SageMaker in the AWS Console
Click on Open Studio button
![open_studio.png](images%2Fopen_studio.png)
You can now play with pre-built end-to-end solutions
![jumpstart.png](images%2Fjumpstart.png)
When finished, delete all resources jumpstart created
## Clean up Terraform
```
terraform destroy
```
Note: you may need to manually delete EFS that gets created automatically