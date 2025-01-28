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

Select  branch , category , Avg(rating) as Average_Rating , Rank() Over(Partition by branch order by Avg(rating) desc) as rank
From "Firm1"
Group by rating,branch,category;

--Q3 Identify the busiest day for each branch based on the number of transactions

Select branch,TO_CHAR(To_Date(date, 'DD/MM/YY'),'day') as "Day",Count(*) as No_of_Transactions
From "Firm1"
group by branch,2
order by 1,3 desc;

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
 
--Q7 Determine the most common payment_method for each branch,display 	branch and the preferred payment_method.

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
Select *,To_Date(date, 'DD/MM/YY') as "Date" From "Firm1"

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


	   
