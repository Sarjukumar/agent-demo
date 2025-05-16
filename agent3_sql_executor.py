# agent3_sql_executor.py

import json
# import snowflake.connector # This would be uncommented in a real environment

class Agent3SQLExecutor:
    """
    Agent 3: Executes the generated SQL queries against the Snowflake database
    and formats the results, limiting output to 10 records per query.
    """

    def __init__(self, snowflake_connection_params=None):
        """
        Initializes the agent.
        snowflake_connection_params (dict): Parameters to connect to Snowflake.
                                          Example: {
                                              "user": "YOUR_USER", 
                                              "password": "YOUR_PASSWORD", 
                                              "account": "YOUR_ACCOUNT_IDENTIFIER",
                                              "warehouse": "YOUR_WAREHOUSE",
                                              "database": "YOUR_DATABASE",
                                              "schema": "YOUR_SCHEMA"
                                          }
        """
        self.snowflake_connection_params = snowflake_connection_params
        if self.snowflake_connection_params:
            print(f"Agent 3 (SQL Executor) initialized with conceptual Snowflake connection parameters for account: {self.snowflake_connection_params.get("account")}")
        else:
            print("Agent 3 (SQL Executor) initialized. (No Snowflake connection params provided - simulation mode only)")

    def _execute_single_query_on_snowflake(self, sql_query):
        """
        (Conceptual) Executes a single SQL query on Snowflake and fetches results.
        Limits results to 10 records.
        """
        print(f"\n--- Simulating SQL Execution on Snowflake (Agent 3) ---")
        print(f"Executing SQL Query:\n{sql_query}")

        # In a real implementation:
        # conn = None
        # try:
        #     if not self.snowflake_connection_params:
        #         print("Error: Snowflake connection parameters not provided.")
        #         return None, None # No headers, no data
        #     conn = snowflake.connector.connect(**self.snowflake_connection_params)
        #     cursor = conn.cursor()
        #     cursor.execute(sql_query)
        #     headers = [desc[0] for desc in cursor.description]
        #     # Fetch up to 10 records + 1 to see if there are more, then slice to 10
        #     data = cursor.fetchmany(11) 
        #     limited_data = [list(row) for row in data[:10]] # Convert tuples to lists for easier JSON serialization
        #     print(f"Fetched {len(limited_data)} records (limited to 10).")
        #     return headers, limited_data
        # except snowflake.connector.Error as e:
        #     print(f"Snowflake Error during SQL execution: {e}")
        #     error_message = f"Error executing SQL: {e.msg if hasattr(e, 'msg') else str(e)}"
        #     return ["Error"], [[error_message]]
        # except Exception as e:
        #     print(f"General Error during SQL execution: {e}")
        #     return ["Error"], [[f"General Error: {str(e)}"]]
        # finally:
        #     if "cursor" in locals() and cursor: cursor.close()
        #     if conn: conn.close()

        # Simulated response for demonstration
        simulated_headers = ["column_A", "column_B", "column_C"]
        simulated_data = []
        if "Customers" in sql_query and "SUM" not in sql_query:
            simulated_headers = ["customer_id", "customer_name", "email"]
            simulated_data = [
                [1, "Alice Wonderland", "alice@example.com"],
                [2, "Bob The Builder", "bob@example.com"],
                [3, "Charlie Brown", "charlie@example.com"]
            ]
        elif "Products" in sql_query:
            simulated_headers = ["product_id", "product_name", "stock_quantity"]
            simulated_data = [
                [101, "Laptop Pro", 50],
                [102, "Wireless Mouse", 200],
                [103, "Keyboard RGB", 150],
                [104, "Monitor 27inch", 75]
            ]
        elif "Orders" in sql_query and "SUM" in sql_query:
            simulated_headers = ["customer_id", "customer_name", "total_order_value"]
            simulated_data = [
                [1, "Alice Wonderland", 1250.75],
                [2, "Bob The Builder", 85.00]
            ]
        elif "COUNT(*)" in sql_query:
            simulated_headers = ["COUNT(*)"]
            simulated_data = [[150]] # Example count
        else:
            # Generic simulation for other queries
            for i in range(min(5, 10)): # Simulate a few rows up to 10
                simulated_data.append([f"data_A{i+1}", f"data_B{i+1}", i*100])
        
        print(f"Simulated Headers: {simulated_headers}")
        print(f"Simulated Data (first few rows): {simulated_data[:3]}")
        print("--- End of Simulated SQL Execution ---")
        return simulated_headers, simulated_data[:10] # Ensure limit

    def execute_sql_queries(self, sql_queries_list):
        """
        Executes a list of SQL queries and returns their results.

        Args:
            sql_queries_list (list): A list of SQL query strings.

        Returns:
            dict: A dictionary where keys are SQL queries and values are dicts 
                  containing {"headers": list, "data": list_of_lists (max 10 rows)}.
                  Returns None if input is invalid.
        """
        if not sql_queries_list or not isinstance(sql_queries_list, list):
            print("Error: No SQL queries provided or format is incorrect.")
            return None

        all_results = {}
        for i, sql_query in enumerate(sql_queries_list):
            if not isinstance(sql_query, str) or not sql_query.strip():
                print(f"Warning: Skipping invalid SQL query at index {i}: {sql_query}")
                all_results[f"Skipped_Invalid_Query_{i}"] = {"headers": ["Error"], "data": [["Invalid SQL query string"]]}
                continue
            
            headers, data = self._execute_single_query_on_snowflake(sql_query)
            all_results[sql_query] = {"headers": headers, "data": data}
        
        return all_results

# --- Example Usage (Conceptual) ---
if __name__ == "__main__":
    print("Starting Agent 3 example...")
    # Conceptual connection parameters (replace with actual in a real scenario)
    # For this example, we run in simulation mode as snowflake_connection_params is None by default.
    agent3 = Agent3SQLExecutor(snowflake_connection_params={
        "user": "CONCEPTUAL_USER", 
        "password": "CONCEPTUAL_PASSWORD", 
        "account": "CONCEPTUAL_ACCOUNT",
        # Add warehouse, database, schema if needed for connection
    })

    # SQL queries typically from Agent 2
    sample_sql_queries = [
        "SELECT c.customer_id, c.customer_name, SUM(oi.quantity * p.price) AS total_order_value\nFROM Customers c\nJOIN Orders o ON c.customer_id = o.customer_id\nJOIN Order_Items oi ON o.order_id = oi.order_id\nJOIN Products p ON oi.product_id = p.product_id\nGROUP BY c.customer_id, c.customer_name;",
        "SELECT product_id, product_name, stock_quantity FROM Products WHERE last_updated > CURRENT_TIMESTAMP() - INTERVAL '1 DAY';",
        "SELECT * FROM Non_Existent_Table; -- This should conceptually produce an error",
        "SELECT user_id, email, profile_status FROM User_Profiles WHERE registration_date > CURRENT_TIMESTAMP() - INTERVAL '1 HOUR' AND (email IS NULL OR name IS NULL);"
    ]

    print(f"\nInput SQL Queries for Agent 3:\n{json.dumps(sample_sql_queries, indent=2)}\n")

    execution_results = agent3.execute_sql_queries(sample_sql_queries)

    if execution_results:
        print("\nSuccessfully executed SQL queries (conceptual results):")
        for query, result in execution_results.items():
            print(f"\nQuery:\n{query}")
            print(f"Headers: {result.get('headers')}")
            print(f"Data (limited to 10 rows):")
            if result.get('data'):
                for row in result['data']:
                    print(row)
            else:
                print("No data returned or error in fetching.")
    else:
        print("\nFailed to execute SQL queries or process results.")

    print("\nAgent 3 example finished.")

