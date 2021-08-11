stack_name      = "atlan-test"                                                     # Put stack name                                                     # Put EC2 Key name here.                                                            # allowed values are:  "production" and "poc"

# VPC Configuration
vpc_config = {
  vpc_cidr_block    = "10.0.0.0/16"
  private_subnet = "10.0.0.0/24"
  public_subnet  = "10.0.2.0/24"
}

# EC2 Configurations
web-server-instance-type = "t2.micro"
db-instance-type = "t2.micro"

key_name        = "atlan-infra"   
