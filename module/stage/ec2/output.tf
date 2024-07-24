output "ec2_public_az1" {
  value = aws_instance.ec2_pub_az1.id
}
output "ec2_public_az2" {
  value = aws_instance.ec2_pub_az2.id
}
output "sg_vpc_http_ssh" {
  value = aws_security_group.sg_vpc_http_ssh.id
}
output "public_ec2_instance_ids" {
  value = [
    aws_instance.ec2_pub_az1.id,
    aws_instance.ec2_pub_az2.id
  ]
}
output "sg_for_rds" {
  value = aws_security_group.rds_sg.id
}