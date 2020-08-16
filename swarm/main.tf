data "template_file" "monitoring" {
  template = file("${path.module}/scripts/monitoring.tpl")

  vars = {
    ACCESS_KEY = var.access_key
    SECRET_KEY = var.secret_key
  }
}

data "template_file" "cloud-config" {
  template = file("swarm/users.cloud-config")
  vars = {
    ssh_key = var.ssh_key
    user = var.username
  }
}

data "cloudinit_config" "environments" {
  gzip          = "true"
  base64_encode = "true"

  part {
    filename     = "cloud-config.sh"
    content      = data.template_file.cloud-config.rendered
    content_type = "text/x-shellscript"
  }

  part {
    filename     = "monitoring.sh"
    content      = data.template_file.monitoring.rendered
    content_type = "text/x-shellscript"
  }
}

module "swarm" {
  source  = "trajano/swarm-aws/docker"
  version = "4.1.1"

  name               = var.name
  vpc_id             = aws_vpc.main.id
  managers           = var.managers
  workers            = var.workers
  cloud_config_extra = data.cloudinit_config.environments.rendered
  instance_type      = var.instance_type

  additional_security_group_ids = [
    aws_security_group.exposed.id,
    aws_security_group.rds-exposed.id,
  ]
}
