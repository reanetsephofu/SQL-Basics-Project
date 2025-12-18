/*
question 1: what are the top-paying data analyst job?
- identify the top 10 highest-paying data analyst roles that are available remotely.
- focuses on job postings with specified salaries (remove nulls).
- why? highlight the top-paying opportunities dor data analysts, offering insights into employment.
*/

--storing query into CTE for reuse later on
with top_paying_jobs as (
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
)

/*
question 2: what skills are required for the top-paying data analyst jobs?
- use the top 10 highest-paying data analyst jobs from first query.
- add the specific skills required for these roles.
- why? it provides a detailed look at which high-paying jobs demand certain skills,
	helping job seekers understand which skills to develop that align with top salaries.
*/

--joining CTE with skills_job_dim & skills_dim tables to see skills associated with
--top-paying jobs
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

/*
question 3: what are the most in-demand skills for data analytics?
- join job postings to inner join table similary to query 2.
- identify the top 5 in-demand skills for a data analyst.
- focus on all job postings
- why? retrieves the top 5 skills with the highest demand in the job market,
	providing insights into most valuable skills for job seekers.
*/

--query checks for most in-demand skills for remote data analyst positions
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

/*
question 4: what are the top skills based on salary?
- look at the average salary associated with each skill for data analyst positions.
- focuses on roles with specified salaries, regardless of location.
- why? reveals how different skills impact salary levels for data analysts and
	helps identify the most financially rewarding skills to acquire/improve.
*/

select top(25)
	try_cast(sd.skills as varchar) as skills,
	avg(cast(jpf.salary_year_avg as decimal)) as avg_salary
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
	jpf.salary_year_avg is not null and
	jpf.job_work_from_home = 1
group by
	try_cast(sd.skills as varchar)
order by
	avg_salary desc

/*
question 5: what are the most optimal skills to learn? (high demand AND highest paying skill).
- identify skills in high demand and associated with high average salaries for data analyst roles.
- concentrates on remote positions with specified salaries.
- why? target skills that offer job security and financial benefits, offering strategic insights
	for career development in data analysis.
*/

--stored question 3 query into CTE for later use
with skills_demand as (
	select
		sd.skill_id,
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
		jpf.salary_year_avg is not null and
		jpf.job_work_from_home = 1
	group by
		sd.skill_id,
		try_cast(sd.skills as varchar)
),

--stored question 4 query into CTE for later use
average_salary as (
	select
		sjd.skill_id,
		avg(cast(jpf.salary_year_avg as decimal)) as avg_salary
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
		jpf.salary_year_avg is not null and
		jpf.job_work_from_home = 1
	group by
		sjd.skill_id
)

--joining skills_demand and average_salary CTEs to find top 25 optimal skills
select top(25)
	skills_demand.skill_id,
	skills_demand.skills,
	demand_count,
	avg_salary
from
	skills_demand
inner join
	average_salary on
		average_salary.skill_id = skills_demand.skill_id
where
	demand_count > 10
order by
	avg_salary desc,
	demand_count desc

--instead of using CTEs, this will give same result but with less lines of code	
select top(25)
	sd.skill_id,
	try_cast(sd.skills as varchar),
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