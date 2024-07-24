
resource "aws_db_instance" "two-tier-db-1" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "sarva"
  password             = "SRJawle123"
  db_subnet_group_name = var.subnet-group
  vpc_security_group_ids = [var.sg_for_rds]
  skip_final_snapshot  = true

  tags = {
    Name = "Two-Tier DB"
  }
}
