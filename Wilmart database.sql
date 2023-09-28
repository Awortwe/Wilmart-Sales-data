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
SELECT 
COUNT(DISTINCT Product_Line)
FROM sales;

--  What is the most common payment method?
SELECT payment_method, COUNT(payment_method)
FROM sales
GROUP BY payment_method
ORDER BY COUNT(payment_method) desc;

-- What is the most selling product line?
SELECT Product_Line, COUNT(*)'Number of Sales'
FROM sales
GROUP BY product_line
ORDER BY COUNT(*) DESC;

-- What is the total revenue by month?
SELECT * FROM sales;

SELECT Month_Name, SUM(total)TotalRevenue
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
SELECT Product_Line, SUM(total)TotalRevenue
FROM sales
GROUP BY Product_Line
ORDER BY TotalRevenue DESC
LIMIT 1;

-- What is the city with the largest revenue?
SELECT City, SUM(total)TotalRevenue
FROM sales
GROUP BY City
ORDER BY TotalRevenue DESC
LIMIT 1;

-- What product line had the largest VAT?
SELECT Product_Line, AVG(VAT)VAT 
FROM sales
GROUP BY Product_Line
ORDER BY VAT DESC
LIMIT 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT * FROM SALES;

SELECT Product_Line,
CASE 
WHEN SUM(total) > AVG(total) THEN 'GOOD'
ELSE 'BAD'
END AS 'Condition'
FROM sales 
GROUP BY Product_Line;

-- Which branch sold more products than average product sold?
SELECT Branch, sum(quantity)qty 
FROM SALES 
GROUP BY Branch
HAVING SUM(quantity) >
(SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?
SELECT Gender,
Product_Line, count(gender)cnt
FROM sales
GROUP BY Product_Line, Gender
ORDER BY cnt DESC;

-- What is the average rating of each product line?
SELECT Product_Line, FORMAT(avg(rating),2)AvgRating
FROM sales
GROUP BY Product_Line
ORDER BY AvgRating DESC;

-- Number of sales made in each time of the day per weekday
SELECT time_of_the_day, COUNT(*)Number_of_Sales
FROM sales
GROUP BY time_of_the_day
ORDER BY SUM(quantity) DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type CustomerType, SUM(total)Revenue
FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC;

-- Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT City, format(AVG(VAT),2)Tax
FROM sales
GROUP BY City
ORDER BY Tax DESC;

-- Which customer type pays the most in VAT?
SELECT * FROM sales;

SELECT customer_type, FORMAT(AVG(VAT),2)VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*)cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*)cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- What is the gender of most of the customers?
SELECT Gender, count(*)cnt
FROM sales
GROUP BY Gender
ORDER BY Gender;

-- What is the gender distribution per branch?
SELECT Branch, Gender, count(*)cnt
FROM sales
GROUP BY Branch, Gender
ORDER BY Branch;

-- Which time of the day do customers give most ratings?
SELECT Time_of_the_day, FORMAT(AVG(rating),2)avg_rating
FROM sales
GROUP BY Time_of_the_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT Branch, Time_of_the_day, FORMAT(AVG(rating),2)avg_rating
FROM sales
GROUP BY Branch, Time_of_the_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best avg ratings?
SELECT day_name, FORMAT(AVG(rating),2)avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT Branch, day_name, FORMAT(AVG(rating),2)avg_rating
FROM sales 
GROUP BY Branch, day_name
ORDER BY avg_rating DESC;

-- 