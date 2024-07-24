variable "vpc_cidr" {}
# variable "public_subnet_az1_cidr" {}
# variable "public_subnet_az2_cidr" {}
variable "eu_availability_zone" {
    description = "list of subnets az's"
    type        = list(string)
    default = [ "us-east-1a" ,"us-east-1b" ]
}
variable "cidr_public_subnet" {
    description = "list of subnets cidr's"
    type        = list(string)
    default = [ "10.0.1.0/24" ,"10.0.3.0/24"]
}
variable "cidr_private_subnet" {
    description = "list of subnets cidr's"
    type        = list(string)
    default = [ "10.0.2.0/24" ,"10.0.4.0/24"]
}

