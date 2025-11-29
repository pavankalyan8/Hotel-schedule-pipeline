#Employee monthly summary view
USE PoolManagement;

DROP VIEW IF EXISTS vw_employee_monthly_summary;

CREATE VIEW vw_employee_monthly_summary AS
SELECT
    de.employee_id,
    de.full_name,
    dd.year,
    dd.month,
    dd.month_name,

    SUM(f.regular_hours)           AS total_regular_hours,
    SUM(f.ot_hours)                AS total_ot_hours,
    SUM(f.double_ot_hours)         AS total_double_ot_hours,
    SUM(f.unpaid_breaks)           AS total_unpaid_breaks,
    SUM(f.paid_total)              AS total_paid_amount,

    COUNT(*)                       AS shift_count
FROM fact_timesheet f
JOIN dim_employee de   ON de.employee_sk = f.employee_sk
JOIN dim_date dd       ON dd.date_sk     = f.date_sk
GROUP BY
    de.employee_id, de.full_name,
    dd.year, dd.month, dd.month_name;


-- Pavan's monthly summary
SELECT *
FROM vw_employee_monthly_summary
WHERE full_name = 'Pavan Kalyan'
ORDER BY year, month;


DROP VIEW IF EXISTS vw_job_site_monthly_cost;

CREATE VIEW vw_job_site_monthly_cost AS
SELECT
    djs.job_site_name,
    dd.year,
    dd.month,
    dd.month_name,

    SUM(f.regular_hours + f.ot_hours + f.double_ot_hours) AS total_hours,
    SUM(f.paid_total)                                     AS total_paid_amount,
    COUNT(*)                                              AS shift_count
FROM fact_timesheet f
JOIN dim_job_site djs ON djs.job_site_sk = f.job_site_sk
JOIN dim_date dd      ON dd.date_sk      = f.date_sk
GROUP BY
    djs.job_site_name,
    dd.year, dd.month, dd.month_name;

-- Cost per hotel per month
SELECT *
FROM vw_job_site_monthly_cost
ORDER BY year, month, job_site_name;
