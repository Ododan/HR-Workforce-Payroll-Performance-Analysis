drop table if exists hr_data ;
CREATE TABLE hr_data(
    empid INT,
    empstatusid INT,
    dept_id INT,
    salary NUMERIC,
    termd INT,
    positionid INT,
    "position" VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(20),
    dob DATE,                          
    sex VARCHAR(10),
    marital_status VARCHAR(50),
    citizendesc VARCHAR(50),
    racedesc VARCHAR(50),
    dateofhire DATE,                  
    dateoftermination DATE,            
    termreason VARCHAR(255),
    employmentstatus VARCHAR(50),
    department VARCHAR(100),
    managername VARCHAR(100),
    managerid INT,
    recruitmentsource VARCHAR(100),
    performancescore VARCHAR(50),
    engagementsurvey NUMERIC,
    empsatisfaction INT,
    specialprojectscount INT,
    lastperformancereview_date DATE,  
    dayslatelast30 INT,               
    absences INT,
    duration NUMERIC
);

select *
from hr_data;

select position, salary
from hr_data
group by position, salary
order by salary desc;

select *, 
row_number() over(order by empid) as row_numb
from hr_data;

select department,
position, 
salary,
dateofhire, 
dateoftermination, 
termreason,
employmentstatus,
duration 
from hr_data
order by salary desc


select department,
position, 
salary,
dateofhire,  
extract(year from age(dob)) as age,
employmentstatus
from hr_data
where employmentstatus = 'Active'
order by salary desc;


select department, sum(salary) as total_salary
from hr_data
group by department
order by total_salary desc;

with active_staff as
		(select department, sum(salary) as total_salary_activestaff
		from hr_data
		where employmentstatus = 'Active'
		group by department
		),
inactive_staff as
		(select department, sum(salary) as total_salary_inactivestaff
		from hr_data
		where employmentstatus != 'Active'
		group by department
		)
select
		coalesce(a.department, i.department) as department,
		coalesce(a.total_salary_activestaff, 0) as Active_salary,
		coalesce(i.total_salary_inactivestaff, 0) as inactive_salary,
		coalesce(a.total_salary_activestaff, 0) - coalesce(i.total_salary_inactivestaff, 0) as salary_difference
from  active_staff a
full outer join inactive_staff i
on a.department = i.department
order by salary_difference desc;

--or this short 

SELECT 
    department,
    SUM(salary) FILTER (WHERE employmentstatus = 'Active') AS active_salary,
    SUM(salary) FILTER (WHERE employmentstatus != 'Active') AS inactive_salary,
    COALESCE(SUM(salary) FILTER (WHERE employmentstatus = 'Active'), 0) - 
    COALESCE(SUM(salary) FILTER (WHERE employmentstatus != 'Active'), 0) AS salary_difference
FROM hr_data
GROUP BY department
ORDER BY salary_difference DESC;


with male_salary as
	(select trim(position) as position, 
	avg(salary) as male_avg_salary
	from hr_data
	where trim(sex) = 'M' and Position is not null
	group by trim(position)
	),
female_salary as
	(
	select trim(position) as position, 
	avg(salary) as female_avg_salary
	from hr_data
	where trim(sex) = 'F' and Position is not null
	group by position
	)
select coalesce(m.position, f.position) as position,
round(m.male_avg_salary, 2) as male_avg_salary,
round(f.female_avg_salary, 2) as female_avg_salary
from male_salary m
full outer join female_salary f on m.position = f.position
order by male_avg_salary desc, female_avg_salary desc;

SELECT 
    sex, 
    ROUND(AVG(salary), 2) AS average_salary,
    COUNT(*) AS total_employees
FROM hr_data
GROUP BY sex;

select trim(position) as position, count(*) as number_of_staff_per_position,
round(sum(salary)) as sal,
min(salary) as min_sal, Max(salary) as max_sal
FROM hr_data
group by trim(position)
order by trim(position);

select dept_Id, department, round(avg(salary)) as avg_sal, count(*) as employee_count
FROM hr_data
group by dept_Id, department
order by avg_sal desc;


SELECT 
    dept_id,  department,
    ROUND(AVG(salary), 2) AS average_salary,
    COUNT(*) AS employee_count
FROM hr_data
GROUP BY dept_id,  department 
ORDER BY employee_count desc


select empid, 
position, 
salary, 
row_number() over(order by salary desc) as row_numb
FROM hr_data
limit 10;

SELECT 
    marital_status,
    citizendesc,
    ROUND(AVG(salary), 2) AS average_salary,
    COUNT(*) AS total_employees
FROM hr_data
GROUP BY marital_status, citizendesc
ORDER BY average_salary DESC;

select empid, count(*) as total_employee,
sum(termd) as total_termiantion,
round(avg(termd) * 100, 2)
from hr_data
where termd = '1'
group by empid;


select dept_id,  
trim(department) as department, count(*) as total_emp,
sum(termd) as total_termination,
round(avg(termd) * 100,2) as percentage
from hr_data
group by dept_id, trim(department)
order by total_termination desc;

SELECT 
    TRIM(department) AS job_title,
    COUNT(*) AS total_employees,
    SUM(termd) AS total_terminated,
    ROUND(AVG(termd) * 100, 2) AS dept_turnover_rate_pct
FROM hr_data
GROUP BY TRIM(department)
having count(*) > 5
ORDER BY dept_turnover_rate_pct DESC;

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


select sex, count(*) as count
from hr_data
group by sex












