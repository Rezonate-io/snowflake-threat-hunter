-- Search for new data shares
select *
from SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
where IS_SUCCESS = 'NO' and  ERROR_MESSAGE  = 'INCOMING_IP_BLOCKED' and EVENT_TIMESTAMP >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP());