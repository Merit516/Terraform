data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "my_instance_public" {

  ami                    = data.aws_ami.ubuntu.id  # replace with your desired AMI ID
  instance_type          = "t2.micro"                # replace with your desired instance type
  key_name               = "merit-key"                  # replace with your key pair name
  subnet_id              = var.public_subnet_id # replace with your desired subnet ID
  associate_public_ip_address = true                # assign a public IP address to the instance
  vpc_security_group_ids=[var.sg_id]

  provisioner "remote-exec" {
    inline = [
      "exec > >(tee -i /var/log/user-data.log)",
      "exec 2>&1",
      "sudo apt update -y",
      "sudo apt install software-properties-common",
      "ssudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
      
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./merit-iti.pem")
    host        = self.public_ip
  }
 
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ./instacne_public_ips.txt"
  }



  tags = {
    Name = "ec2-public-name"
  }
}


#!/bin/bash
exec > >(tee -i /var/log/user-data.log)
exec 2>&1
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install git -y 
mkdir Ansible && cd Ansible
pwd
#git clone https://github.com/Aj7Ay/ANSIBLE.git   #change to your own repo
#cd ANSIBLE
#ansible-playbook -i localhost Jenkins-playbook.yml





