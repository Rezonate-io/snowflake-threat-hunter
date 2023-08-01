Scenario Requirements:
1. Install the required modules:
`python -m pip install -r requirements.txt`

This script reads the SQL queries under ./queries and writes the results to CSV files

To execute the script, you can use the following command-line format:

`python snowflake_threat_hunting.py --account <snowflake_account> --username <snowflake_username> --password <password> --db <database_name>`