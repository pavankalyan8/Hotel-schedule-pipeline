DROP TABLE IF EXISTS fact_timesheet;

CREATE TABLE fact_timesheet (
    fact_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    
    employee_sk INT UNSIGNED,
    job_site_sk INT UNSIGNED,
    position_sk INT UNSIGNED,
    schedule_sk INT UNSIGNED,
    date_sk INT UNSIGNED,

    regular_hours DECIMAL(10,4),
    unpaid_breaks DECIMAL(10,4),
    hourly_rate DECIMAL(10,4),
    ot_hours DECIMAL(10,4),
    double_ot_hours DECIMAL(10,4),
    paid_total DECIMAL(10,4),

    start_time DATETIME,
    end_time DATETIME,

    PRIMARY KEY (fact_id),
    INDEX idx_emp (employee_sk),
    INDEX idx_job (job_site_sk),
    INDEX idx_pos (position_sk),
    INDEX idx_sched (schedule_sk),
    INDEX idx_date (date_sk)
);


INSERT INTO fact_timesheet (
    employee_sk, job_site_sk, position_sk, schedule_sk, date_sk,
    regular_hours, unpaid_breaks, hourly_rate, ot_hours, double_ot_hours, paid_total,
    start_time, end_time
)
SELECT 
    de.employee_sk,
    djs.job_site_sk,
    dp.position_sk,
    ds.schedule_sk,
    dd.date_sk,

    rt.`Regular`,
    rt.`Unpaid Breaks`,
    rt.`Hourly Rate`,
    rt.`OT`,
    rt.`Double OT`,

    -- 🔥 FIX 1: Convert German decimals to MySQL decimals
    CAST(REPLACE(rt.`Paid Total`, ',', '.') AS DECIMAL(10,4)) AS paid_total_clean,

    rt.`Start Time`,
    rt.`End Time`

FROM pavan_timesheet rt
LEFT JOIN dim_employee de
    ON de.employee_id = rt.`Employee ID`
LEFT JOIN dim_job_site djs
    ON djs.job_site_name = rt.`Job Site`
LEFT JOIN dim_position dp
    ON dp.position_name = rt.`Position`
LEFT JOIN dim_schedule ds
    ON ds.schedule_name = rt.`Schedule`
LEFT JOIN dim_date dd
    ON dd.full_date = DATE(rt.`Date`);
