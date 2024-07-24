# I am not using this data because, we have to attach multiple subnets,right!
# data "aws_subnet" "public_subnet" {
#   filter {
#     name = "tag:Name"
#     values = ["Subnet-Public : Public Subnet 1"]
#   }

#   depends_on = [
#     aws_route_table_association.public_subnet_asso
#   ]
# }

resource "aws_instance" "ec2_pub_az1" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  associate_public_ip_address = true
  
  tags = {
    Name                 = "EC2 Public subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [aws_security_group.sg_vpc_http_ssh.id]
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo apt update -y
                            sudo apt install nginx -y 
                            sudo systemctl enable nginx
                            sudo systemctl start nginx
                            EOF
}

resource "aws_instance" "ec2_pub_az2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  associate_public_ip_address = true
  tags = {
    Name                 = "EC2 public subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.public_subnet[1]
  vpc_security_group_ids = [aws_security_group.sg_vpc_http_ssh.id]
  user_data              = <<-EOF
                          #!/bin/bash
                          sudo apt update -y
                          sudo apt install nginx -y 
                          sudo systemctl enable nginx
                          sudo systemctl start nginx
                          EOF
}

resource "aws_instance" "ec2_pri_az1" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  tags = {
    Name                 = "EC2 Private subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.private_subnet[0]
  vpc_security_group_ids = [aws_security_group.sg_vpc_ssh.id]

}

resource "aws_instance" "ec2_pri_az2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  tags = {
    Name                 = "EC2 Private subnet in az2"
  }
  key_name               = var.key
  subnet_id              = var.private_subnet[1]
  vpc_security_group_ids = [aws_security_group.sg_vpc_ssh.id]

}

# try to do it through for loop with multiple ports
resource "aws_security_group" "sg_vpc_http_ssh" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    } , 
        {
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  vpc_id               = var.vpc_id
  tags = {
    Name = "SG : allows http and ssh connections"
  }
}
resource "aws_security_group" "sg_vpc_ssh" {
  egress{
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ingress{
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    } 
  vpc_id               = var.vpc_id
  tags = {
    Name = "SG : allows only ssh connections"
  }
}
// sg for rds instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow RDS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}