module "networking" {
    source = "./modules/networking"
  security_group_id_ec2 = module.securitygroup.security_group_id_ec2
}

module "alb" {
    source = "./modules/alb"
    vpc_id = module.networking.vpc_id
    security_group_id_lb = module.securitygroup.security_group_id_lb
    subnet_ids = module.networking.subnet_ids
    instance = module.networking.instance
}

module "route53" {
    source = "./modules/route53"
    lb_arn = module.alb.lb_arn
    target_group = module.alb.target_group.arn
    lb_name = module.alb.lb_name 
    lb_hosted_zone = module.alb.lb_hosted_zone
  
}

module "securitygroup" {
  source = "./modules/securitygroup"
  vpc_id = module.networking.vpc_id
}