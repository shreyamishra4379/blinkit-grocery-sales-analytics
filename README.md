# blinkit-grocery-sales-analytics

Cleans raw grocery sales data, structures it into a simple star-schema data model
in SQL Server, and runs diagnostic SQL analysis to uncover what really drives
outlet and product performance — including a 10.9x sales gap between outlet
formats and evidence that shelf visibility doesn't actually drive sales.

Welcome to the **Blinkit Grocery Sales Analytics** repository! 🚀
This project demonstrates an end-to-end data analyst workflow — from cleaning
raw retail data to structuring it for analysis to generating actionable business
insights — built using SQL Server. Designed as a portfolio project, it highlights
practical data cleaning, data modeling, and analytical SQL skills used in real
data analyst roles.

## 🚀 Project Requirements

### Structuring the Data (Data Preparation & Modeling)

**Objective**
Clean and structure Blinkit's grocery sales data using SQL Server to enable
reliable analytical reporting and support merchandising/operations decisions.

**Specifications**
- **Data Source**: Retail grocery sales dataset (item + outlet attributes and
  transactions), provided as a CSV file.
- **Data Quality**: Cleanse inconsistent categorical labels, impute missing values,
  and correct logically invalid entries (e.g., 0% shelf visibility) prior to analysis.
- **Data Modeling**: Organize the cleansed data into a single, analysis-ready star
  schema (fact + dimension tables) to make querying simpler and more reliable.
- **Scope**: Focus on the provided dataset snapshot; historization is not required.
- **Documentation**: Clear documentation of the data model and cleaning logic to
  support both business stakeholders and analytics teams.

### Analysis & Reporting (Data Analysis)

**Objective**
Develop SQL-based analytics to deliver detailed insights into:
- Outlet Format Performance
- Product & Category Performance
- Shelf Visibility & Placement Effectiveness
- Location Tier Performance

These insights empower merchandising, operations, and marketing stakeholders with
key business metrics to support strategic decision-making.

## 🏗️ Data Organization

This project structures the data in three stages, inspired by the Bronze/Silver/Gold
pattern used in analytics workflows:

- **Bronze (raw)**: Raw data as-is from the source CSV, loaded into SQL Server.
- **Silver (cleaned)**: Cleansing, standardization, and derived-column logic applied
  to prepare data for analysis.
- **Gold (analysis-ready)**: Data modeled into a star schema
  (`fact_sales`, `dim_item`, `dim_outlet`) for querying and reporting.

## 📊 Key Findings

| Finding | Detail |
|---|---|
| Format performance gap | Supermarket Type3 outlets generate **10.9x higher average sales per transaction** than Grocery Store format ($3,694 vs $340) |
| Visibility ≠ sales | Items with the **lowest** shelf visibility outsold items with the **highest** visibility by ~25% — no positive correlation found |
| Outlet age | The oldest outlets (established 1985) **outperform** newer outlets |
| Location tier | Tier 2 locations show the **highest average sale per transaction** ($2,324), despite Tier 3 leading on total volume |

Full findings and business recommendations: [`docs/Organizational_Impact_Case_Study.md`](docs/Organizational_Impact_Case_Study.md)

## 📂 Repository Structure

```
blinkit-grocery-sales-analytics/
│
├── datasets/
│   └── GrocerySales.csv              -- raw source data (8,523 rows)
│
├── bronze/
│   └── 01_setup_and_import.sql       -- database creation & raw data import
│
├── silver/
│   ├── 02_data_cleaning.sql          -- standardizes labels, imputes missing values
│   └── 03_derived_columns.sql        -- adds Outlet_Age, Item_Category_Group
│
├── gold/
│   ├── 04_star_schema.sql            -- builds dim_item, dim_outlet, fact_sales
│   └── 05_analysis_queries.sql       -- business & diagnostic analysis queries
│
├── docs/
│   └── Organizational_Impact_Case_Study.md   -- findings & recommendations
│
└── README.md
```

## 🛡️ License

This project is licensed under the MIT License. You are free to use, modify, and
distribute this project according to the terms of the license.

## 🌟 About Me

Hi! I'm Shreya Mishra, a BTech student interested in Data Analytics and SQL.

This project is part of my learning journey, where I'm building practical
experience with SQL Server, data cleaning, data modeling, and analytical SQL to
support real business decision-making.

I'm continuously learning and working on projects to strengthen my technical and
problem-solving skills as a data analyst.

## 🔗 Connect with Me

💼 LinkedIn
💻 GitHub
