with top_paying_jobs AS (
SELECT job_id,job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact
WHERE job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL

),
jobs_skills AS (
SELECT job_title,salary_year_avg,skills
FROM top_paying_jobs

LEFT JOIN skills_job_dim USING (job_id)
LEFT JOIN skills_dim USING (skill_id)
WHERE skills IS NOT NULL)

SELECT skills,ROUND(avg(salary_year_avg),2) AS average_salary
FROM jobs_skills
GROUP BY skills

ORDER BY average_salary DESC


