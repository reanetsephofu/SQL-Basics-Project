# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores the top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was created from the desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal occupations.

Data is derived from my [Luke Barousse SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### Questions I answered through my SQL queries:
1. Top-paying data analyst jobs?
2. Skills required for said jobs?
3. Skills most in-demand for data analyst?
4. Skills associated with higher salaries?
5. Most optimal skills to learn?

# Tools I Used
- **SQL**: The backbone of my analysis, allowing me to query the database and reveal critical insights.
- **SQL Server Management Studio**: Chosen database management system, ideal for handling job postings data.
- **GitHub**: Essential for sharing SQL scripts and analysis.
- **Google Colab**: Visualising the data, and depicting my findings.

# The Analysis
Each query in this project is aimed at investigating specific aspects of the data analyst job market.
Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, data analyst positions were filtered by average yearly salary  and location, focussing  on remote jobs. Below query highlights top-paying opportunities in field.

```sql
select top(10)
		jpf.job_id,
		jpf.job_title,
		cd.name as 'company_name',
		jpf.salary_year_avg
	from
		job_postings_fact jpf
	left join
		company_dim cd on
			cd.company_id = jpf.company_id
	where
		job_title_short = 'Data Analyst' and
		job_location like 'Anywhere' and
		salary_year_avg is not null
	order by
		try_cast(salary_year_avg as decimal) desc
```

Breakdown of top data analyst jobs:
- **Wide Salary Range:** Top 10 roles span from $184,000 to $650,000, indicating significant salary potential.

- **Diverse Employers:** Companies like Meta and AT&T are among those offering high salaries, showing broad interest across several industries.

- **Job Title Variety:** High diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specialisations.

# What I Learned
# Conclusion
