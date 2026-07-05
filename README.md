# Clinical Risk Pipeline

![Live App Demo](output\dashboard-image.png) 

**[View the Live Dashboard Here](https://connect.posit.cloud/andrew-naranjo/content/019f2006-0a93-f1eb-b4e3-4e5fbd383118)**

## Overview
An end-to-end clinical data pipeline and interactive dashboard used to predict patient outcomes using classification and regression models. This repository contains the Phase 1 deployment, which uses synthetic clinical data from [this Kaggle dataset](https://www.kaggle.com/datasets/prasad22/healthcare-dataset). 

## Stack
* **Language:** R
* **Frontend:** Shiny
* **Modeling:** `tidymodels`
* **Database:** PostgreSQL (Local)
* **Deployment:** Posit Connect Cloud

## Project Architecture 
1. **ETL & Data Engineering:** Data is extracterd from a local PostgreSQL database and transformed for modeling.
2. **Statistical Modeling:** Two models (Classification for risk stratification, Regression for continuous outcome prediction) were trained using the `tidymodels` framework.
3. **Interactive Dashboard:** Deployed a Shiny web application for users to input clinical parameters and receive real-time risk predictions.

## Roadmap: Phase 2
The next phase of this project involves migrating from synthetic data to the **MIMIC-IV Clinical Database**. I'll first use the demo dataset to ask some interesting questions and replace the current dataset with it.