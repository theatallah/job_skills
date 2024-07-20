with top_paying_jobs AS (
SELECT job_id,job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact
WHERE job_title_short='Data Analyst'


),
jobs_skills AS (
SELECT job_title,salary_year_avg,skills
FROM top_paying_jobs

LEFT JOIN skills_job_dim USING (job_id)
LEFT JOIN skills_dim USING (skill_id)
WHERE skills IS NOT NULL)

SELECT skills AS skill,count(skills) AS skill_appeared_in_job
FROM jobs_skills
GROUP BY skills
ORDER BY skill_appeared_in_job DESC
LIMIT 5

