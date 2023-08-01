-- Spikes in user queries
WITH user_daily_bytes AS (
  SELECT
    USER_NAME AS user_name,
    DATE_TRUNC('DAY', END_TIME) AS query_date,
    SUM(BYTES_WRITTEN_TO_RESULT) AS total_bytes_written
  FROM ACCOUNT_USAGE.QUERY_HISTORY
  WHERE END_TIME >= CURRENT_TIMESTAMP() - INTERVAL '7 DAY'
  GROUP BY user_name, query_date
),
user_daily_average AS (
  SELECT
    user_name,
    AVG(total_bytes_written) AS avg_bytes_written,
    STDDEV_SAMP(total_bytes_written) AS stddev_bytes_written
  FROM user_daily_bytes
  GROUP BY user_name
)
SELECT
  u.user_name,
  ROUND(u.total_bytes_written, 2) AS today_bytes_written,
  ROUND(a.avg_bytes_written, 2) AS avg_daily_bytes,
  ROUND(a.stddev_bytes_written, 2) AS stddev_daily_bytes
FROM user_daily_bytes u
JOIN user_daily_average a 
  ON u.user_name = a.user_name
WHERE query_date = CURRENT_DATE()
  AND u.total_bytes_written > a.avg_bytes_written
  AND u.total_bytes_written > stddev_daily_bytes + avg_daily_bytes
ORDER BY u.user_name;