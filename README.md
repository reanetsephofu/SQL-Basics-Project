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

<img src="/images/1_toptenpayingjobs.png" style="width: 60%; height: auto;">

### 2. In-Demand Skills for Top Paying Jobs
To understand what skills are required for highest-earning jobs, job postings table was joined with skills table, providing insights into what employers value most for high-compensation roles.

```sql
select
	tpj.*,
	sd.*
from
	top_paying_jobs tpj
inner join
	skills_job_dim sjd on
		sjd.job_id = tpj.job_id
inner join
	skills_dim sd on
		sd.skill_id = sjd.skill_id
order by
	try_cast(tpj.salary_year_avg as decimal) desc
```

Breakdown of most in-demand skills for top ten hgihest earning data jobs:
- **SQL** is mentioned a whopping 8 times.

- **Python** follows closely with being mentioned 7 times.

- **Tableau** is also highly sought after, with a count of 6. Other skills such as R, Snowflake, Pandas, and Excel show varying degrees of demand.

<img src="/images/2_skills.png" style="width: 60%; height: auto;">

### 3. In-Demand Skills for Data Analysts
Below query was essential for identifying skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
select top(5)
	try_cast(sd.skills as varchar) as skills,
	count(sjd.skill_id) as demand_count
from
	job_postings_fact jpf
inner join
	skills_job_dim sjd on
		sjd.job_id = jpf.job_id
inner join
	skills_dim sd on
		sd.skill_id = sjd.skill_id
where
	jpf.job_title_short = 'Data Analyst' and
	jpf.job_work_from_home = 1
group by
	try_cast(sd.skills as varchar)
order by
	count(sjd.skill_id) desc
```

Breakdown of data analyst requirements:
- **SQL** and **Excel** are fundamental, emphasising the need for strong foundational skills in data processing and spreadsheet manipulation.

- **Programming** and **Visualisation Tools** such as Python, Tableau, and Power BI are essential, pointing towards the increasing importance for technical skills in data storytelling and decision support.

<img src="/images/3_indemandskills.png" style="width: 60%; height: auto;">

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the most lucrative.

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

Breakdown of top paying skills for data analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modelling capabilities.

- **Software Development & Deployment Proficiency:** Knowledge in development tools (GitLab, Kubernetes, Airflow) indicates lucrative crossover between data analysis and engineering, with premium on skills that facilitate automation and efficient data pipeline management.

- **Cloud Computing Expertise:** Familiarality with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores growing importance of cloud-based analytics environments, suggesting that cloud proficiency boosts earning potential in data analytics.

<img src="/images/4_skillbasedsalary.png" style="width: auto; height: auto;">

### 5. Most Optimal Skills to Learn
With insights from demand and salary data, below query is aimed at highlighting skills that are both in demand, and have high earning potential, offering strategic focus for skill development.

```sql
select top(25)
	sd.skill_id,
	try_cast(sd.skills as varchar) as skill,
	count(sjd.job_id) as demand_count,
	avg(cast(jpf.salary_year_avg as decimal)) as avg_salary
from job_postings_fact jpf
inner join
	skills_job_dim sjd on
		jpf.job_id = sjd.job_id
inner join
	skills_dim sd on
		sd.skill_id = sjd.skill_id
where
	job_title_short = 'Data Analyst' and
	salary_year_avg is not null and
	job_work_from_home = 1
group by
	sd.skill_id,
	try_cast(sd.skills as varchar)
having
	count(sjd.job_id) > 10
order by
	avg_salary desc,
	demand_count desc
```

Breakdown of most optimal skills for data analysts:
- **High-Demand Programming Languages:** Python & R stand out for their high demand, accounting for 236 and 148 mentions, respectively. In spite of demand, average salaries are about USD$101,397 for Python, USD$100,499 for R, indicating that proficiency in both skills is simultaneously highly valued but widely available.

- **Cloud Tools and Technologies:** Skills in specialised technologies such as Snowflake, Azure, AWS, BigQuery show significant demand with relatively high average earnings, a show toward growing importance of cloud platforms and big data technologies.

- **Business Intelligence & Visualisation Tools:** Tableau & Looker, with demand counts of 230 and 49, respectively, and average salaries at about USD$99,288 and USD$103,795, highlight critical role of data visualisation and business intelligence in deriving actionable insights.

- **Database Technologies:** Demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from USD$97,786 to USD$104,534, reflects enduring need for data storage, retrieval, and management expertise.

<img src="/images/5_optimalskills.png" style="width: auto; height: auto;">

# What I Learned

Throughout my journey, I've refined my SQL toolkit with various skills:

- **Complex Query Crafting:** Mastered advanced SQL, merging tables and using ```WITH``` clauses for temp table maneuvers.
-  **Data Aggregation:** Became comfortable with ```GROUP BY``` and turned aggregate functions like ```COUNT()``` and ```AVG()``` into necessaties.
- **Analytical Skills:** Improved my real-world puzzle-solving skills, turning questions into actionable, insightful queries.

# Technical Details
- **SQL**: The backbone of my analysis, allowing me to query the database and reveal critical insights.
- **Python**: Visualising the data, and depicting my findings.
- **SQL Server Management Studio**: Chosen database management system, ideal for handling job postings data.
- **GitHub**: Essential for sharing SQL scripts and analysis.
