resource "aws_security_group" "PrometheusDemoSg" {
  name = "PrometheusDemoSg"
  ingress {
    description = "open all ports from my public ip"
    from_port   = 0
    to_port     = 60000
    protocol    = "tcp"
    cidr_blocks = ["${var.user_public_ip}/32"]
  }
  ingress {
    description = "allow traffic to grafana from everywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow sg members to send data"
    from_port   = 0
    to_port     = 65535
    self        = true
    protocol    = "tcp"
  }
  egress {
    description = "Let instances send traffic to any destination"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags,
    { Name = "PrometheusSg" },
  )
}
