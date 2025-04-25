--Data cleaning 🧹

select * from retail_sales;

select 
    count(*) from retail_sales;

select * from retail_sales
where transactions_id is null or
sale_date is null or
sale_time is null or
customer_id	is null or 
gender is null or
category is null or
quantiy is null or
price_per_unit is null or
cogs is null or
total_sale is null;

delete from retail_sales 
where transactions_id is null or
sale_date is null or
sale_time is null or
customer_id	is null or 
gender is null or
category is null or
quantiy is null or
price_per_unit is null or
cogs is null or
total_sale is null;

select 
    count(*) from retail_sales;

select * from retail_sales where age is null ;
------------------------------------------------------------------------------------------------------------------------------

--Data Exploration 📊:

--1.How Many sales do we have?
select count(*) as [No of sales] from retail_sales ; --1997

--2.How Many Customers We Have?
select count(distinct customer_id) as No_Customer_IDs from retail_sales; --155

--3.what categories we have?
select count(distinct category) from retail_sales; --3
-----------------------------------------------------------------------------------------------------------------------------------	

--Business Questions ❔❓:

--1.Retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

--2.Retrieve all transactions where category is clothing and quantity > 10 and in the month nov-2022:
select * from retail_sales
where category = 'Clothing' and 
quantiy >=4  and
FORMAT(sale_date,'yyyy-MM') = '2022-11';

--3.Calculate Total Sales for each category:
select category,sum(total_sale) AS [Total Sales],
count(*) as [Number Of Orders],
count(quantiy) as [Number Of Quantities]
from retail_sales
group by category 
order by [Total Sales];

--4.Find the average Age of Customers who Purchased item from 'Beauty' category:
select category,round(avg(age),0) as [Average age] from retail_sales
where category = 'Beauty'
group by category;

--5.find all transactions where total sales more than 5000
select * from retail_sales where total_sale > 1500;

--6.Find the number of transactions made by each gender in each category?
select gender,category,COUNT(*) [number of orders] from retail_sales
group by gender,category
order by gender, [number of orders];

--7.Calculate the average sale for each month.find out the best selling month in the year.....show transactionId and quantity
select transactions_id,quantiy,DATEPART(MONTH,sale_date) as Months ,
ROUND(AVG(total_sale) OVER (PARTITION BY DATEPART(MONTH, sale_date)),0)  AS [Total Sales Per Month]
from retail_sales;


--8.Find which year we have the highest sales:
select DATEPART(YEAR,sale_date) as Years,sum(total_sale) AS [Total Sales] from retail_sales
group by DATEPART(YEAR,sale_date)
order by [Total Sales];

--9.Find the BESTSELLERRRR 😃 month in each year(2022,2023)

select * from (
select DATEPART(year,sale_date) as Years,
DATEPART(month,sale_date) as Months,
round(avg(total_sale),2) as Average_Totals,
rank() over(partition by DATEPART(year,sale_date) order by round(avg(total_sale),2) desc) as Ranking
from retail_sales 
group by DATEPART(year,sale_date),DATEPART(month,sale_date)) AS t
where Ranking = 1;

--10.find the top 5 customers based on highest total sales:
select top(5) customer_id,sum(total_sale) AS [Total Sales] from retail_sales
group by customer_id 
order by [Total Sales] desc;

--11.find number of unique customers who purchased item from each category
select category ,count(distinct customer_id) [Unique Customers] from retail_sales
group by category;


--12.Calculate number of orders in the following shifts (morning >=12,afternoon bet 12 & 17, evening >=17)
SELECT shifts, count(*) AS [Sum Of Orders]
FROM (SELECT DATEPART(HOUR, sale_time) AS Hours,
CASE WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
     WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
     END AS shifts
FROM retail_sales
) t
GROUP BY shifts;

-- or Using CTE:
with hourly_sales as
(SELECT DATEPART(HOUR, sale_time) AS Hours,
CASE WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
     WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
     END AS shifts
FROM retail_sales) 

select shifts,count(*) as [Total Orders]
from hourly_sales 
group by shifts;


--(●'◡'●) End Of Project (●'◡'●) .........







