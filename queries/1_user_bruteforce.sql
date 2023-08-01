-- Get users who failed to login from the same IP address at least 5 times
select CLIENT_IP, USER_NAME, REPORTED_CLIENT_TYPE, count(*) as FAILED_ATTEMPTS, min(EVENT_TIMESTAMP) as FIRST_EVENT, max(EVENT_TIMESTAMP) as LAST_EVENT
from SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
where IS_SUCCESS = 'NO' and ERROR_MESSAGE in ('INCORRECT_USERNAME_PASSWORD', 'USER_LOCKED_TEMP') and FIRST_AUTHENTICATION_FACTOR='PASSWORD' and
      EVENT_TIMESTAMP >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
group by 1,2,3
having FAILED_ATTEMPTS >= 5
order by 4 desc;