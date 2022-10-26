#root main.tf
#modules for compute, networking, loadbalancing, and s3

module "compute" {
  source         = "./modules/compute"
  public_sg      = module.networking.public_sg
  private_sg     = module.networking.private_sg
  private_subnet = module.networking.private_subnet
  public_subnet  = module.networking.public_subnet
  elb            = module.loadbalancing.elb
  lb_tg          = module.loadbalancing.lb_tg
  key_name       = var.key_name
}

module "networking" {
  source        = "./modules/networking"
  vpc_cidr      = var.vpc_cidr
  access_ip     = var.access_ip
  public_cidrs  = var.public_cidrs
  private_cidrs = var.private_cidrs
  public_access = var.public_access
}

module "loadbalancing" {
  source        = "./modules/loadbalancing"
  public_subnet = module.networking.public_subnet
  vpc_id        = module.networking.vpc_id
  web_sg        = module.networking.web_sg
  private_asg   = module.compute.private_asg
  tg_port                = 80
  tg_protocol            = "HTTP"
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  acl         = "private"
  tags        = var.tags
}

