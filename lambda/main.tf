# Configure the AWS Provider
provider "aws" {
  #region = "us-east-1"
  region = "eu-central-1"
  shared_config_files      = ["/Users/growlt092/.aws/config"]
  shared_credentials_files = ["/Users/growlt092/.aws/credentials"]
  profile                  = "default"
}

resource "aws_lambda_function" "tf_data_residency_dag_ntw_gw_calls" {  
  # If the file is not in the current working directory you will need to include a  
  # path.module in the filename.  
  #filename      = "lambda_function.zip"
  s3_bucket     = var.config["code_bucket"]
  s3_key = var.config["code_bucket_key"]
  function_name = "data_residency_dag_ntw_gw_calls"
  description = "Airflow job : ntw_src_kafkaS3_dest_new_ntw_gw_calls"
  role          = var.config["role"]
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.11"
  timeout = 300
  environment {    
    variables = {
      logging_level = "info"
    }
  }
}

data "aws_s3_bucket" "bucket" {  
  bucket = var.config["source_bucket"]
}

resource "aws_lambda_permission" "allow_bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_data_residency_dag_ntw_gw_calls.arn
  principal     = "s3.amazonaws.com"
  source_arn    =  data.aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.bucket.id
  lambda_function {
    events = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.tf_data_residency_dag_ntw_gw_calls.arn
    filter_prefix       = var.config["source_bucket_folder"] #Sample file will be put here to execute lambda function.
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}


resource "aws_cloudwatch_event_rule" "data_residency_dag_ntw_gw_calls_every_5_minutes" {
  name        = "data_residency_dag_ntw_gw_calls_every_5_minutes"
  description = "trigger lambda every 5 minute for data_residency_dag_ntw_gw_calls"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.data_residency_dag_ntw_gw_calls_every_5_minutes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.tf_data_residency_dag_ntw_gw_calls.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_data_residency_dag_ntw_gw_calls.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_residency_dag_ntw_gw_calls_every_5_minutes.arn
}
