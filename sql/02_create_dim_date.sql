USE PoolManagement;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_sk        INT NOT NULL,
    full_date      DATE NOT NULL,
    year           INT,
    quarter        INT,
    month          INT,
    month_name     VARCHAR(20),
    day            INT,
    day_of_week    INT,
    day_name       VARCHAR(20),
    week_of_year   INT,
    is_weekend     TINYINT(1),
    PRIMARY KEY (date_sk)
);
INSERT INTO dim_date (
    date_sk, full_date, year, quarter, month, month_name,
    day, day_of_week, day_name, week_of_year, is_weekend
)
SELECT
    CAST(DATE_FORMAT(d, "%Y%m%d") AS UNSIGNED) AS date_sk,
    d AS full_date,
    YEAR(d) AS year,
    QUARTER(d) AS quarter,
    MONTH(d) AS month,
    MONTHNAME(d) AS month_name,
    DAY(d) AS day,
    DAYOFWEEK(d) AS day_of_week,
    DAYNAME(d) AS day_name,
    WEEK(d, 3) AS week_of_year,
    CASE WHEN DAYOFWEEK(d) IN (1,7) THEN 1 ELSE 0 END AS is_weekend
FROM (
    SELECT DATE('2024-01-01') + INTERVAL n DAY AS d
    FROM (
        SELECT a.N + b.N * 10 + c.N * 100 AS n
        FROM 
            (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
                    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
            (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
                    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
            (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
                    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
    ) numbers
    WHERE DATE('2024-01-01') + INTERVAL n DAY <= DATE('2026-12-31')
) AS dates;