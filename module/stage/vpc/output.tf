output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}
output "private_subnet" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}
output "public_subnet_ids" { //this will give list of subnet ids
  value = aws_subnet.public_subnets[*].id
}
output "private_subnet_ids" { //this will give list of subnet ids
  value = aws_subnet.private_subnets[*].id
}
output "subnet_group_for_db" {
  value = aws_db_subnet_group.two-tier-db-sub.id
}
# output "public_subnet" {
#   value = 
# }
# output "private_subnet_az2" {
#   value = 
# }

