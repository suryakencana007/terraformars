resource "aws_eip" "managers" {
  count    = var.managers
  instance = module.swarm.manager_instance_ids[count.index]
  vpc      = true
}