module "module1" {
  source = "./modules/project"

  ami_value           = var.ami_value1
  instance_type_value = var.instance_type_value1
}