CREATE DATABASE IF NOT EXISTS salesDataWalmart;
USE salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(12,2) NOT NULL,
    gross_margin_pct FLOAT(11,9) NOT NULL,
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1) NOT NULL
);

SELECT * FROM sales;


-- ----------------------------- Feature Engineering ---------------------------

SELECT 
time,
(
	CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
    END) as time_of_the_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_the_day VARCHAR(20);

UPDATE sales
SET time_of_the_day =
CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

SELECT date, DAYNAME(date) DayName FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(30);

UPDATE sales
SET day_name = DAYNAME(date);

SELECT date, MONTHNAME(date) FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(date);


-- ----------------------------- Data Exploration ---------------------------

-- Generic Questions

-- How many unique cities does the data have?
SELECT DISTINCT City 
FROM sales;

SELECT DISTINCT Branch
FROM sales;

-- In which city is each branch?
SELECT DISTINCT City, Branch
FROM sales;

--  How many unique product lines does the data have?
SELECT * 
FROM sales;

SELECT DISTINCT Product_Line
FROM sales;

--  What is the most common payment method?
SELECT payment_method, COUNT(payment_method)
FROM sales
GROUP BY payment_method
ORDER BY COUNT(payment_method) desc;

-- What is the most selling product line?
SELECT * FROM sales;

SELECT Product_Line, COUNT(*)'Number of Sales'
FROM sales
GROUP BY product_line
ORDER BY COUNT(*) DESC;

-- What is the total revenue by month?
SELECT * FROM sales;

SELECT Month_Name, SUM(unit_price*quantity)TotalRevenue
FROM sales
GROUP BY Month_Name
ORDER BY TotalRevenue DESC;

-- What month had the largest COGS?
SELECT * FROM sales;

SELECT Month_Name, SUM(cogs)COGS
FROM sales
GROUP BY Month_Name
ORDER BY COGS DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT Product_Line, SUM(unit_price*quantity)TotalRevenue
FROM sales
GROUP BY Product_Line
ORDER BY TotalRevenue DESC
LIMIT 1;

-- 