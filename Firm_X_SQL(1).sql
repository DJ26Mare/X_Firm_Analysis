Select * From "Firm1";

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




