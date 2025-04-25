# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Retail_Analysis`

In this project, I conducted a comprehensive analysis of retail sales data using SQL to derive actionable insights and trends. The process began with thorough data cleaning to address missing values, remove duplicates, and ensure the dataset's integrity. Utilizing window functions, I calculated ranked products by sales performance, and identified seasonal trends to better understand customer behavior. Additionally, I implemented precise data filtering methods to segment sales by various criteria, including timeframes, product categories, and sales channels. This project highlights my ability to apply SQL effectively to solve real-world analytical challenges and deliver valuable business insights.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Questions**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_Analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_Analysis ;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Cleaning 🧹

- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

SELECT COUNT(*) FROM retail_sales;
```

### 3.Data Exploration Analysis (EDA) 📊

- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;
```


### 4. Business Questions ❔❔

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select *
from retail_sales
where category = 'Clothing' and 
quantiy >=4  and
FORMAT(sale_date,'yyyy-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category
,sum(total_sale) AS [Total Sales],
count(*) as [Number Of Orders],
sum(quantiy) as [Number Of Quantities]
from retail_sales
group by category 
order by [Total Sales];
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select category,
avg(age) as [Average age]
from retail_sales
where category = 'Beauty'
group by category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1500.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1500
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender,
category
,COUNT(*) AS [number of orders]
from retail_sales
group by gender,category
order by gender, [number of orders];
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling Month**:
```sql
select * from (
select DATEPART(MONTH,sale_date) as Months ,
round(avg(total_sale),2) as [Total Sales],
rank() over(order by avg(total_sale) desc ) as Ranking
from retail_sales
group by DATEPART(MONTH,sale_date))t
where Ranking = 1
```

8. **Find which year we have the highest sales**:
```sql
select DATEPART(YEAR,sale_date) as Years,
sum(total_sale) AS [Total Sales]
from retail_sales
group by DATEPART(YEAR,sale_date)
order by [Total Sales];
```

9. **Find the BESTSELLERRRR 😃 month in each year(2022,2023)**
```sql
select * from (
select DATEPART(year,sale_date) as Years,
DATEPART(month,sale_date) as Months,
round(avg(total_sale),2) as Average_Totals,
rank() over(partition by DATEPART(year,sale_date) order by round(avg(total_sale),2) desc) as Ranking
from retail_sales 
group by DATEPART(year,sale_date),DATEPART(month,sale_date)) AS t
where Ranking = 1;
```



10. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
select top(5) customer_id,
sum(total_sale) AS [Total Sales]
from retail_sales
group by customer_id 
order by [Total Sales] desc
```

11. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select
category ,
count(distinct customer_id) [Unique Customers]
from retail_sales
group by category 
order by [Unique Customers] desc
```

12. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
**Using SubQueries**
SELECT
shifts,
count(*) AS [Sum Of Orders]
FROM
         (SELECT DATEPART(HOUR, sale_time) AS Hours,
        CASE WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
             WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
             ELSE 'Evening'
             END AS shifts
        FROM retail_sales
        ) t
GROUP BY shifts
order by [Sum Of Orders] desc;


**or Using CTE**

with hourly_sales as
(SELECT DATEPART(HOUR, sale_time) AS Hours,
CASE WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
     WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
     END AS shifts
FROM retail_sales) 

select shifts,count(*) as [Total Orders]
from hourly_sales 
group by shifts
order by [Total Orders] desc;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository https://github.com/Safa-Ali-Ahmed/Retail-Sales-Analysis.git.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

## Feedback
If you have any suggestions or feedback, feel free to open an issue or connect with me [LinkedIn](https://www.linkedin.com/in/safaali-da/).
  
## License
This project is licensed under the MIT License. See the `LICENSE` file for details.


