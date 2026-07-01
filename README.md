# Project Status: Phase 1

This repository demonstrates a complete, end-to-end clinical data pipeline. I engineered a PostgreSQL database, an automated ETL pipeline, and a predictive dashboard using Python, R, and RShiny.

Note: To comply with healthcare data privacy standards, the pipeline is currently populated with a synthetic test dataset from Kaggle while awaiting credentialed access
to the MIMIC-IV clinical dataset.

## Architecture
1. **Storage(PostgreSQL)**:A local relational database housing the raw patient records.

2. **Machine Learning (tidymodels)**: R scripts that connect securely to the database, extract the necessary data, and train predictive models.

3. **Deployment (R/Shiny)**: A secure web application hosted on Posit Cloud that utilizes the pre-trained model weights to generate inference without exposing the database.

# Future Roadmap (Phase 2)

Upon receiving credentialed access to the PhysioNet MIMIC-IV database, the pipeline will be updated to execute SQL operations across admission, lab event, and demographic tables to train the models on real-world clinical relationships.