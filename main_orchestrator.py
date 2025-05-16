# main_orchestrator.py

from agent1_requirements_analyzer import Agent1RequirementsAnalyzer
from agent2_sql_generator import Agent2SQLGenerator
from agent3_sql_executor import Agent3SQLExecutor
import os

class MainOrchestrator:
    """
    Orchestrates the workflow between Agent 1, Agent 2, and Agent 3.
    """
    def __init__(self, conceptual_snowflake_connection_params=None, conceptual_semantic_model_path="/home/ubuntu/semantic_model.yaml"):
        """
        Initializes the orchestrator and the agents.
        """
        print("Main Orchestrator initializing...")
        self.agent1 = Agent1RequirementsAnalyzer(snowflake_connection_params=conceptual_snowflake_connection_params)
        
        # Ensure the conceptual semantic model file exists for Agent 2, even if basic
        self.conceptual_semantic_model_path = conceptual_semantic_model_path
        if not os.path.exists(self.conceptual_semantic_model_path):
            print(f"Warning: Conceptual semantic model not found at {self.conceptual_semantic_model_path}. Creating a placeholder.")
            try:
                with open(self.conceptual_semantic_model_path, "w") as f:
                    f.write("""version: 1
semantic_model:
  name: PlaceholderSemanticModel
  description: A placeholder semantic model.
  tables: []
""")
                print(f"Created placeholder semantic model: {self.conceptual_semantic_model_path}")
            except Exception as e:
                print(f"Error creating placeholder semantic model: {e}")

        self.agent2 = Agent2SQLGenerator(semantic_model_path=self.conceptual_semantic_model_path)
        self.agent3 = Agent3SQLExecutor(snowflake_connection_params=conceptual_snowflake_connection_params)
        print("Main Orchestrator initialized successfully.")

    def process_requirements_to_sql_results(self, requirements_document_text):
        """
        Runs the full pipeline from requirements document to SQL execution results.

        Args:
            requirements_document_text (str): The content of the requirements document.

        Returns:
            dict: A dictionary containing all intermediate and final results.
                  {
                      "high_level_use_cases": list | None,
                      "generated_sql_queries": list | None,
                      "sql_execution_results": dict | None,
                      "errors": list
                  }
        """
        results = {
            "high_level_use_cases": None,
            "generated_sql_queries": None,
            "sql_execution_results": None,
            "errors": []
        }

        print("\nOrchestrator: Starting Agent 1 - Requirements Analysis...")
        high_level_use_cases = self.agent1.analyze_requirements(requirements_document_text)
        if high_level_use_cases:
            results["high_level_use_cases"] = high_level_use_cases
            print(f"Orchestrator: Agent 1 completed. Found {len(high_level_use_cases)} use cases.")
        else:
            error_msg = "Orchestrator: Agent 1 failed to generate use cases."
            print(error_msg)
            results["errors"].append(error_msg)
            return results # Stop processing if Agent 1 fails

        print("\nOrchestrator: Starting Agent 2 - SQL Generation...")
        generated_sql_queries = self.agent2.generate_sql_queries(high_level_use_cases)
        if generated_sql_queries:
            results["generated_sql_queries"] = generated_sql_queries
            print(f"Orchestrator: Agent 2 completed. Generated {len(generated_sql_queries)} SQL queries.")
        else:
            error_msg = "Orchestrator: Agent 2 failed to generate SQL queries."
            print(error_msg)
            results["errors"].append(error_msg)
            # We can still proceed to show Agent 1 results even if Agent 2 fails
            return results 

        print("\nOrchestrator: Starting Agent 3 - SQL Execution...")
        sql_execution_results = self.agent3.execute_sql_queries(generated_sql_queries)
        if sql_execution_results:
            results["sql_execution_results"] = sql_execution_results
            print(f"Orchestrator: Agent 3 completed. Executed {len(sql_execution_results)} queries.")
        else:
            error_msg = "Orchestrator: Agent 3 failed to execute SQL queries or process results."
            print(error_msg)
            results["errors"].append(error_msg)
            
        return results

# --- Example Usage (Conceptual) ---
if __name__ == "__main__":
    print("Starting Main Orchestrator example...")
    orchestrator = MainOrchestrator(
        conceptual_snowflake_connection_params={"user": "SIM_USER", "account": "SIM_ACCOUNT"}
    )

    sample_requirements_doc_orchestrator = """
The system must track customer orders. Each order is placed by one customer and can contain multiple products.
Product details include name, price, and current stock. When an order is placed, stock levels must decrease.
We need to be able to see total sales per customer and identify top-selling products monthly.
User accounts need to be managed, including registration and login functionality.
    """
    print(f"\nSample Requirements Document for Orchestrator:\n{sample_requirements_doc_orchestrator}\n")

    final_results = orchestrator.process_requirements_to_sql_results(sample_requirements_doc_orchestrator)

    print("\n--- Main Orchestrator Final Results ---")
    if final_results["high_level_use_cases"]:
        print("\nHigh-Level Use Cases:")
        for i, uc in enumerate(final_results["high_level_use_cases"]):
            print(f"{i+1}. {uc}")
    
    if final_results["generated_sql_queries"]:
        print("\nGenerated SQL Queries:")
        for i, sql in enumerate(final_results["generated_sql_queries"]):
            print(f"\nQuery {i+1}:\n{sql}")

    if final_results["sql_execution_results"]:
        print("\nSQL Execution Results:")
        for query, result_data in final_results["sql_execution_results"].items():
            print(f"\nResults for Query:\n{query}")
            print(f"Headers: {result_data.get("headers")}")
            print("Data (limited to 10 rows):")
            if result_data.get("data"):
                for row in result_data["data"]:
                    print(row)
            else:
                print("No data or error.")
    
    if final_results["errors"]:
        print("\nErrors Encountered During Orchestration:")
        for err in final_results["errors"]:
            print(f"- {err}")
            
    print("\nMain Orchestrator example finished.")

