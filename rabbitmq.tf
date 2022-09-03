resource "aws_spot_instance_request" "rabbitmq" {
#   ami                    = data.aws_ami.base-ami.image_id
  ami                    = "ami-052d9bac7baef4290"
  instance_type          = "t3.micro"
  wait_for_fulfillment   = true 
  vpc_security_group_ids = [aws_security_group.allow_rabbitmq.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_ID[0]

  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}

resource "null_resource" "rabbitmq-installation" {
  provisioner "remote-exec" {
      connection {
        type     = "ssh"
        user     = "centos"
        password = "DevOps321"
        # host     = self.public_ip
        host     = aws_spot_instance_request.rabbitmq.private_ip
      } 
    inline = [
     "ansible-pull -U https://github.com/b49-clouddevops/ansible.git -e COMPONENT=rabbitmq -e ENV=dev roboshop.yml"
      ]
    }
}



