module "vpc" {
  source              = "../resources/vpc"
  name                = var.name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone   = var.availability_zone
}

module "sg" {
  source   = "../resources/sg"
  name     = var.name
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
}

module "ecr" {
  source = "../resources/ecr"
  ecr_name   = var.ecr_name
}

module "iam" {
  source = "../resources/iam"
  name   = var.ecs_cluster_name
}

module "ecs" {
  source              = "../resources/ecs"
  cluster_name        = var.cluster_name
  task_family         = var.task_family
  cpu                 = var.cpu
  memory              = var.memory
  image               = var.image
  container_port      = var.container_port
  execution_role_arn  = module.iam.execution_role_arn
  task_role_arn       = module.iam.task_role_arn
  log_group_name      = var.log_group_name
  region              = var.region
  service_name        = var.service_name
  desired_count       = var.desired_count
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  //target_group_arn    = var.target_group_arn
}
