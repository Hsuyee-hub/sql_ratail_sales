CREATE DATABASE sql_project1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(255),
    age INT,
    category VARCHAR(255),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Data Exploration & Cleaning
SELECT *
FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

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

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL 
    OR 
    sale_time IS NULL 
    OR 
    customer_id IS NULL 
    OR 
    gender IS NULL 
    OR 
    age IS NULL 
    OR 
    category IS NULL 
    OR 
    quantity IS NULL 
    OR 
    price_per_unit IS NULL 
    OR 
    cogs IS NULL;

-- Data Analysis

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = "Clothing" 
	AND quantity > 3
	AND sale_date BETWEEN "2022-11-01" AND "2022-11-30";

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = "Beauty";

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
    category,
    gender,
	COUNT(transactions_id) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
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

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
		customer_id,
		SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
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





















