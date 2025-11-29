USE PoolManagement;

DROP TABLE IF EXISTS dim_employee;

CREATE TABLE dim_employee (
    employee_sk  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    employee_id  INT UNSIGNED NOT NULL,
    user_id      BIGINT UNSIGNED,
    first_name   VARCHAR(100),
    last_name    VARCHAR(100),
    full_name    VARCHAR(201),
    PRIMARY KEY (employee_sk),
    UNIQUE KEY uk_employee_id (employee_id),
    UNIQUE KEY uk_user_id (user_id)
);
INSERT INTO dim_employee (employee_id, user_id, first_name, last_name, full_name)
SELECT DISTINCT
    `Employee ID`,
    `User ID`,
    `First Name`,
    `Last Name`,
    CONCAT(`First Name`, ' ', `Last Name`) AS full_name
FROM pavan_timesheet
WHERE `Employee ID` IS NOT NULL;



USE PoolManagement;

DROP TABLE IF EXISTS dim_job_site;

CREATE TABLE dim_job_site (
    job_site_sk   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    job_site_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (job_site_sk),
    UNIQUE KEY uk_job_site (job_site_name)
);
INSERT INTO dim_job_site (job_site_name)
SELECT DISTINCT `Job Site`
FROM pavan_timesheet
WHERE `Job Site` IS NOT NULL AND `Job Site` <> '';


DROP TABLE IF EXISTS dim_position;

CREATE TABLE dim_position (
    position_sk   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    position_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (position_sk),
    UNIQUE KEY uk_position (position_name)
);
INSERT INTO dim_position (position_name)
SELECT DISTINCT `Position`
FROM pavan_timesheet
WHERE `Position` IS NOT NULL AND `Position` <> '';


DROP TABLE IF EXISTS dim_schedule;

CREATE TABLE dim_schedule (
    schedule_sk   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    schedule_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (schedule_sk),
    UNIQUE KEY uk_schedule (schedule_name)
);
INSERT INTO dim_schedule (schedule_name)
SELECT DISTINCT `Schedule`
FROM raw_timesheets
WHERE `Schedule` IS NOT NULL AND `Schedule` <> '';


