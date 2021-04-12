
resource "aws_iam_role" "cml_instance" {

  name               = "cml_instance_role"
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
resource "aws_iam_policy" "ec2_grafana" {

  name        = "ec2_grafana"
  description = "allows grafana to show ec2 and other metrics"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowReadingMetricsFromCloudWatch",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowReadingTagsInstancesRegionsFromEC2",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ],
        "Resource" : "*"
      }
    ]
  })

}
resource "aws_iam_policy_attachment" "ec2_grafana" {

  name       = "ec2_grafana"
  policy_arn = aws_iam_policy.ec2_grafana.arn
  roles      = [aws_iam_role.cml_instance.name]




}

resource "aws_iam_policy_attachment" "ec2_cloudwatch_agent" {

  name       = "ec2_grafana"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.cml_instance.name]




}
resource "aws_iam_instance_profile" "cml_instance_profile" {
  name = "cml_instance_profile_demo"
  role = aws_iam_role.cml_instance.name

}




