/******  1.  the categories with the most products .**/
SELECT ([primary_category]) , count (product_id) AS product_count      
  FROM [Sephora].[dbo].[product_info$]
  Group by  [primary_category]
  Order by count (product_id) desc
  
/******  2.  the  sub- categories with the most products .**/
SELECT  [secondary_category] , count (product_id) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by  [secondary_category]
 having [secondary_category] is not null 
  Order by count (product_id) desc

 /****** 3.  the brands with the most products .**/
 SELECT [brand_name] , count ([brand_id]) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by [brand_name]
 having [brand_name] is not null 
  Order by count ([brand_id]) desc

  /****** 4.  the top 5 brands with the most hair products .**/
  SELECT  top 5 [brand_name] ,   ([primary_category]), count ([brand_id]) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by [brand_name] ,  ([primary_category])
 having [brand_name] is not null AND  ([primary_category]) = 'Hair'
  Order by count ([brand_id]) desc

/****** 5.  the top 5 brands with the most Makeup products .**/
  SELECT  top 5 [brand_name] ,   ([primary_category]), count ([brand_id]) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by [brand_name] ,  ([primary_category])
 having [brand_name] is not null AND  ([primary_category]) = 'Makeup'
  Order by count ([brand_id]) desc

 /****** 6.  the top 5 brands with the most Skincare products .**/
 SELECT  top 5 [brand_name] ,   ([primary_category]), count ([brand_id]) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by [brand_name] ,  ([primary_category])
 having [brand_name] is not null AND  ([primary_category]) = 'Skincare'
  Order by count ([brand_id]) desc
 

 /****** 7.  Top 5 brands with the most  Fragrance products .**/
 SELECT  top 5 [brand_name] ,   ([primary_category]), count ([brand_id]) AS product_count   
  FROM [Sephora].[dbo].[product_info$]
  Group by [brand_name] ,  ([primary_category])
 having [brand_name] is not null AND  ([primary_category]) = 'Fragrance'
  Order by count ([brand_id]) desc

   /****** 8.  The average price for sub-categories  .**/
 
SELECT [secondary_category],    round (AVG ([price_usd]) ,2) AS Average_pricess
 FROM [Sephora].[dbo].[product_info$]
group by [secondary_category]
having [secondary_category] is not null
order by  round (AVG ([price_usd]) ,2) desc

/******  9.  The most reviews products with its rating **/
SELECT top 10  [product_name], brand_name, primary_category, secondary_category,  [reviews] , rating
  FROM [Sephora].[dbo].[product_info$]
order by [reviews] desc

/******  10.  The avg number of reviews by sub-category **/
SELECT   secondary_category,    round (avg (reviews),-1) AS 'Avg number of reviews'
  FROM [Sephora].[dbo].[product_info$]
  group by secondary_category
  having secondary_category is not null 
order by  avg ([reviews]) desc

/******  11. the top 10 most reviewed products ******/
select  top 10  brand_name,[secondary_category], product_name , reviews
from product_info$
order by reviews desc

/******  12. highest-rated products******/
select    brand_name,[secondary_category], product_name , rating
from product_info$
where rating = 5
order by rating desc






/****** 13. Best products for dry skin Type ******/
select  distinct( product_info$.product_id), product_info$.secondary_category, product_info$.product_name ,
product_info$.rating , ['reviews_1250-end$'].skin_type
from product_info$
inner join ['reviews_1250-end$']
on product_info$.product_id = ['reviews_1250-end$'].product_id
where  ['reviews_1250-end$'].skin_type = 'Dry' AND product_info$.rating =5 




****** 14. Best products for oily skin Type ******/
select  distinct( product_info$.product_id), product_info$.secondary_category, product_info$.product_name ,
product_info$.rating , ['reviews_1250-end$'].skin_type
from product_info$
inner join ['reviews_1250-end$']
on product_info$.product_id = ['reviews_1250-end$'].product_id
where  ['reviews_1250-end$'].skin_type = 'Oily' AND product_info$.rating =5 

/******15. Best products for combination skin Type ******/
select  distinct( product_info$.product_id), product_info$.secondary_category, product_info$.product_name ,
product_info$.rating , ['reviews_1250-end$'].skin_type
from product_info$
inner join ['reviews_1250-end$']
on product_info$.product_id = ['reviews_1250-end$'].product_id
where  ['reviews_1250-end$'].skin_type = 'combination' AND product_info$.rating =5 
 

 
/******16. Best products for normal skin Type ******/
select  distinct( product_info$.product_id), product_info$.secondary_category, product_info$.product_name ,
product_info$.rating , ['reviews_1250-end$'].skin_type
from product_info$
inner join ['reviews_1250-end$']
on product_info$.product_id = ['reviews_1250-end$'].product_id
where  ['reviews_1250-end$'].skin_type = 'normal' AND product_info$.rating =5 




/*** 17. brand performance analysis  **/
select brand_name, reviews,   round (avg (rating),2) AS 'avg_rating'
from product_info$
group by brand_name, reviews
having reviews is not null and avg (rating) is not null



/***18. Avg rating for products based on their price range  **/

SELECT 
    CASE 
        WHEN price_usd BETWEEN 0 AND 25 THEN '0-25'
        WHEN price_usd BETWEEN 25 AND 50 THEN '25-50'
        WHEN price_usd BETWEEN 50 AND 100 THEN '50-100'
        ELSE '100+' 
    END AS price_range,
    COUNT(product_id) AS total_products,
    AVG(rating) AS average_rating
FROM 
    product_info$
WHERE 
    rating IS NOT NULL
GROUP BY 
    CASE 
        WHEN price_usd BETWEEN 0 AND 25 THEN '0-25'
        WHEN price_usd BETWEEN 25 AND 50 THEN '25-50'
        WHEN price_usd BETWEEN 50 AND 100 THEN '50-100'
        ELSE '100+' 
    END
ORDER BY price_range;

/***19. Products with the most and least positive feeddback  **/
  [product_name],sum ([total_feedback_count]) AS 'total number of feedback', 
    
	
	round( sum ( total_neg_feedback_count)/  sum ([total_feedback_count])*100,2) AS' % of neg feedbak', 
	round( sum ( total_pos_feedback_count)/  sum ([total_feedback_count])*100,2) AS' % of pos feedbak'
     
        
  FROM [Sephora].[dbo].['reviews_1250-end$']
  WHERE 
    total_neg_feedback_count != 0  
    AND total_feedback_count != 0  
    AND total_pos_feedback_count != 0
  
   group by  [product_name]
   order by round( sum ( total_pos_feedback_count)/  sum ([total_feedback_count])*100,2)  desc
