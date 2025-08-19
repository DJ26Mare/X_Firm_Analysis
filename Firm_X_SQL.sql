Select * From "Firm1" ;

-- ## Business Problems --

--Q1  Find different payment method and number of transactions, number of qty sold

SELECT 
	 payment_method,
	 COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM "Firm1"
GROUP BY payment_method;

--Q2 Identify the highest-rated category in each branch, displaying the branch, category AVG RATING

SELECT branch, category, Average_Rating
FROM (
  SELECT 
    branch, 
    category, 
    AVG(rating) AS Average_Rating,
    RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
  FROM "Firm1"
  GROUP BY branch, category
) sub
WHERE rank = 1;


--Q3 Identify the busiest day for each branch based on the number of transactions

SELECT branch, day, No_of_Transactions
FROM (
  SELECT 
    branch,
    TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day,
    COUNT(*) AS No_of_Transactions,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
  FROM "Firm1"
  GROUP BY branch, TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day')
) sub
WHERE rank = 1
ORDER BY branch;

--Q4 Calculate the total quantity of items sold per payment method. List payment_method and total_quantity

Select payment_method , Sum(quantity) as quantity From "Firm1" group by payment_method;

--Q5 Determine the avg, min,max rating of products for each city.List the city,average_rating,min_rating and max_rating.

Select city , Min(rating) as min_rating , max(rating) as max_rating ,  ROUND(AVG(rating)::NUMERIC, 2) as average_rating 
From "Firm1"
group by city
order by 3 desc;

--Q6 Calculate the total profit for each category by considering total_profit as (unit_price * quantity *profit_margin).
--   List the catgory and total_profit,ordered from highest to lower profit.

Select category , Sum( total_amount * profit_margin) as total_profit
From "Firm1"
group by  1
order by 2 desc;
 
--Q7 Determine the most common payment_method for each branch,display branch and the preferred payment_method.

with Tab as(
Select branch , payment_method , count(*) as no_of_transactions,Rank() Over(Partition by branch Order by 3 desc) as ranking
From "Firm1"
group by 1 , 2
)
Select * From Tab
where ranking =1;

--Q8 Categorize sales into 3 group MORNING,AFTERNOON,EVENING.Find out which of the shift and no of invoices
Select *,time::time  From "Firm1";
Select branch ,
Case   
       WHEN Extract(HOUR FROM (time::time)) < 12 THEN 'MORNING'
	   WHEN Extract (HOUR FROM (time::time)) Between 12 and 15 THEN 'AFTERNOON'
	   WHEN Extract (HOUR FROM (time::time)) Between 15 and 20 THEN 'EVENING'
	   END as Day_Phase
	   
	 , Count(*) as no_of_invoices
	 
FROM "Firm1"
group by 1
order by 3 desc;

--Q9 Identify 5 branch with highest decrease ratio in revenue compare to last year(2022 and the year 2023)
-- revenue decrease ratio = (last_year_rev - current_year_rev)/last_year_rev * 100

-- Select *,To_Date(date, 'DD/MM/YY') as "Date" From "Firm1"

With revenue_2022 as(
Select branch , Sum(total_amount) as revenue
From "Firm1"
where Extract(Year From To_Date(date, 'DD/MM/YY')) =2022
group by 1
),
 revenue_2023 as  (
Select branch, Sum(total_amount) as revenue
From "Firm1"
where Extract(Year From To_Date(date, 'DD/MM/YY')) =2023
group by 1
)
Select one.branch as branch, one.revenue as revenue_2022,two.revenue as revenue_2023 , Round((one.revenue - two.revenue)::numeric/one.revenue::numeric * 100,2) as rev_dec_rat 
From revenue_2022 as one
Join revenue_2023 as two
on one.branch = two.branch
order by 4 desc
Limit 5;

--Q10 Identify the categories contributing to more than 25% of the total revenue in the dataset.

WITH revenue_per_product AS (
    SELECT 
        category,
        SUM(total_amount) AS product_revenue
    FROM sales
    GROUP BY category
),
ranked_products AS (
    SELECT 
        category,
        product_revenue,
        product_revenue / (SELECT SUM(total_amount) FROM sales) * 100 AS revenue_pct,
        SUM(product_revenue) OVER (ORDER BY product_revenue DESC) 
            / (SELECT SUM(total_amount) FROM sales) * 100 AS cumulative_pct
    FROM revenue_per_product
)
SELECT *
FROM ranked_products
WHERE cumulative_pct <= 25;

	   
