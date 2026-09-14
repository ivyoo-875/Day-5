provider "aws" {
  region = "us-east-1"
}

module "my_module" {
  source = "./modules/newmodule"

  ami_value           = var.ami_value1
  instance_type_value = lookup(var.instance_type_value1, terraform.workspace, "t3.micro")
}

variable "ami_value1" {
    type = string
}

variable "instance_type_value1" {
    type = map(string)
}

ami_value = "ami-05c7d44d7418c58e5"
instance_type_value1 = {
        Dev = "t2.micro"
        stage = "t3.micro"
    }
