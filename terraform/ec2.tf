# create an ec2 instance resource
# create new security group
# - 22 (ssh)
# - 443 (https)
# - 3000 (nodejs) // ip: 3000

# Instance
resource "aws_instance" "tf_ec2_instance" {
  ami                         = var.ami_id # Ubuntu Image
  instance_type               = var.instance_type
  associate_public_ip_address = true # Give public ip address to instance
  vpc_security_group_ids      = [aws_security_group.tf_ec2_sg.id]
  # vpc_security_group_ids      = [module.tf_ec2_sg.security_group_id]
  key_name                    = "terraform-ec2-nikilasilva"
  depends_on                  = [aws_s3_bucket.tf_s3_bucket]
  user_data                   = <<-EOF
                                #!/bin/bash
                                
                                # Git clone
                                git clone https://github.com/nikilasilva/simple-node-app.git /home/ubuntu/simple-node-app
                                cd /home/ubuntu/simple-node-app

                                # Install nodejs
                                sudo apt update -y
                                sudo apt install -y nodejs npm

                                # Edit env vars
                                echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
                                echo "DB_USER=${aws_db_instance.tf_rds_instance.username}" | sudo tee -a .env
                                sudo echo "DB_PASS=${aws_db_instance.tf_rds_instance.password}" | sudo tee -a .env
                                echo "DB_NAME=${aws_db_instance.tf_rds_instance.db_name}" | sudo tee -a .env
                                echo "TABLE_NAME=users" | sudo tee -a .env
                                echo "PORT=3000" | sudo tee -a .env

                                # Start server
                                npm install
                                EOF
  user_data_replace_on_change = true

  tags = {
    Name = var.app_name
  }
}

# Security Group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "nodejs-server-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id # default VPC
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.tf_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Access to anyone
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tf_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_nodejs" {
  security_group_id = aws_security_group.tf_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# # Security Group using modules
# module "tf_ec2_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.3.1"

#   ingress_rules = ["https-443-tcp", "ssh-tcp"]

#   ingress_with_cidr_blocks = [
#     {
#       from_port  = 3000
#       to_port    = 3000
#       protocol   = "tcp"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]

#   egress_rules = ["all-all"]
# }

# Output
output "ec2_public_ip" {
  value = "ssh -i ~/.ssh/terraform-ec2-nikilasilva.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}

output "simple_node_app" {
  value = "${aws_instance.tf_ec2_instance.public_ip}:3000"
}
