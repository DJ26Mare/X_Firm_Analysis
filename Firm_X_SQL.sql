Select * From "Firm1";
-- Drop Table "Firm1";
Select count(*) From "Firm1";


-- 	 ## Business Problems ##

--Q1 Find different payment method and no of transactions ,no of quantity sold.

Select payment_method , count(*) as no_of_transactions , Sum(quantity) as no_of_quantitySold
From "Firm1"
group by payment_method;


--Q2 Identify the highest-rated category in each branch, displaying the branch, category ,AVG RATING