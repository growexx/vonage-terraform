# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_config_files      = ["/Users/growlt092/.aws/config"]
  shared_credentials_files = ["/Users/growlt092/.aws/credentials"]
  profile                  = "default"
}

resource "aws_instance" "terraform_ec2" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  #vpc_id = "vpc-0b336b270d1af10b6"
  subnet_id = "subnet-09ea6288fe4025a8b"
  vpc_security_group_ids = ["sg-082c81bfb7c5b189e", "sg-0b1e03058e678d412","sg-0631fea2ff3437032", "sg-00fcf001270d12e8f"]
  iam_instance_profile = "es-logstash-role"
  
  tags = {
    Name ="terraform_ec2"
    Support_Email = "edw-architecture@vonage.com"
    SSM_Enabled = true
    Jira_Project = "EDWBD"
    Environment = "DEV"
  }

}