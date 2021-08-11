# Two-tier-application-TF

Terraform templates to create Two tier application infrastructure on AWS. 
Following components are created:
    - VPC 
    - Security Groups
    - Subnet (Public and Private)
    - NAT Gateway
    - Internet Gateway
    - Route Tables(Public and Private)
    - EC2 instances (Webserver and DB instance) 


### 📜 Pre Requistes:
1. Configure the AWS default profile with appropriate permission.<br>
    Put this section in your  `~/.aws/credentials` file.
    ```yaml
    [default]
    aws_access_key_id=<Your Access ID>
    aws_secret_access_key=<Your Secret key>
    aws_session_token=<Your Session Token>
    ```
    OR 
    Excute these commands in your terminal

    ```shell
    export AWS_ACCESS_KEY_ID="<Your Access ID>"
    export AWS_SECRET_ACCESS_KEY="<Your Secret key>"
    export AWS_SESSION_TOKEN="<Your Session Token>"
    ```

2. Install terraform cli.
    > Refer [this](https://www.terraform.io/downloads.html) doc to install terraform.

### Steps to Deploy
1. Clone the repository and switch the branch.
    ```console
    git clone https://github.com/nileshbhadana/Two-tier-application-TF
    cd Two-tier-application-TF/infra/
    ```
2. Defining values for parameters. Open `terraform.tfvars` in your favorite editor and define values for the parameters. Although you can use default values for most parameters but have to define values for these: 
    - stack_name -> Name for the stack
    - key_name -> The ec2 key to use for EC2 instances

    Now save the file.

3. Initiate the terraform directory
    ```console
    terraform init
    ```

4. Creating a plan.
    ```console
    terraform plan -var-file=./terraform.tfvars
    ```

5. Executing the plan. 
    ```console
    terraform apply -var-file=./terraform.tfvars
    ```

***NOTE:*** Keep the `terraform.tfstate` file generated very safe and do not alter it. If this is deleted then there is no way to update or delete the stack through terraform.

6. You will get the following details in the output:
    - Public DNS of Webserver instance
    - Public IP of Webserver instance
    - VPC ID of VPC created
    - IP of NAT Gateway

You can check by accessing the public DNS over `http`.

- The Webserver is accessible via internet only on port `80` and `443` by default.
- DB instance is only accessible from webserver instance only on `5432` port.