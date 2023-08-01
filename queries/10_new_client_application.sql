-- User uses a new client application
WITH user_previous_applications AS (
  SELECT
    USER_NAME AS user_name,
    ARRAY_AGG(DISTINCT CLIENT_APPLICATION_ID) AS previous_applications
  FROM ACCOUNT_USAGE.SESSIONS
  WHERE DATE_TRUNC('DAY', CREATED_ON) < CURRENT_DATE()
  GROUP BY user_name
),
latest_login_ips  AS (
  SELECT
    USER_NAME,
    EVENT_ID,
    CLIENT_IP
  FROM ACCOUNT_USAGE.LOGIN_HISTORY
) 
SELECT
  s.USER_NAME AS user_name,
  ARRAY_AGG(DISTINCT s.SESSION_ID),
  ARRAY_AGG(DISTINCT s.CLIENT_APPLICATION_ID) AS new_application_id,
  lh.CLIENT_IP as ip_address
FROM ACCOUNT_USAGE.SESSIONS s
JOIN user_previous_applications u
  ON s.USER_NAME = u.user_name
JOIN latest_login_ips lli
  ON s.USER_NAME = lli.USER_NAME
JOIN ACCOUNT_USAGE.LOGIN_HISTORY lh
  ON s.LOGIN_EVENT_ID = lli.EVENT_ID
WHERE DATE_TRUNC('DAY', s.CREATED_ON) = CURRENT_DATE()
  AND NOT ARRAY_CONTAINS(s.CLIENT_APPLICATION_ID::variant, u.previous_applications)
group by s.USER_NAME,lh.CLIENT_IP;