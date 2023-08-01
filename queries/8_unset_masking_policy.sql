-- Search for unsetting of a masking policy
select *
from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
where QUERY_TEXT ilike '%UNSET MASKING POLICY%'
and START_TIME >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP());