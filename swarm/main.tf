data "template_file" "cloud-config" {
  template = file("swarm/users.cloud-config")
  vars = {
    domain = var.domain
    ssh_key = var.ssh_key
    ACCESS_KEY = var.access_key
    SECRET_KEY = var.secret_key
  }
}

module "swarm" {
  source  = "trajano/swarm-aws/docker"
  version = "4.1.1"

  name               = var.name
  vpc_id             = aws_vpc.main.id
  managers           = var.managers
  workers            = var.workers
  cloud_config_extra = data.template_file.cloud-config.rendered
  instance_type      = var.instance_type

  additional_security_group_ids = [
    aws_security_group.exposed.id,
    aws_security_group.rds-exposed.id,
  ]
}
