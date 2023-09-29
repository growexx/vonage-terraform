import os
import logging
import time
from datetime import datetime, timedelta
from jinja2 import Environment, FileSystemLoader
import snowflake.connector
from snowflake.connector import DictCursor

from snf_db import SnowflakeDBUtil
#from get_secret import get_env_conn_secrets

logging_level = os.environ["logging_level"]

### Connection Information ####
SNOWFLAKE_ACCOUNT = "***"
SNOWFLAKE_USER = "****"
SNOWFLAKE_PASSWORD = "***"
SNOWFLAKE_DB = "EDW_DEV"
SNOWFLAKE_SCHEMA = "PUBLIC"

### Query Information ####

SNOWFLAKE_STAGE = "STAGEDW"
SNOWFLAKE_TABLE = "NTW_GW_CALLS"
SNOWFLAKE_FROM = "@STAGEDW.PROD_S3/NETWORK/Kafka_Topics/gw_cdr_processed/"
SNOWFLAKE_FORMAT = "JSON_FORMAT"


logging.basicConfig()
logger = logging.getLogger()

try:
    logger.setLevel(logging_level)
except ValueError:
    logger.setLevel(logging.DEBUG)
    logger.info("Logging level: %s", logging.DEBUG)

def lambda_handler(event, context):

    # TODO implement
    logger.debug("Data Residency lambda handler called")
    
    # Create a Jinja2 environment
    env = Environment(loader=FileSystemLoader('.'))  # Look for templates in the current directory
    
    
    # Get the current date and time
    current_time = datetime.now()
    
    # Define the number of hours to add or subtract
    #h = 0  # You can replace this with any desired number of hours
    
    hours = [0,1] 
    
    for h in hours:
    
        # Calculate the new date and time
        new_time = current_time + timedelta(hours=h)

        # Format the new date and time
        formatted_time = new_time.strftime('%Y/%m/%d/%H')

        # Define variables to pass to the template
        data = {
                'SNOWFLAKE_STAGE': SNOWFLAKE_STAGE,
                'SNOWFLAKE_TABLE': SNOWFLAKE_TABLE,
                'SNOWFLAKE_FROM': SNOWFLAKE_FROM,
                'SNOWFLAKE_FORMAT': SNOWFLAKE_FORMAT,
                'FORMATED_TIME': formatted_time
        }

        # Load the SQL template
        template = env.get_template('template.sql')

        # Render the SQL template with data
        sql_query = template.render(data)

        # Print the rendered SQL query
        logger.info("Generated SQL Query:")
        logger.info(sql_query)
        try:
            sql_query_execution_start = time.time()
            db = SnowflakeDBUtil(
                account = SNOWFLAKE_ACCOUNT,
                user = SNOWFLAKE_USER,
                password = SNOWFLAKE_PASSWORD,
                db = SNOWFLAKE_DB,
                schema = SNOWFLAKE_SCHEMA,
                logger = logger
            )
            logger.debug('snowflake connected successfull')
            db.execute_query(sql_query)
            logger.info(f'Time taken to execute the sql: {time.time() - sql_query_execution_start}')
            
            db.disconnect()

        except Exception as ex:
            logger.debug("sql execution error")
            logger.error(f"loading data into {sql_query} snowflake failed")
            logger.error(f"Message: {str(ex)}")
        finally:
            logger.debug('sql execution stop')
            db.disconnect()

