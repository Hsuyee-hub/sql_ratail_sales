# Retail Sales Data Analysis (SQL Project)

## Overview
This project focuses on analyzing a **Retail Sales dataset** using **MySQL**.  
The goal is to demonstrate SQL proficiency through data cleaning, exploration, and analysis of customer, sales, and category trends to uncover actionable business insights.

---

## Tools & Technologies
- **Database:** MySQL  
- **Language:** SQL  
- **Dataset:** `Online Retail II (UCI)` (modified sample)  
- **Environment:** MySQL Workbench  

---

## Project Objectives
1. Clean and prepare the retail dataset by handling missing or invalid values.  
2. Explore and summarize the dataset to understand sales patterns.  
3. Answer key business questions related to sales performance, customer behavior, and product categories.  
4. Demonstrate SQL knowledge in **aggregation, joins, subqueries, CTEs, and window functions**.  

---

## Concepts Demonstrated
- Data cleaning & validation  
- Aggregation functions (`SUM`, `AVG`, `COUNT`)  
- Grouping & filtering (`GROUP BY`, `HAVING`, `WHERE`)  
- Window functions (`RANK()`, `OVER`)  
- Subqueries and CTEs  
- Conditional logic (`CASE WHEN`) 

---

## Data Cleaning Steps
- Removed rows with missing or null values in key columns: `sale_date`, `sale_time`, `customer_id`, `gender`, `age`, `category`, `quantity`, `price_per_unit`, `cogs`.  
- Verified data consistency and ensured correct data types for each column.  
- Confirmed valid entries (no negative or zero quantities, valid gender labels, etc.).  

---

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project1;

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
---

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- How many sales we have?
SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- How much sales revenue we have?
SELECT SUM(total_sale)
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer
FROM retail_sales;

-- How many category we have?
SELECT DISTINCT category 
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR
	sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

```
---
### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

Write a SQL query to retrieve all columns for sales made on '2022-11-05:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";
```

Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:
```sql
SELECT *
FROM retail_sales
WHERE category = "Clothing" 
	AND quantity > 3
	AND sale_date BETWEEN "2022-11-01" AND "2022-11-30";
```

Write a SQL query to calculate the total sales (total_sale) for each category.
```sql
SELECT
	category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
```sql
SELECT
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = "Beauty";
```

Write a SQL query to find all transactions where the total_sale is greater than 1000.
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;
```

Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
```sql
SELECT
    category,
    gender,
	COUNT(transactions_id) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
```sql
SELECT * FROM
(
	SELECT
		YEAR(sale_date) AS sales_year,
		MONTH(sale_date) AS sales_month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
	FROM retail_sales
	GROUP BY sales_year, sales_month
) AS rank_temp
WHERE sales_rank = 1;
```

Write a SQL query to find the top 5 customers based on the highest total sales
```sql
SELECT 
		customer_id,
		SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

Write a SQL query to find the number of unique customers who purchased items from each category.
```sql
SELECT
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
```sql
WITH sales_time AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN "Morning"
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
        ELSE "Evening"
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM sales_time
GROUP BY shift
ORDER BY total_orders DESC;
```

## Findings

- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Most profitable category:** Clothing had the highest total sales revenue.
- **Seasonal trends:** Certain months consistently outperformed others, showing clear seasonality.
- **Peak purchasing period:** Evenings had the highest number of orders. 
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.


## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
 

---

## How to Run
1. Open **MySQL Workbench** or any MySQL client.  
2. Create a new database:
   ```sql
   CREATE DATABASE sql_project1;
   USE sql_project1;
   ```
3. Create the table and import data (CSV file if available).  
4. Run the queries in order from `Project1_Retailsales.sql`.  

---

## Author
**Hsu Yee Min**  
Data Analyst | SQL ‚Power BI ‚Excel ‚Python

Open to remote roles 

Email | hsuyeemin.hym@gmail.com

