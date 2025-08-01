module "vpc" {
  source               = "../resources/vpc"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
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

module "alb" {
  source       = "../resources/alb"
  name         = var.name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids# Or your own list
  app_port     = var.container_port
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
  subnet_ids          = module.vpc.public_subnet_ids
  target_group_arn    = module.alb.target_group_arn
  security_group_ids  = [module.sg.sg_id,module.alb.alb_sg_id]
  secret_word         = var.secret_word
}
