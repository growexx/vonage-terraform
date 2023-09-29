COPY INTO {{ SNOWFLAKE_STAGE }}.{{ SNOWFLAKE_TABLE }}(DISC_DATE,DISC_HOUR,GATEWAY,`TYPE`,SITE,CALL_TYPE,CALL_REFERENCE_ID,START_TIMESTAMP,DISCONNECT_TIMESTAMP,SETUP_TO_CONNECT,RECORD_TYPE,CALL_DURATION_SECS,FIRST_RELEASE_SOURCE,CAUSE_CODE,CAUSE_LOCATION,CALLING_NUMBER,CALLING_NUMBER_PREFIX,CALLED_NUMBER,CALLED_NUMBER_PREFIX,ROUTE_INDEX,ROUTE_NAME,ORIGINATING_LINE_INFO,PRESENTATION_RESTRICTION,INCOMING_CALLING_NUMBER,T38_FAX_CALL,GLARE_ENCOUNTERED,INGRESS_SIP_CALL_ID,INGRESS_REMOTE_SIP_HOST,INGRESS_TRUNK_GROUP,INGRESS_CIC,INGRESS_LOCAL_MEDIA_HOST,INGRESS_LOCAL_MEDIA_PORT,INGRESS_REMOTE_MEDIA_HOST,INGRESS_REMOTE_MEDIA_PORT,INGRESS_ORIG_POINT_CODE,INGRESS_DEST_POINT_CODE,INGRESS_CODEC_TYPE,INGRESS_RTP_PACKETIZATION,INGRESS_NUM_BYTES_SENT,INGRESS_NUM_PACKETS_SENT,INGRESS_NUM_BYTES_RECV,INGRESS_NUM_PACKETS_RECV,INGRESS_NUM_PACKETS_LOST,INGRESS_JITTER,INGRESS_LATENCY,INGRESS_MAX_PACKET_OUTAGE,INGRESS_PLAYOUT_QUALITY,INGRESS_ECHO_CANCELLATION,INGRESS_CARRIER,EGRESS_SIP_CALL_ID,EGRESS_REMOTE_SIP_HOST,EGRESS_TRUNK_GROUP,EGRESS_CIC,EGRESS_LOCAL_MEDIA_HOST,EGRESS_LOCAL_MEDIA_PORT,EGRESS_REMOTE_MEDIA_HOST,EGRESS_REMOTE_MEDIA_PORT,EGRESS_ORIG_POINT_CODE,EGRESS_DEST_POINT_CODE,EGRESS_CODEC_TYPE,EGRESS_RTP_PACKETIZATION,EGRESS_NUM_BYTES_SENT,EGRESS_NUM_PACKETS_SENT,EGRESS_NUM_BYTES_RECV,EGRESS_NUM_PACKETS_RECV,EGRESS_NUM_PACKETS_LOST,EGRESS_JITTER,EGRESS_LATENCY,EGRESS_MAX_PACKET_OUTAGE,EGRESS_PLAYOUT_QUALITY,EGRESS_ECHO_CANCELLATION,EGRESS_CARRIER,SESSION_ID,ANSWER_FILENAME,RELEASE_FILENAME,INSERTED_TIMESTAMP,DIRECTION,INGRESS_LOCAL_SIP_HOST,EGRESS_LOCAL_SIP_HOST,CALLING_NUMBER_ACCT,CALLED_NUMBER_ACCT,COUNTRY_CD,COUNTRY,LRN,CLASS_OF_SERVICE,ROUTE_SOURCE,GATEWAY_HOSTNAME,GLOBAL_CALL_ID,CALLED_NUMBER_COUNTRY_CODE,CALLED_NUMBER_COUNTRY_ISO,CALLED_NUMBER_STATE,CALLED_NUMBER_COUNTRY_IS_POSSIBLE,CALLED_NUMBER_COUNTRY_IS_VALID,DNIS,`RANK`,SIP_STATUS_CODE_SENT,SIP_STATUS_CODE_RECEIVED,FLOW_TYPE,FLOW_ORIGINATOR,FLOW_TERMINATOR,TRANSFER_ID,POST_DIAL_DELAY,CALLING_NUMBER_COUNTRY_CODE,CALLING_NUMBER_COUNTRY_ISO,CALLING_NUMBER_STATE,CALLING_NUMBER_COUNTRY_IS_POSSIBLE,CALLING_NUMBER_COUNTRY_IS_VALID,ROUTING_TYPE,ROUTING_PREFIX,S3_FILE_NAME, INSERT_TIMESTAMP,INGRESS_PROTOCOL_VARIANT_CALL_ID,INGRESS_PROTOCOL_VARIANT_SIP_REQ_URI_USER_HOST,INGRESS_PROTOCOL_VARIANT_SIP_URI_PAI_USER_HOST,EGRESS_PROTOCOL_VARIANT_CALL_ID,EGRESS_PROTOCOL_VARIANT_SIP_REQ_URI_USER_HOST,EGRESS_PROTOCOL_VARIANT_SIP_URI_PAI_USER_HOST,
EGRESS_PROTOCOL_VARIANT_FROM,EGRESS_PROTOCOL_VARIANT_TO,EGRESS_PROTOCOL_VARIANT_INVITE_CONTACT_HEADER,
INGRESS_PROTOCOL_VARIANT_FROM,INGRESS_PROTOCOL_VARIANT_TO,INGRESS_PROTOCOL_VARIANT_INVITE_CONTACT_HEADER)
FROM (
SELECT 
CASE WHEN $1:DISC_DATE= '0' THEN '9999-01-01'  
ELSE TO_DATE(TO_TIMESTAMP($1:DISC_DATE::STRING))::DATE 
END AS DISC_DATE,
$1:DISC_HOUR::INT,$1:GATEWAY::STRING,$1:GATEWAY_TYPE::STRING,$1:SITE::STRING,$1:CALL_TYPE::STRING,$1:CALL_REFERENCE_ID::INT,
TO_TIMESTAMP($1:START_TIMESTAMP::STRING,'mm/dd/yyyy hh24:mi:ss.ff') , 
CASE WHEN $1:DISCONNECT_TIMESTAMP::STRING LIKE ('0 %')
THEN '9999-01-01 00:00:00.00 '
ELSE TO_TIMESTAMP($1:DISCONNECT_TIMESTAMP::STRING,'mm/dd/yyyy hh24:mi:ss.ff')
END AS DISCONNECT_TIMESTAMP,
$1:SETUP_TO_CONNECT::STRING,$1:RECORD_TYPE::STRING,$1:CALL_DURATION_SECS::FLOAT,$1:FIRST_RELEASE_SOURCE::INT,$1:CAUSE_CODE::STRING,$1:CAUSE_LOCATION::INT,$1:CALLING_NUMBER::STRING,$1:CALLING_NUMBER_PREFIX::STRING,$1:CALLED_NUMBER::STRING,$1:CALLED_NUMBER_PREFIX::STRING,$1:ROUTE_INDEX::INT,$1:ROUTE_NAME::STRING,$1:ORIGINATING_LINE_INFO::INT,$1:PRESENTATION_RESTRICTION::INT,$1:INCOMING_CALLING_NUMBER::STRING,$1:T38_FAX_CALL ,$1:GLARE_ENCOUNTERED ,$1:INGRESS_SIP_CALL_ID::STRING,$1:INGRESS_REMOTE_SIP_HOST::STRING,$1:INGRESS_TRUNK_GROUP::STRING,$1:INGRESS_CIC::INT,$1:INGRESS_LOCAL_MEDIA_HOST::STRING,$1:INGRESS_LOCAL_MEDIA_PORT::INT,$1:INGRESS_REMOTE_MEDIA_HOST::STRING,$1:INGRESS_REMOTE_MEDIA_PORT::INT,$1:INGRESS_ORIG_POINT_CODE::STRING,$1:INGRESS_DEST_POINT_CODE::STRING,$1:INGRESS_CODEC_TYPE::STRING,$1:INGRESS_RTP_PACKETIZATION::INT,$1:INGRESS_NUM_BYTES_SENT::INT,$1:INGRESS_NUM_PACKETS_SENT::INT,$1:INGRESS_NUM_BYTES_RECV::INT,$1:INGRESS_NUM_PACKETS_RECV::INT,$1:INGRESS_NUM_PACKETS_LOST::INT,$1:INGRESS_JITTER::INT,$1:INGRESS_LATENCY::INT,$1:INGRESS_MAX_PACKET_OUTAGE::INT,$1:INGRESS_PLAYOUT_QUALITY::STRING,$1:INGRESS_ECHO_CANCELLATION::INT,$1:INGRESS_CARRIER::STRING,$1:EGRESS_SIP_CALL_ID::STRING,$1:EGRESS_REMOTE_SIP_HOST::STRING,$1:EGRESS_TRUNK_GROUP::STRING,$1:EGRESS_CIC::INT,$1:EGRESS_LOCAL_MEDIA_HOST::STRING,$1:EGRESS_LOCAL_MEDIA_PORT::INT,$1:EGRESS_REMOTE_MEDIA_HOST::STRING,$1:EGRESS_REMOTE_MEDIA_PORT::INT,$1:EGRESS_ORIG_POINT_CODE::STRING,$1:EGRESS_DEST_POINT_CODE::STRING,$1:EGRESS_CODEC_TYPE::STRING,$1:EGRESS_RTP_PACKETIZATION::INT,$1:EGRESS_NUM_BYTES_SENT::INT,$1:EGRESS_NUM_PACKETS_SENT::INT,$1:EGRESS_NUM_BYTES_RECV::INT,$1:EGRESS_NUM_PACKETS_RECV::INT,$1:EGRESS_NUM_PACKETS_LOST::INT,$1:EGRESS_JITTER::INT,$1:EGRESS_LATENCY::INT,$1:EGRESS_MAX_PACKET_OUTAGE::INT,$1:EGRESS_PLAYOUT_QUALITY::STRING,$1:EGRESS_ECHO_CANCELLATION::INT,$1:EGRESS_CARRIER::STRING,$1:SESSION_ID::INT,$1:ANSWER_FILE::STRING,$1:RELEASE_FILE::STRING,TO_TIMESTAMP(CURRENT_TIMESTAMP)::TIMESTAMP,$1:DIRECTION::STRING,$1:INGRESS_LOCAL_SIP_HOST::STRING,$1:EGRESS_LOCAL_SIP_HOST::STRING,$1:CALLING_NUMBER_ACCT::STRING,$1:CALLED_NUMBER_ACCT::STRING,$1:COUNTRY_CD::STRING,$1:COUNTRY::STRING,$1:LRN::STRING,$1:CLASS_OF_SERVICE::STRING,$1:ROUTE_SOURCE::STRING,$1:GATEWAY_HOSTNAME::STRING,$1:GLOBAL_CALL_ID::STRING,$1:CALLED_NUMBER_COUNTRY_CODE::STRING,$1:CALLED_NUMBER_COUNTRY_ISO::STRING,$1:CALLED_NUMBER_STATE::STRING,$1:CALLED_NUMBER_COUNTRY_IS_POSSIBLE::STRING,$1:CALLED_NUMBER_COUNTRY_IS_VALID::STRING,$1:DNIS::STRING,$1:RANK::INT,$1:SIP_STATUS_CODE_SENT::STRING,$1:SIP_STATUS_CODE_RECEIVED::STRING,$1:FLOW_TYPE::STRING,$1:FLOW_ORIGINATOR::STRING,$1:FLOW_TERMINATOR::STRING,$1:TRANSFER_ID::STRING,$1:POST_DIAL_DELAY::INT,$1:CALLING_NUMBER_COUNTRY_CODE::STRING,$1:CALLING_NUMBER_COUNTRY_ISO::STRING,$1:CALLING_NUMBER_STATE::STRING,$1:CALLED_NUMBER_COUNTRY_IS_POSSIBLE ,$1:CALLING_NUMBER_COUNTRY_IS_VALID ,$1:ROUTING_TYPE::STRING,$1:ROUTING_PREFIX::STRING,METADATA$FILENAME, current_timestamp,
$1:INGRESS_PROTOCOL_VARIANT_CALL_ID::STRING,$1:INGRESS_PROTOCOL_VARIANT_SIP_REQ_URI_USER_HOST::STRING,
$1:INGRESS_PROTOCOL_VARIANT_SIP_URI_PAI_USER_HOST::STRING,$1:EGRESS_PROTOCOL_VARIANT_CALL_ID::STRING,$1:EGRESS_PROTOCOL_VARIANT_SIP_REQ_URI_USER_HOST::STRING,
$1:EGRESS_PROTOCOL_VARIANT_SIP_URI_PAI_USER_HOST::STRING,

$1:EGRESS_PROTOCOL_VARIANT_FROM::STRING,
$1:EGRESS_PROTOCOL_VARIANT_TO::STRING,
$1:EGRESS_PROTOCOL_VARIANT_INVITE_CONTACT_HEADER::STRING,
$1:INGRESS_PROTOCOL_VARIANT_FROM::STRING,
$1:INGRESS_PROTOCOL_VARIANT_TO::STRING,
$1:INGRESS_PROTOCOL_VARIANT_INVITE_CONTACT_HEADER::STRING

FROM {{ SNOWFLAKE_FROM }}{{ FORMATED_TIME }}
(FILE_FORMAT=>{{ SNOWFLAKE_FORMAT }})
);