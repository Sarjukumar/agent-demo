# app.py

import streamlit as st
from main_orchestrator import MainOrchestrator
import os
import json # For pretty printing dicts/lists if needed

# --- Page Configuration ---
st.set_page_config(
    page_title="Snowflake SQL Test Case Generator",
    page_icon="❄️",
    layout="wide"
)

# --- Helper Functions ---
def display_results(results):
    st.subheader("Processed Results")

    if results.get("errors"):
        st.error("Errors encountered during processing:")
        for error in results["errors"]:
            st.write(f"- {error}")
        st.markdown("---")

    if results.get("high_level_use_cases"):
        st.markdown("### 1. High-Level Use Cases (from Agent 1)")
        for i, uc in enumerate(results["high_level_use_cases"]):
            st.write(f"{i+1}. {uc}")
        st.markdown("---")
    else:
        st.info("No high-level use cases were generated or Agent 1 did not complete successfully.")
        st.markdown("---")

    if results.get("generated_sql_queries"):
        st.markdown("### 2. Generated SQL Queries (from Agent 2)")
        for i, sql in enumerate(results["generated_sql_queries"]):
            st.markdown(f"**Query {i+1}:**")
            st.code(sql, language="sql")
        st.markdown("---")
    elif results.get("high_level_use_cases"): # Only show this if Agent 1 ran but Agent 2 didn't produce SQL
        st.info("No SQL queries were generated or Agent 2 did not complete successfully.")
        st.markdown("---")

    if results.get("sql_execution_results"):
        st.markdown("### 3. SQL Execution Results (from Agent 3 - Max 10 rows per query)")
        for query, result_data in results["sql_execution_results"].items():
            st.markdown(f"**Results for Query:**")
            st.code(query, language="sql")
            if result_data.get("headers") and result_data.get("data") is not None:
                if result_data["headers"][0] == "Error":
                    st.error(f"Error executing query: {result_data["data"][0][0]}")
                else:
                    st.table(result_data) # Streamlit table handles headers and data nicely
            else:
                st.write("No data returned for this query or an error occurred during its execution.")
            st.markdown("&nbsp;") # Little spacer
        st.markdown("---")
    elif results.get("generated_sql_queries"): # Only show if Agent 2 ran but Agent 3 didn't produce results
        st.info("SQL queries were not executed or Agent 3 did not complete successfully.")
        st.markdown("---")

# --- Main Application UI ---
st.title("❄️ Snowflake SQL Test Case Generation Agent System")
st.markdown("""
This application uses a multi-agent system to process a requirements document, 
generate SQL test use cases for a Snowflake database, and conceptually execute them.

**Instructions:**
1.  Upload your requirements document (as a plain text `.txt` file).
2.  (Optional) Configure conceptual Snowflake connection parameters if you were running this against a live instance.
3.  Click "Process Requirements" to start the agent workflow.
4.  View the generated use cases, SQL queries, and conceptual execution results below.
""")

st.sidebar.header("Configuration")
st.sidebar.markdown("**Note:** For this demonstration, agents run in a *conceptual/simulated* mode for Snowflake interactions. In a real deployment, provide actual credentials and ensure the semantic model is correctly set up in Snowflake.")

# Conceptual Snowflake Connection Parameters (User would fill these in a real scenario)
# These are NOT used by the simulation but are here to show what would be needed.
st.sidebar.subheader("Conceptual Snowflake Connection")
sf_user = st.sidebar.text_input("Snowflake User (Conceptual)", value="SIM_USER")
sf_password = st.sidebar.text_input("Snowflake Password (Conceptual)", type="password", value="SIM_PASS")
sf_account = st.sidebar.text_input("Snowflake Account Identifier (Conceptual)", value="SIM_ACCOUNT_IDENTIFIER")
sf_warehouse = st.sidebar.text_input("Snowflake Warehouse (Conceptual)", value="SIM_WAREHOUSE")
sf_database = st.sidebar.text_input("Snowflake Database (Conceptual)", value="SIM_DATABASE")
sf_schema = st.sidebar.text_input("Snowflake Schema (Conceptual)", value="SIM_SCHEMA")

conceptual_connection_params = {
    "user": sf_user,
    "password": sf_password,
    "account": sf_account,
    "warehouse": sf_warehouse,
    "database": sf_database,
    "schema": sf_schema
}

# Path to the conceptual semantic model (Agent 2 uses this)
# In a real scenario, this YAML would be in a Snowflake stage.
conceptual_semantic_model_path = "/home/ubuntu/semantic_model.yaml"

st.sidebar.markdown(f"**Conceptual Semantic Model Path:** `{conceptual_semantic_model_path}` (Agent 2 will use this conceptually)")


# File Uploader
st.header("1. Upload Requirements Document")
uploaded_file = st.file_uploader("Choose a .txt file with your requirements", type="txt")

requirements_text = ""
if uploaded_file is not None:
    try:
        requirements_text = uploaded_file.read().decode("utf-8")
        st.text_area("Requirements Document Content (Preview)", requirements_text, height=200)
    except Exception as e:
        st.error(f"Error reading file: {e}")
        requirements_text = ""

# Process Button and Output Area
st.header("2. Process and View Results")
if st.button("Process Requirements and Generate SQL Tests"):
    if not requirements_text:
        st.warning("Please upload a requirements document first.")
    else:
        with st.spinner("Agents at work... This may take a moment as it involves conceptual LLM calls and processing."):
            try:
                # Initialize orchestrator (it will initialize agents)
                # Pass conceptual params; agents are designed to simulate if these are not fully functional
                orchestrator = MainOrchestrator(
                    conceptual_snowflake_connection_params=conceptual_connection_params,
                    conceptual_semantic_model_path=conceptual_semantic_model_path
                )
                
                # Run the full pipeline
                st.session_state.results = orchestrator.process_requirements_to_sql_results(requirements_text)
                st.success("Processing complete!")
            except Exception as e:
                st.error(f"An error occurred during orchestration: {e}")
                st.session_state.results = {"errors": [f"Orchestration Error: {str(e)}"]}

if "results" in st.session_state:
    display_results(st.session_state.results)

st.markdown("---")
st.markdown("Conceptual Multi-Agent System for Snowflake SQL Test Case Generation - Manus AI")

# To run this Streamlit app:
# 1. Save this code as app.py in the same directory as agent1_..., agent2_..., agent3_..., main_orchestrator.py
# 2. Ensure a placeholder semantic_model.yaml exists or is created by the orchestrator.
# 3. Open your terminal in that directory and run: streamlit run app.py

