# Creating security group
resource "aws_security_group" "allow_rabbitmq" {
  name        = "allow_${var.COMPONENT}"
  description = "Allow all inbound traffic"

  ingress {
    description      = "RabbitMQ to VPC"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSPATION_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-rabbitmq"
  }
}
