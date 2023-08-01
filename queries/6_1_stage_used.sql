-- Search for stage-related statements
select *
from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
where QUERY_TEXT ilike '%COPY INTO%'
and QUERY_TEXT ilike '%@%'
and START_TIME >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP());