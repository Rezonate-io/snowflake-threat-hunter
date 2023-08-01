-- The following query will show the stages that were created in the last 24 hours
select * from SNOWFLAKE.ACCOUNT_USAGE.STAGES
where CREATED>= DATEADD(HOUR, -24, CURRENT_TIMESTAMP());