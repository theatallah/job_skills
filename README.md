# introduction

This is a project which analyses data analyst jobs ,skills needed for this job and which are the highest paid skills

The SQL queries are [project_files folder](/project_files/)

# Background

This was based on Luke Barousse course , where a csv file for different job postings and related skills was given
and these are the questions that were answered 

### questions/queries:
1. What are the top paying jobs? answer is here [top_paying_job](/project_files/1.top_paying_job.sql/)

2. What skills required for top paying skills? answer is here [top_paying_skills](/project_files/2.%20top_paying_job_skills.sql)

3. What are the most demanded skills? answer is here [most_demanded_skills](/project_files/3.%20most_indemand_skills.sql)

4. What are the most paying skills? answer is here [most_paying_skills](/project_files/4.%20top_paying_skills.sql)

5. What are the optimal skills "most in demand and most paid for" ? [optimal_skills](/project_files/5.optimal_skills.sql)

# Tools Used

Mainly I used here:

### **1. Postgres sql:**

This is a database management system which is a free source, you can download it for free

### **2. Visual Studio:**

This is an IDE, where the actual queries were written

### **3. Excel for visual:**

Basically i extracted some of queries into csv and then created visuals in excel

### **4. Git and Git Hub**

For versioning and for uploading /sharing the workable files

# The Analysis

## Question 1: What are the top paying jobs?

here its a basic select statement with filtering for data analyst job and people who are working at home, and restricted to top 10 paying jobs

```sql
SELECT job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact
WHERE job_title_short='Data Analyst' AND 
salary_year_avg IS NOT NULL AND job_work_from_home='yes'
ORDER BY salary_year_avg DESC
LIMIT 10 

```
## Question 2: What skills required for top paying data analyst jobs?

Here basically i created a common table expression (CTE) from my previous query in question 1, then i joined it with skills and job reference tables, and finally i extracted only distinct skills required for top paying jobs

``` sql
with top_paying_jobs AS (
SELECT job_id,job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact

WHERE job_title_short='Data Analyst' AND 
salary_year_avg IS NOT NULL AND job_work_from_home='yes'

ORDER BY salary_year_avg DESC
LIMIT 10),
distinct_skills as (
SELECT job_title,salary_year_avg,skills
FROM top_paying_jobs

LEFT JOIN skills_job_dim USING (job_id)
LEFT JOIN skills_dim USING (skill_id)
WHERE skills IS NOT NULL)

select distinct(skills)
FROM distinct_skills

```

## Question 3: Most in demand skills for data analyst?

Here I used CTEs from 2 previous queries and found the most used skills for data analyst role, so basically i used aggregate functions and groupby along with joins

``` sql
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
```
| skill   | skill_appeared_i... |
|---------|---------------------|
| sql     | 92628               |
| excel   | 67031               |
| python  | 57326               |
| tableau | 46554               |
| power bi| 39468               |

## Question 4: Average pay for skills that are used for data analysis

Here i used previous queries, but worked in other way, where i calculated average salary paid per skill

``` sql
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
```

## Question 5: Optimal Skills demand vs pay

Here we want to find most skill in demand and with highest average pay

So basically ordered skills from highest demand and see what is the average pay

``` sql
with top_paying_jobs AS (
SELECT job_id,job_title,salary_year_avg,job_work_from_home
FROM job_postings_fact
WHERE job_title_short='Data Analyst'
AND salary_year_avg IS NOT NULL


),
jobs_skills AS (
SELECT job_title,salary_year_avg,skills
FROM top_paying_jobs

LEFT JOIN skills_job_dim USING (job_id)
LEFT JOIN skills_dim USING (skill_id)
),

skill_demand AS (

SELECT skills AS skill,count(skills) AS skill_demand
FROM jobs_skills
GROUP BY skills
ORDER BY skill_demand DESC),

average_salary AS (
    SELECT skills,ROUND(avg(salary_year_avg),2) AS average_salary
FROM jobs_skills
GROUP BY skills
)

SELECT skills,skill_demand,average_salary
from skill_demand
left join average_salary on skill_demand.skill=average_salary.skills
order by skill_demand desc,average_salary desc

```

# Conclusions

So the conclusion that for data analyst most demanded skills are SQL, Excel and python , then comes visualization tools like tableau/power bi

For Top Payment job titles for data analyst and remote work were:
Data Analyst and director of analytics












