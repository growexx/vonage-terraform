import os
import json
import boto3
import logging


logging_level = os.environ['logging_level']

logging.basicConfig()
logger = logging.getLogger()

try:
    logger.setLevel(logging_level)
except ValueError:
    logger.setLevel(logging.DEBUG)
    logger.info('Logging level: %s', logging.DEBUG)



def get_env_conn_secrets(
    secret_arn_key,
    secret_list,
):
    """
    Get secret values from AWS secret manager
    Args:
        logging_level      (str): logging level type
        secret_arn_key     (str): AWS secret ARN key
        secret_list       (list): list of secret names to be retrieved from AWS secret manager
    Return:
        vcost_secret_dict (dict): dictionary containing retrieved secret values
    """

    try:
        vcost_secret_dict = {}
        region_name = "us-east-1"

        # Create a AWS Secret Manager client
        session = boto3.session.Session()
        logger.info(" AWS Secrets Manager session created ")
        
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        get_secret_value_response = client.get_secret_value(
            SecretId=secret_arn_key
        )

        logger.debug(" SecretString response received ")

        secret_response = get_secret_value_response['SecretString']
        secret_dict = json.loads(secret_response)
        for secret_name in secret_list:
            vcost_secret_dict[secret_name] = secret_dict[secret_name]
        logger.info(" Values successfully retrieved from AWS Secret Manager")
    
        return vcost_secret_dict

    except Exception as ex:
        logger.error(f"Error in getting values from AWS secret manager : {str(ex)}")
        raise ex