
resource "aws_iam_role" "PrometheusServerRole" {

  name               = "PrometheusServerRole"
  assume_role_policy = <<-EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":{
        "Service":"ec2.amazonaws.com"
      },
      "Action":"sts:AssumeRole"
    }]}
EOF 
}

resource "aws_iam_policy_attachment" "ec2_service_discovery" {

  name       = "ec2_service_discovery"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  roles      = [aws_iam_role.PrometheusServerRole.name]




}


resource "aws_iam_instance_profile" "PrometheusServer_instance_profile" {
  name = "PrometheusServerInstanceProfile"
  role = aws_iam_role.PrometheusServerRole.name

}




