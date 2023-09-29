import logging
import snowflake.connector
from snowflake.connector import DictCursor

class SnowflakeDBUtil:

    cursor = None
    logger = None
    snf_connection = None

    def __init__(self, account="", user="", password="", db="", schema="", logger=None):
        """
        Create snowflake connection
        Args:
            account   (str): snowflake account name
            user      (str): snowflake user name
            password  (str): snowflake password
            db        (str): snowflake database
            schema    (str): snowflake schema
            logger    (str): logging level type
        Return:
            None
        """
        try:

            if logger:
                self.logger = logger
            else:
                self.logger = logging.getLogger()

            self.snf_connection = snowflake.connector.connect(
                account=account,
                user=user,
                password=password,
                database=db,
                schema=schema,
                ocsp_response_cache_filename="/tmp/ocsp_response_cache",
            )
            self.cursor = self.snf_connection.cursor(DictCursor)

        except Exception as e:
            self.logger.exception(f"Unable to connect to Snowflake database: {str(e)}")
            raise e

    def disconnect(self):
        """
        Close snowflake connection
        Args:
            None
        Return:
            None
        """
        try:
            self.snf_connection.close()

        except Exception as e:
            self.logger.exception(f"Unable to disconnect Snowflake database: {str(e)}")
    
    def execute_query(self, sql):
        """
        Execute Snowflake Queries
        Args:
            sql      (str): Sql to be executed
        Return:
            result   (dict): records returned by snowflake query
        """
        response = {}
        try:
            self.cursor.execute(sql)
            result = self.cursor.fetchall()
            response["result"] = result
            response["resultCount"] = len(result)
            return response

        except Exception as e:
            self.logger.error(sql)
            self.logger.exception(e)
            raise e
        
        