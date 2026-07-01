import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine
load_dotenv()

df = pd.read_csv("data/healthcare_dataset.csv")
# Fixing up column names
df.columns = df.columns.str.strip().str.lower().str.replace(' ','_')

db_url = os.getenv("DB_URL")
def get_connection():
    engine = create_engine(db_url)
    return engine
if __name__ == "__main__":

    try:
        engine = get_connection()
        print("Connection made succesfully")
    
    except Exception as e:
        print(f"An error occurred: {e}")

df.to_sql('patients', engine, if_exists='replace', index=False)
print("ETL Pipeline completed successfully!")