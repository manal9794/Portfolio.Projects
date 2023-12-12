/** Total number of postings**/
select count(job_id) AS total_postings,count(job_id)/12 AS Avg_number_of_listings_per_month,
count(job_id)/52 AS Avg_number_of_listings_per_week 
from job_postings$
  
 /**Top website domains  with the most job listings**/
select top 10 posting_domain AS top_domains , COUNT(posting_domain) AS Number_of_listings
from job_postings$
group by posting_domain
order by posting_domain desc

 /** comparing the number of job posts per level**/
select formatted_experience_level, count (formatted_experience_level) AS Number_of_postings
from job_postings$
where formatted_experience_level is not null
group by formatted_experience_level
order by count (formatted_experience_level) desc 

 /** comparing the number of job listings by type of work **/
select work_type, count (work_type) AS 'Number_of_postings'
from job_postings$
where work_type is not null
group by work_type
order by count (work_type) desc 

/** number of listings per state ***/

SELECT
   job_id, 
    CASE
        WHEN location LIKE '%, [A-Z][A-Z]' THEN SUBSTRING(location, CHARINDEX(',', location) + 2, LEN(location))
        -- Add more cases as needed
        ELSE 'Unknown'
    END AS TheState
FROM
    job_postings$

  /**** Avg annual salary per level ****/

SELECT
    J.formatted_experience_level,
    AVG((S.min_salary + S.max_salary) / 2) AS avg_salary
FROM
    job_postings$ J
JOIN
    salaries$ S ON J.job_id = S.job_id
where  S.pay_period = 'Yearly' and J.formatted_experience_level is not null
GROUP BY
    J.formatted_experience_level

 /** Avg salary by industry and level **/
select N.industry_id, N.industry_name, AVG((P.min_salary + P.max_salary) / 2) AS avg_salary , P.formatted_experience_level, P.formatted_work_type
from job_postings$ P
  join job_industries$ I
  on P.job_id = I.job_id
  join industries$ N
  on N.industry_id = I.industry_id
Where P.formatted_experience_level is not null
group by N.industry_name,
P.formatted_experience_level,
    P.formatted_work_type;

 /** Which industries hired the most **/
  SELECT
    N.industry_id,
    N.industry_name,
    COUNT(P.job_id) AS job_count
FROM
    job_postings$ P
JOIN
    job_industries$ I ON P.job_id = I.job_id
JOIN
    industries$ N ON N.industry_id = I.industry_id
	where N.industry_name is not null
GROUP BY
    N.industry_id,
    N.industry_name;

/** What are the most common benefits published  **/
 SELECT   COUNT(type) AS 'number of times listed', type
from benefits$
where inferred = 1
group by type 

 /** Which departments hired the most**/
select count (J.job_id) AS number_of_postings, J.skill_abr, S.skill_name
from job_skills$ J
join skills$ S
on J.skill_abr = S.skill_abr
group by 
J.skill_abr,
S.skill_name

   /**Average salaries per state and experience level  **/

SELECT
    COUNT(job_id) AS job_count,
    AVG((min_salary + max_salary) / 2) AS avg_salary,
    formatted_experience_level,
    TheState
FROM
    (
        SELECT
            job_id,
            formatted_experience_level,
            (SELECT
                CASE
                    WHEN location LIKE '%, [A-Z][A-Z]' THEN SUBSTRING(location, CHARINDEX(',', location) + 2, LEN(location))
                    ELSE 'Unknown'
                END
            ) AS TheState,
            min_salary,
            max_salary
        FROM
            job_postings$
        WHERE
            formatted_experience_level IS NOT NULL
            AND formatted_work_type = 'Full-time'
    ) AS Subquery
GROUP BY
    formatted_experience_level,
    TheState;

 /**companies that hired the most **/
select  C.name AS company, count (P.job_id) AS number_of_job_posts
from companies$ C
join job_postings$ P
on C.company_id = P.company_id
group by C.name
order by count (P.job_id) desc

