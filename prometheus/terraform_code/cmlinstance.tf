resource "aws_instance" "PrometheusServer" {
  ami                    = local.amazon_linux_ami
  vpc_security_group_ids = [aws_security_group.PrometheusDemoSg.id]
  instance_type          = "t2.micro"
  tags = merge(local.common_tags,
    { Name = "PrometheusServer" },

  )
  iam_instance_profile = aws_iam_instance_profile.PrometheusServer_instance_profile.name
  root_block_device {
    volume_type = local.volume_type
    volume_size = local.volume_size
    tags = merge(local.common_tags,
      { Name = "PrometheusServer" },
    )
  }
  key_name  = var.ssh_key_name
  user_data = local.user_data

}

resource "aws_instance" "Servers" {
  ami                    = local.amazon_linux_ami
  vpc_security_group_ids = [aws_security_group.PrometheusDemoSg.id]
  instance_type          = "t2.micro"
  for_each               = toset(["server1", "server2"])
  tags = merge(local.common_tags,
    { Name = each.key },

  )
  iam_instance_profile = aws_iam_instance_profile.PrometheusServer_instance_profile.name
  root_block_device {
    volume_type = local.volume_type
    volume_size = local.volume_size
    tags = merge(local.common_tags,
      { Name = each.key },
    )
  }
  key_name  = var.ssh_key_name
  user_data = local.user_data

}