# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_config_files      = ["/Users/growlt092/.aws/config"]
  shared_credentials_files = ["/Users/growlt092/.aws/credentials"]
  profile                  = "default"
}

variable "global_prefix" {
  type = string
  default = "terraform-apache-kafka-cluster"
}

resource "aws_msk_configuration" "kafka_config" {
  kafka_versions = ["3.2.0"]
  name = "${var.global_prefix}-config"
  server_properties = <<EOF
auto.create.topics.enable = true
delete.topic.enable = true
EOF
}


resource "aws_msk_cluster" "kafka" {
  cluster_name = var.global_prefix
  kafka_version = "3.2.0"
  number_of_broker_nodes = 3
  broker_node_group_info {
    instance_type = "kafka.m5.large"
    #instance_type = "kafka.t3.small"
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }      
    }
    client_subnets = ["subnet-03b0b946cb58c9779", "subnet-09ea6288fe4025a8b", "subnet-06db55dceec9d2057"]
    security_groups = ["sg-0631fea2ff3437032"]
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
    encryption_at_rest_kms_key_arn = "arn:aws:kms:us-east-1:248273529068:key/fe50e9e0-ba60-4472-b4ba-0e8b6cf08281"
  }
  configuration_info {
    arn = aws_msk_configuration.kafka_config.arn
    revision = aws_msk_configuration.kafka_config.latest_revision
  }
  tags = {
    name = var.global_prefix
    Application = "Data Residency Terraform"
  }

}