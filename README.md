# This Repository contains terraform code for continous monitoring and logging module 


## Amazon CloudWatch Instructions

For Amazon Cloudwatch we need to create:

- Ec2 Instance  with cloudwatch agent installed
- IAM Role with following permissions
    -  arn:aws:iam::aws:policyCloudWatchAgentServerPolicy
    - This Policy Enables cloudwatch agent to send metrics from ec2-user
    - A custom polciy which allows grafana to query fro data from amazon cloudwatch
    - The policy is displayed below
    
    ```{
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
  }```

***These Steps can be automated by Using Terraform***

### Terraform Instructions
Inorder to Create Required Resources for the Demo:

- You Need ***amazon access keys*** which you will need to set as environment variable while running export command
- You Need a ***ssh key pair*** whose name will be required while running terraform.
- ***Your Public Ip*** which you need to provide while running terraform
- Once Done Follow the Instructions Below to Plan , Create Resources
- ***Destroy the Resources only once demo is completed***



#### How to run plan step to see what things terraform will do

```
cd cloudwatch
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
terraform plan
```

#### How to apply  terraform plan output and actually create Resources

```
cd cloudwatch
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
terraform apply -auto-approve
```

#### How to Destroy Resources ***once demo is completed***
```
cd cloudwatch
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
terraform destroy
```

### Once you have applied terraform code or created the requirements manually ###

- Navigate to Amazon Cloudwatch Too See your Instance Metrics
- In order to Populate Missing Metrics Run the Following Commands After ssh into the created Instance using your keypair
```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# This will launch a questionaire so provide right answers to the wizard

# Start Cloudwatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

# Verify The status
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```
- Now Metrics will be Available inside cloudwatch agent namespace
- Create dashboard using the dashboard_source.json example by using the edit source of dashboard option
- Create SNS Topic to add email notifications
- Use CLoudwatch Alarm to Send Alerts to The SNS Topic



***Destroy the AWS Resources using terraform destroy command as described earlier*** 


## Prometheus Session Instructions


- You Need to Setup and ec2 instance for Prometheus
  - Iam Role for Ec2 service discovery
  ```arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess```
  
  - Install node_exporter prometheus and alertmanager
  - Proper Security Group Rules so Prometheus Server can scrape other Servers
- You need to setup another ec2 instances with
  - node_expoter installed

### These Steps can Be Automated using code present in prometheus/terraform_code folder

- Installed required componensts using scripts provided in prometheus/scripts folder on respective servers
- Once done copy prometheus-3.yml to /etc/prometheus/prometheus.yml
- Reload Prometheus Server suding sudo kill -1 <pid of Prometheus Server>
- Copy alert_manager.yml after adding slack webhook to /etc/alertmanager/alertmanager.yml
- Restart alertmanager
- Start node_exporter on all servers
- Navigate to http://<PUBLIC_IP_PROMETHEUS_SERVER>:9090 to see if data is populated
- Now you need to deploy the applications whose metrics will be collected by prometheus
- copy demoapp folder to prometheus server
- docker-compose up -d inside the folder
- This will start your application 
-  http://<PUBLIC_IP_PROMETHEUS_SERVER>:5000 will be the url 

## ELK DEMO

### Local demo

- On your system goto demoapp folder
```
cd demoapp
docker-compose up -d
```
- make some requests to demoapp
- wait for some time then browse to http://localhost:5601
- Add Index pattern as given in screenshot
- Create Dashboards

### AWS  Demo

- create 4 instances elk_server{1..3} kibana_instance
- use scripts folder to install  various components
- Edit /etc/elasticsearch/elasticsearch.yml on elk servers and provide private_ip_v4 adress
- Edit kibana.yml with correct elk private ip adress
- Install logstash on kibana server
- copy losgtash.conf to conf.d directory in /etc/logstash/ directory
- copy demoapp folder to kibana server
- cd demoapp && docker-compose up -d 
- copy filebeat.yml to /etc/filebeat/
- start filebeat logstash and kibana
- start elasticsearch on all servers

