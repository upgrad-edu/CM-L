locals {

  volume_size = "30"
  volume_type = "standard"

  amazon_linux_ami = "ami-0742b4e673072066f"
  user_data        = <<-EOF
          #!/bin/bash
	      yum update -y 
	      amazon-linux-extras install docker
          service docker start
	      systemctl enable docker
	      usermod -a -G docker ec2-user
	      yum install -y htop curl
	      amazon-linux-extras install epel -y
	      yum install -y stress
          curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
          chmod +x /usr/local/bin/docker-compose
	    EOF
  common_tags = {
    Purpose    = "CML_DEMO"
    Instructor = "nikhilbhat2008@gmail.com"
    Type       = "DeleteMe"
  }
}