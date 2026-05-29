# Decoding Customer Value: A SQL-Driven Retention Strategy

## Project Overview
This repository contains an end-to-end features.csvcs and strategy project developed for a Direct-to-Consumer (D2C) fashion brand. The goal of the project is to transition the brand from relying on reactive promotional discounts to a structured, data-backed customer retention strategy.

By leveraging **Python**, **SQL**, and **Power BI**, this project processes raw behavioral data from ~3,900 customers to uncover genuine brand loyalty, identify discount-driven volume, and propose an actionable retention playbook.

## Business Problem
The D2C brand possessed rich transactional data but lacked actionable intelligence. Critical unanswered questions included:
- Who are the genuinely loyal customers versus one-time bargain hunters?
- Which geographic regions generate organic demand compared to discount-driven sales?
- How can the brand safely sunset heavy promotions without cannibalizing overall revenue?

## Tech Stack
- **Data Processing & Engineering:** Python (Pandas, NumPy)
- **Database & Querying:** SQL 
- **Data Visualization:** Power BI
- **Reporting:** Strategy Formulation & Business Analytics

## Repository Structure
```text
├── Assets/                                 # Dashboard assets and visuals
├── Data/                                   # Raw/intermediate data files
├── Executive_Summary.pdf                   # 1-page high-level business summary for stakeholders
├── Report.pdf                              # Comprehensive technical report and retention playbook
├── SQL_queries.sql                         # The core SQL scripts for all segmentations
├── shopping_cleaned_engineered.csv         # Engineered dataset with custom loyalty/value metrics
│
└── Query Outputs (CSV):
    ├── Q1a- High-value vs Low-value customer profile comparison.csv
    ├── Q1b- Four-quadrant profile - loyalty x value.csv
    ├── Q2a- Season x Tenure band.csv
    ├── Q2b- Category x Tenure band.csv
    ├── Q3a- Geography - classified as Organic _ Discount-Driven _ Mixed.csv
    ├── Q3b- Underlevered demographic.csv
    ├── Q4a- Sunset candidates - high tenure + discount dependent.csv
    ├── Q4b- Promo firewall segment - high frequency new customers.csv
    ├── Q4c- Three-way segment comparison for promotional strategy.csv
    └── Q5a- Ideal customer - intersection of all positive features.csv
