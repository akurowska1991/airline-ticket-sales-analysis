# airline-ticket-sales-analysis
# Airline Ticket Sales & Revenue Analysis

## Project Overview

This project explores airline ticket sales, fare values, cabin class performance, and payment differences using a synthetic airline dataset.

The goal is to practise data analysis skills and demonstrate how SQL queries, spreadsheet analysis, and Tableau visualizations can help answer business questions related to airline operations and commercial performance.

## Tools & Technologies

- **PostgreSQL** — data exploration, SQL queries, aggregations, joins, and data validation
- **Google Sheets** — calculations, summary tables, and pivot tables
- **Tableau Desktop** — interactive dashboard and data visualization

## Business Questions

1. How did ticket sales change over time in the available dataset?
2. How do fare values and ticket volumes differ across cabin classes?
3. How does the average fare vary by cabin class?
4. How do recorded payment amounts compare with ticket values?
5. How do payment differences vary across promotional categories?

## Key Findings

- **Monthly sales:** March 2024 had the highest monthly ticket sales value among the months available in the dataset.
- **Cabin classes:** Economy had the highest total fare value, while First Class had the highest average fare.
- **Fare distribution:** The average fare was 348.13, compared with a median of 184.80, suggesting that higher fares influenced the average.
- **Payment reconciliation:** The total ticket value was 348,125.00, compared with recorded payments of 342,225.61, a difference of 5,899.39.
- **Promotions:** Payment differences varied across promotional categories. The results highlight the importance of checking ticket values against recorded payment amounts.

## Dashboard

The Tableau dashboard includes:
- Monthly ticket sales value over time
- Fare value and ticket volume by cabin class
- Average fare by cabin class
- Payment differences by promotion
- KPI summaries for ticket sales, payments, and payment differences

Interactive selections allow users to explore supported views of the data.

## Data Quality & Limitations

The project uses a **synthetic sample dataset**, not real airline commercial data. The findings therefore describe patterns within this sample and should not be interpreted as actual airline or market performance.

The dataset contains gaps in monthly coverage. Changes between periods may reflect differences in data coverage rather than genuine changes in demand.

Payment differences identify discrepancies between ticket values and recorded payment amounts. They do not, by themselves, establish the cause of those differences.

## Project Structure

- `sql/` — SQL queries used for analysis
- `spreadsheet/` — spreadsheet analysis and summary tables
- `tableau/` — Tableau workbook and related files
- `screenshots/` — dashboard screenshots

## Skills Demonstrated

- SQL querying with joins, aggregations, and date functions
- Data validation and reconciliation
- KPI calculation and business reporting
- Spreadsheet analysis and pivot tables
- Data visualization and interactive dashboard development
- Communicating findings and data limitations

## Data Source

Synthetic airline sample database, version 1. The dataset is distributed under the CC0-1.0 license.

This is an independent portfolio project created for learning and demonstration purposes.
