variable "name" {
  description = "Giant mutated humanoid cockroaches with incredible physical strength"
  default = "Terra Formars"
}

variable "managers" {
  description = "Number of managers in the swarm.  This should be an odd number otherwise there may be issues with raft consensus."
  default     = 1
}

variable "workers" {
  description = "Number of workers in the swarm."
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t3.medium"
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "domain" {
  default = "-staging.aegis.gg"
}

variable "access_key" {}
variable "secret_key" {}
variable "ssh_key" {}
variable "password" {}
variable "rsync" {}