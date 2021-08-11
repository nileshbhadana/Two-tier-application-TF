variable "stack_name" {
  type = string
  validation {
    condition     = var.stack_name != ""
    error_message = "Stack Name cannot be left blank."
  }
}

variable "vpc_config" {
  type = object({
    vpc_cidr_block = string
    private_subnet = string
    public_subnet  = string
  })
  default = {
    vpc_cidr_block    = "10.0.0.0/16"
    private_subnet = "10.0.0.0/24"
    public_subnet  = "10.0.2.0/24"
  }
}

variable "web-server-instance-type" {
  type    = string
}

variable "db-instance-type" {
  type    = string
}

variable "key_name" {
  type = string
  validation {
    condition     = var.key_name != ""
    error_message = "Key name cannot be left blank."
  }
}