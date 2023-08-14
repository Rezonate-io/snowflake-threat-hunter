Scenario Requirements:
1. Install the required modules:
`python -m pip install -r requirements.txt`

This script reads the SQL queries under ./queries and writes the results to CSV files

To execute the script, you can use the following command-line format:

`python snowflake_threat_hunting.py --account <snowflake_account> --username <snowflake_username> --password <password> --db <database_name>`

The output of each query is stored in the current directory as a CSV file named after the corresponding query. e.g, the file 1_user_bruteforce.csv is the output of the query results from 1_user_bruteforce.sql.
