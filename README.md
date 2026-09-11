# HR-Workforce-Payroll-Performance-Analysis

### Project Overview

This data analysis project provides an end-to-end evaluation of organizational workforce metrics, turnover rates, department-level compensation structures, and payroll distribution. Leveraging PostgreSQL for data extraction and Power BI for interactive visualization, the project delivers actionable business intelligence around workforce retention, salary disparity across employment statuses, and high-value compensation tiers.

### Data Sources

• HR Workforce & Payroll Dataset: Primary records containing employee attributes, departmental divisions, employment status (Active, Terminated, Voluntary Termination), position titles, and individual salary structures (`hr_data`).

### Data Cleaning & Preparation

• Data Inspection & Standardisation: Standardized job titles, departmental classifications, and employment status metrics.

• Missing Value Handling: Replaced missing values and null entries in salary metrics using targeted imputation logic.

• Formatting: Converted numeric fields into standard currency formats and structured status flags for dynamic filtering.
Exploratory Data Analysis (EDA)
EDA involved writing dynamic PostgreSQL queries to uncover underlying workforce trends:

• What is the breakdown of active vs. inactive payroll expenditures across departments?

• What is the net turnover rate across core operational units?

• Which roles represent the top 10 highest-paid positions within the organization?

### Data Analysis & Highlights
An interesting query feature developed in PostgreSQL involves calculating 

````Sql
SELECT 
    CASE 
        WHEN salary < 50000 THEN 'Under $50k'
        WHEN salary BETWEEN 50000 AND 80000 THEN '$50k - $80k'
        WHEN salary BETWEEN 80001 AND 120000 THEN '$80k - $120k'
        ELSE 'Over $120k'
    END AS salary_bracket,
    COUNT(*) AS total_employees,
    ROUND(AVG(absences), 2) AS avg_absences
FROM hr_data
GROUP BY salary_bracket
ORDER BY avg_absences DESC;
````
• How are employees distributed across defined salary brackets?
````Sql
SELECT 
    department,
    SUM(salary) FILTER (WHERE employmentstatus = 'Active') AS active_salary,
    SUM(salary) FILTER (WHERE employmentstatus != 'Active') AS inactive_salary,
    COALESCE(SUM(salary) FILTER (WHERE employmentstatus = 'Active'), 0) - 
    COALESCE(SUM(salary) FILTER (WHERE employmentstatus != 'Active'), 0) AS salary_difference
FROM hr_data
GROUP BY department
ORDER BY salary_difference DESC;
````
 • What is the total salary for active and inactive staff, and net difference between them?

 ### Interactive Visualization & Dashboard
The dynamic Power BI dashboard provides executive visibility into overall headcount, active versus inactive payroll distribution, departmental retention rates, top salary tiers, and employee distribution across salary ranges.

### HR Workforce & Payroll Dashbaord Snapshot:


### Key Metrics & Visual Features
 KPI Summary Cards: Total Headcount (311), Active Employees (207), and Overall Turnover Rate (0.05).
 Active vs. Inactive Payroll Breakdown: Departmental bar charts contrasting active salary vs. total historical inactive costs.
 Compensation Distribution: Donut chart highlighting average salary by employment status ($69.02K overall mean).
 Departmental Expenditure & Retention: Column charts displaying total department costs alongside turnover distributions.
 Top Positions & Salary Ranges: Line graph isolating the top 10 highest-paying roles alongside a salary range histogram ($50k–$80k tier being the most populated).

