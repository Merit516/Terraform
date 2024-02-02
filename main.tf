#---------------vpc_module--------------------
module "vpc" {
  source   = "./vpc"
  vpc-cidr = "10.0.0.0/16"
}


#----------------public_subnets_module---------
module "public_subnet" {
  source = "./public-subnet"

  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id


  public_subnet_cidrs = "10.0.1.0/24"
  availability_zones  = "us-east-1a"
}

#----------------security_group_module----------
module "securtity-group" {
  source      = "./security-group"
  vpc_id      = module.vpc.vpc_id
  name        = "my-security-group"
  description = "My security group description"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

#----------------instance_public_module----------
module "instance-public" {
  source            = "./instance-public"
  public_subnet_id = module.public_subnet.public_subnet_id
  sg_id             = module.securtity-group.sg_id

}


#----------------intgrate_Cloudwatch_in_AWS--------
module "cloudwatch_monitoring" {
  source = "./cloudwatch"
  #version = "~> 1"


  public_instance_id = module.instance-public.public_instance_id
}

