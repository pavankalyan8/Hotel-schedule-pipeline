![MySQL](https://img.shields.io/badge/Database-MySQL-blue?logo=mysql)
![Python](https://img.shields.io-badge/Language-Python-yellow?logo=python)
![ETL](https://img.shields.io/badge/Pipeline-ETL-green)
![Model-Star Schema](https://img.shields.io/badge/Data%20Model-Star%20Schema-orange)

# Pool Management Timesheet Data Warehouse

## Overview

This project builds a small data warehouse for hotel/pool staff timesheets:

- Source: Excel/CSV export from "When I Work" (timesheet tool)
- Database: MySQL
- Schema: star schema with dimensions + fact table

## Schema

**Dimensions:**

- `dim_employee` – employee surrogate key, employee_id, user_id, full_name
- `dim_job_site` – hotel / property names
- `dim_position` – job roles (Night Auditor, Front Desk, etc.)
- `dim_schedule` – shift type (Morning, Evening, Night)
- `dim_date` – calendar dimension (date_sk, year, month, day, weekday, etc.)

**Fact:**

- `fact_timesheet` – one row per timesheet entry:
  - FK: employee_sk, job_site_sk, position_sk, schedule_sk, date_sk
  - Measures: regular_hours, ot_hours, double_ot_hours, unpaid_breaks, paid_total, start_time, end_time

## Files

- `sql/01_create_dimensions.sql` – creates dimension tables
- `sql/02_create_dim_date.sql` – populates `dim_date` via generated dates
- `sql/03_create_fact_timesheet.sql` – creates and fills `fact_timesheet`
- `sql/04_create_views.sql` – analytics views (`vw_employee_monthly_summary`, etc.)
- `src/dump.py` – example Python ETL to load raw Excel into MySQL (local only)

## How to run

1. Create database:

   ```sql
   CREATE DATABASE PoolManagement;
   USE PoolManagement;
Run scripts in order:

01_create_dimensions.sql
02_create_dim_date.sql
03_create_fact_timesheet.sql
04_create_views.sql

## Project Structure

```text
hotel-schedule-pipeline/
├── sql/
│   ├── 01_create_dimensions.sql
│   ├── 02_create_dim_date.sql
│   ├── 03_create_fact_timesheet.sql
│   └── 04_create_views.sql
├── src/
│   └── dump.py
├── notebooks/
│   └── (optional) validation / exploration notebook
└── README.md




## Tech Stack

- **MySQL 8** – star-schema warehouse
- **Python (pandas, mysql-connector)** – ETL from Excel/CSV → MySQL
- **SQL** – dimensional modeling, fact table, analytical views
- **Jupyter Notebook** – data validation / exploration

## Example Analytics

The warehouse supports questions like:

- How many hours and how much salary per employee per month?
- What is the monthly labour cost per hotel/job site?
- Which schedules (e.g., Night) incur most overtime?
- Which employees accumulate the highest OT hours across the year?
