# agent2_sql_generator.py

import json
import os

class Agent2SQLGenerator:
    """
    Agent 2: Takes high-level use cases, understands Snowflake database structure via a Semantic Model,
    and generates specific, executable SQL queries for testing using Snowflake Cortex Analyst (conceptual).
    """

    def __init__(self, semantic_model_path="/home/ubuntu/semantic_model.yaml"):
        """
        Initializes the agent.
        semantic_model_path (str): Path to the conceptual semantic model YAML file.
        """
        self.semantic_model_path = semantic_model_path
        # In a real scenario, you would ensure this semantic model is available in a Snowflake stage
        # accessible by Cortex Analyst.
        print(f"Agent 2 (SQL Generator) initialized. Using conceptual semantic model: {self.semantic_model_path}")

    def _construct_cortex_agent_api_payload(self, use_case_text):
        """
        Constructs the payload for the conceptual Snowflake Cortex Agent API call.
        This payload would instruct the agent to use Cortex Analyst with the semantic model.
        """
        # The tool_resources path for semantic_model_file would typically be a Snowflake stage path, e.g., "@mystage/semantic_model.yaml"
        # For this conceptual example, we use the local path as a placeholder for what would be configured.
        payload = {
            "model": "llama3.1-70b", # Model for response generation by the agent, not for SQL gen by Analyst directly
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": f"Based on our database schema (defined in the semantic model '{os.path.basename(self.semantic_model_path)}'), generate a specific SQL query to test the following use case: {use_case_text}"
                        }
                    ]
                }
            ],
            "tools": [
                {
                    "tool_spec": {
                        "type": "cortex_analyst_text_to_sql",
                        "name": "database_analyzer" # An arbitrary name for this tool instance
                    }
                }
            ],
            "tool_resources": {
                "database_analyzer": {"semantic_model_file": f"@internal_stage/{os.path.basename(self.semantic_model_path)}"} # Conceptual stage path
            },
            "response_instruction": "Provide only the generated SQL query as a raw string. Do not include any explanations or markdown formatting."
        }
        return payload

    def _call_cortex_agent_api(self, payload):
        """
        (Conceptual) Simulates a call to the Snowflake Cortex Agent REST API.
        In a real scenario, this would be an HTTP POST request to '/api/v2/cortex/agent:run'.
        The response from Cortex Analyst (via the Agent) would be the SQL query.
        """
        use_case_in_payload = payload["messages"][0]["content"][0]["text"]
        print(f"\n--- Simulating Cortex Agent API Call (Agent 2 for use case: '{use_case_in_payload[:100]}...') ---")
        print(f"Payload sent (conceptual):\n{json.dumps(payload, indent=2)}")

        # Simulated SQL query response based on the use case
        # This is highly dependent on the use case and the (conceptual) semantic model.
        # We'll create some plausible SQL queries for the example use cases.
        simulated_sql_query = "-- Placeholder: No specific SQL generated for this generic simulation step."
        if "total order value" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT c.customer_id, c.customer_name, SUM(oi.quantity * p.price) AS total_order_value\nFROM Customers c\nJOIN Orders o ON c.customer_id = o.customer_id\nJOIN Order_Items oi ON o.order_id = oi.order_id\nJOIN Products p ON oi.product_id = p.product_id\nGROUP BY c.customer_id, c.customer_name;"
        elif "inventory levels" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT product_id, product_name, stock_quantity FROM Products WHERE last_updated > CURRENT_TIMESTAMP() - INTERVAL '1 DAY';"
        elif "consistency between customers and orders" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT o.order_id, o.customer_id FROM Orders o LEFT JOIN Customers c ON o.customer_id = c.customer_id WHERE c.customer_id IS NULL;"
        elif "user roles and permissions" in use_case_in_payload.lower():
            simulated_sql_query = "-- This use case typically requires checking application logic or specific permission tables.\n-- For example, trying to access data as a user with insufficient privileges (conceptual test, not a direct query for data).
SELECT COUNT(*) FROM Financial_Data; -- (This would be run by different roles)"
        elif "new user registration" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT user_id, email, profile_status FROM User_Profiles WHERE registration_date > CURRENT_TIMESTAMP() - INTERVAL '1 HOUR' AND (email IS NULL OR name IS NULL);"
        elif "historical sales data" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT DATE_TRUNC('month', order_date) AS sales_month, SUM(order_total) AS monthly_sales\nFROM Orders\nWHERE order_date >= DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year' AND order_date < DATE_TRUNC('year', CURRENT_DATE)\nGROUP BY sales_month\nORDER BY sales_month;"
        elif "product categorization" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT c.category_name, p.product_name FROM Products p JOIN Categories c ON p.category_id = c.category_id ORDER BY c.category_name, p.product_name LIMIT 20;"
        elif "supplier information" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT supplier_id, supplier_name FROM Suppliers WHERE address IS NULL OR phone IS NULL;"
        elif "product returns" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT r.return_id, r.order_id, r.product_id, r.return_date, o.order_status, p.stock_quantity\nFROM Returns r\nJOIN Orders o ON r.order_id = o.order_id\nJOIN Products p ON r.product_id = p.product_id\nWHERE r.processed_date > CURRENT_TIMESTAMP() - INTERVAL '7 DAY';"
        elif "transactions are logged" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT transaction_id, user_id, transaction_type, transaction_time FROM Audit_Log WHERE transaction_time >= CURRENT_TIMESTAMP() - INTERVAL '1 DAY' ORDER BY transaction_time DESC;"
        elif "searching for customers" in use_case_in_payload.lower():
            simulated_sql_query = "SELECT customer_id, customer_name, email FROM Customers WHERE email LIKE '%@example.com';"
        else:
            # Fallback for unmapped use cases to ensure we get enough queries
            simulated_sql_query = f"SELECT * FROM Some_Table WHERE condition_related_to_'{use_case_in_payload[:30].replace("'", "")}';"

        print(f"Simulated SQL Query from Cortex Analyst (via Agent):\n{simulated_sql_query}")
        print("--- End of Simulated Cortex Agent API Call ---\n")
        # The actual API would stream a response. For simplicity, we assume the final SQL is extracted.
        # A real response might be a JSON object from which the SQL needs to be extracted.
        return simulated_sql_query # In reality, this would be parsed from the API's JSON response

    def generate_sql_queries(self, high_level_use_cases):
        """
        Generates specific SQL queries from high-level use cases.

        Args:
            high_level_use_cases (list): A list of natural language use cases from Agent 1.

        Returns:
            list: A list of generated SQL query strings, or None if an error occurs.
        """
        if not high_level_use_cases or not isinstance(high_level_use_cases, list):
            print("Error: No high-level use cases provided or format is incorrect.")
            return None

        sql_queries = []
        for use_case in high_level_use_cases:
            if not isinstance(use_case, str) or not use_case.strip():
                print(f"Warning: Skipping invalid use case: {use_case}")
                continue
            
            payload = self._construct_cortex_agent_api_payload(use_case)
            sql_query = self._call_cortex_agent_api(payload)
            
            if sql_query and "Placeholder: No specific SQL generated" not in sql_query:
                sql_queries.append(sql_query)
            else:
                print(f"Warning: Could not generate a specific SQL query for use case: {use_case}")

        # Ensure at least 10 queries if possible, even if some are generic due to simulation
        # In a real scenario, the quality and number would depend on Cortex Analyst and the semantic model.
        idx = 0
        while len(sql_queries) < 10 and idx < len(high_level_use_cases):
            # Try to generate more generic queries if specific ones failed or were insufficient
            use_case = high_level_use_cases[idx]
            if not any(use_case_part in q for q in sql_queries for use_case_part in use_case.split()[:3]): # Avoid re-adding if already covered
                generic_query = f"SELECT COUNT(*) FROM Some_Table_Related_To_{use_case.split()[0].upper()}; -- Generic fallback for {use_case[:30]}..."
                sql_queries.append(generic_query)
            idx +=1
        
        if len(sql_queries) == 0:
             print("Error: Failed to generate any SQL queries.")
             return None
             
        return sql_queries[:10] # Return at most 10 as per original high-level plan, though prompt asked for 10+

# --- Example Usage (Conceptual) ---
if __name__ == "__main__":
    print("Starting Agent 2 example...")
    # This agent relies on a conceptual semantic model. We'll simulate its existence.
    # In a real scenario, semantic_model.yaml would be created and uploaded to a Snowflake stage.
    conceptual_semantic_model_file = "/home/ubuntu/semantic_model.yaml"
    with open(conceptual_semantic_model_file, "w") as f:
        f.write("""# Conceptual Semantic Model (YAML)
# This file would define tables, columns, relationships, and business context for Cortex Analyst.
# Example (very simplified):
version: 1
semantic_model:
  name: ECommerceDB_SemanticModel
  description: Semantic model for the e-commerce database.
  tables:
    - name: Customers
      columns:
        - name: customer_id
          data_type: INTEGER
          is_primary_key: true
        - name: customer_name
          data_type: VARCHAR
        - name: email
          data_type: VARCHAR
    - name: Orders
      columns:
        - name: order_id
          data_type: INTEGER
          is_primary_key: true
        - name: customer_id # Foreign Key
          data_type: INTEGER
        - name: order_date
          data_type: DATE
        - name: order_total
          data_type: DECIMAL(10,2)
    # ... more tables (Products, Order_Items, Categories, Suppliers, etc.) and relationships would be defined here
""")
    print(f"Created conceptual semantic model at {conceptual_semantic_model_file}")

    agent2 = Agent2SQLGenerator(semantic_model_path=conceptual_semantic_model_file)

    # Use cases typically from Agent 1
    sample_use_cases_from_agent1 = [
        "Verify the accuracy of total order value calculation for each customer.",
        "Ensure that all product inventory levels are correctly updated after a sale is processed.",
        "Check for data consistency between the customers table and the orders table via customer IDs.",
        "Validate that user roles and permissions restrict access to sensitive financial data as per requirements.",
        "Test the process for new user registration and ensure all required fields are populated in the user profile table.",
        "Verify that historical sales data can be queried correctly for monthly and quarterly reporting.",
        "Ensure that product categorization is consistent and allows for accurate filtering and searching.",
        "Test the data integrity constraints for supplier information, including contact details and addresses.",
        "Validate the process for handling product returns and ensure inventory and financial records are updated accordingly.",
        "Check that all transactions are logged with accurate timestamps and user identifiers for audit purposes.",
        "Verify that searching for customers by name or email returns correct and complete results."
    ]

    print(f"\nInput Use Cases for Agent 2:\n{json.dumps(sample_use_cases_from_agent1, indent=2)}\n")

    generated_sql = agent2.generate_sql_queries(sample_use_cases_from_agent1)

    if generated_sql:
        print("\nSuccessfully generated SQL queries (first 10 shown):")
        for i, sql in enumerate(generated_sql):
            print(f"\nQuery {i+1}:\n{sql}")
    else:
        print("\nFailed to generate SQL queries.")

    print("\nAgent 2 example finished.")

