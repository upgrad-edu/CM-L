resource "aws_instance" "cmldemo" {
  ami                    = "ami-0533f2ba8a1995cf9"
  vpc_security_group_ids = [aws_security_group.cmldemosg.id]
  instance_type          = "t2.micro"
  tags                   = { name = "cmldemo" }
  iam_instance_profile   = aws_iam_instance_profile.cml_instance_profile.name
  root_block_device {

    tags        = { Name = "cmldemo-1" }
    volume_size = "30"
    volume_type = "standard"


  }
  key_name  = var.ssh_key_name
  user_data = <<-EOF
              #!/bin/bash
	      yum update -y 
	      amazon-linux-extras install docker
              service docker start
	      systemctl enable docker
	      usermod -a -G docker ec2-user
	      wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
	      sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
	      yum install -y apache-maven
	      yum install -y java-1.8.0-devel
	      yum install -y amazon-cloudwatch-agent
	      yum install -y htop
	      amazon-linux-extras install epel -y
	      yum install -y stress
	      EOF

}

resource "aws_security_group" "cmldemosg" {
  name = "cmldemosgroup"
  ingress {
    from_port   = 0
    to_port     = 60000
    protocol    = "tcp"
    cidr_blocks = ["${var.user_public_ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
