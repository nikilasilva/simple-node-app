/*
1. rds tf resource
2. security group
    - 3306
        - security group => tf_ec2_sg
        - cidr_block => ["local ip"]
3. outputs
*/

# rds resource
resource "aws_db_instance" "tf_rds_instance" {
  allocated_storage      = 10
  db_name                = "tr_demo"
  identifier             = "nodejs-rds-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "admin123"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.tf_rds_sg.id]
}

# Security Group
resource "aws_security_group" "tf_rds_sg" {
  name        = "allow-mysql-sg"
  description = "Allow Mysql traffic"
  vpc_id      = var.vpc_id # default VPC
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_rds" {
  security_group_id            = aws_security_group.tf_rds_sg.id
  referenced_security_group_id = aws_security_group.tf_ec2_sg.id # Allow traffic from EC2 sg
  # referenced_security_group_id = module.tf_ec2_sg.security_group_id # Allow traffic from EC2 sg
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
  description                  = "Allow MySQL traffic from EC2 SG"
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_local" {
  security_group_id = aws_security_group.tf_rds_sg.id
  cidr_ipv4         = "43.250.243.48/32" # Local IP address # Allow local IP access to RDS
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  description       = "Allow MySQL access from local machine"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_rds" {
  security_group_id = aws_security_group.tf_rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Local Variable
locals {
  rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance.endpoint), 0)
}

# Outputs
output "rds_endpoint" {
  value = local.rds_endpoint
}

output "rds_username" {
  value = aws_db_instance.tf_rds_instance.username
}

output "rds_db_name" {
  value = aws_db_instance.tf_rds_instance.db_name
}
