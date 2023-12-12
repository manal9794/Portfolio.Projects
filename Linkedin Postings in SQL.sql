select count(job_id) AS total_postings,count(job_id)/12 AS Avg_number_of_listings_per_month,
count(job_id)/52 AS Avg_number_of_listings_per_week 
from job_postings$
