-- Search for new procedures
select *
from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
where REGEXP_LIKE(QUERY_TEXT, '.*CREATE\\s+(OR\\s+REPLACE\\s+)?PROCEDURE.*', 'i')
and START_TIME >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP());