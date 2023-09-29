variable "config" {
  type = map
  default = {

        #code_bucket = "edw-data-residency-test"
        code_bucket = "edw-data-residency-lambda"
        code_bucket_key = "dag_ntw_gw_calls/dr_dag_ntw_gw_calls.zip"

        #source_bucket = "edw-data-residency-test"
        source_bucket = "edw-data-residency-lambda"
        source_bucket_folder = "vonage-edw-bucket/"
        role = "arn:aws:iam::248273529068:role/edw-lambda-msk-role"
  }
}