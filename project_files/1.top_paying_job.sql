SELECT job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact
WHERE job_title_short='Data Analyst' AND 
salary_year_avg IS NOT NULL AND job_work_from_home='yes'
ORDER BY salary_year_avg DESC
LIMIT 10