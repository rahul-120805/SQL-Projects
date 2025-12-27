-- SWIGGY PROJECT

CREATE DATABASE swiggy;
USE swiggy;


-- ALL values
SELECT * FROM swiggy_data;

-- Count of all rows
SELECT COUNT(*) AS "Count of All Rows"
FROM swiggy_data;

-- Data Validation and Cleaning
-- Check for null values in each column 
SELECT
SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END)AS null_state,
SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS  null_date,
SUM(CASE WHEN Restaurant_name IS NULL THEN 1 ELSE 0 END) AS null_restaurant,
SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END)  AS null_category,
SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS null_dish_name,
SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS null_price,
SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
SUM(CASE WHEN Rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM swiggy_data;


-- Blank or empty strings (done only for dimension)
SELECT * 
FROM swiggy_data
WHERE 
State = '' OR City = '' OR Restaurant_Name ='' OR Location = '' OR Dish_Name = '';


-- Duplicate Detection  #
SELECT 
state,city,order_date,restaurant_name,location,dish_name,price_inr,rating,rating_count,
COUNT(*) AS 'Count'
FROM swiggy_data
GROUP BY 
state,city,order_date,restaurant_name,location,dish_name,price_inr,rating,rating_count
HAVING 
COUNT(*) > 1;


-- Delete Duplication  #### (using a CTE function which creates an temporary table during the duration of query different from SELECT INTO)
WITH Duplicate_table AS (
SELECT *, ROW_NUMBER() OVER(
  PARTITION BY state,city,order_date,restaurant_name,location,dish_name,price_inr,rating,rating_count
  order by (SELECT NULL)
) AS rn
FROM swiggy_data
)
DELETE FROM Duplicate_table WHERE rn>1;



-- Star Schema Creation
-- DATE TABLE 
CREATE TABLE dim_date(
date_id INT IDENTITY(1,1) PRIMARY KEY,         
full_date DATE,
year INT,
month INT, 
month_name VARCHAR (20),
quarter INT,
day INT,
week INT
);

-- LOCATION TABLE 
CREATE TABLE dim_location(
location_id INT IDENTITY(1,1) PRIMARY KEY,                 
state VARCHAR(200),
city VARCHAR(400),
location VARCHAR(400)
);

-- RESTAURANT TABLE
CREATE TABLE dim_restaurant(
restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
restaurant_name VARCHAR(100),
);

-- CATEGORY TABLE 
CREATE TABLE dim_category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category VARCHAR(200)
);

-- DISH TABLE 
CREATE TABLE dim_dish(
dish_id INT IDENTITY (1,1) PRIMARY KEY,
dish VARCHAR(500)
);

-- FACT TABLE 
CREATE TABLE fact_swiggy(
order_id INT IDENTITY(1,1) PRIMARY KEY,

date_ID INT,
price_inr DECIMAL(10,2),        -- can take 10 values and 2 values after decimal  
rating DECIMAL(4,2),
rating_count INT,

location_id INT,
restaurant_id INT,
category_id INT,
dish_id INT,

FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id));




-- INSERT DATA INTO THE TABLES   (cant use SELECT INTO cuz we have created table of diff columns here so use INSERT)
INSERT INTO dim_date
(full_date, year,month,month_name,quarter,day,week)
SELECT DISTINCT														-- here also values not used
	Order_Date,
	YEAR(Order_Date),
	MONTH(ORDER_Date),
	DATENAME(MONTH,Order_Date),
	DATEPART(QUARTER,(Order_Date)),
	DAY(Order_Date),
	DATEPART(WEEK,Order_Date)
FROM swiggy_data
WHERE Order_Date IS NOT NULL;

SELECT * FROM dim_date;


INSERT INTO dim_location
(state,city,location)
SELECT DISTINCT
	State,
	City,
	Location 
FROM swiggy_data;
SELECT * FROM dim_location;


INSERT INTO dim_restaurant
(restaurant_name)
SELECT DISTINCT
	Restaurant_Name
FROM swiggy_data;
SELECT * FROM dim_restaurant;


INSERT INTO dim_dish
(dish)
SELECT DISTINCT 
	dish_name
FROM swiggy_data;

INSERT INTO dim_category
(category)
SELECT DISTINCT 
	category
FROM swiggy_data;
SELECT * FROM dim_category;


INSERT INTO fact_swiggy 
(date_ID, price_inr,rating,rating_count,location_id, restaurant_id,category_id,dish_id)
SELECT 
dd.date_ID,
s.price_inr,
s.rating,
s.rating_count,
dl.location_id,
dr.restaurant_id,
dc.category_id,
ds.dish_id
FROM swiggy_data AS s

JOIN dim_date AS dd
ON dd.full_date = s.Order_date 

JOIN dim_location AS dl
ON dl.location = s.Location
AND dl.state = s.State
AND dl.city = s.City

JOIN dim_restaurant AS dr
ON dr.restaurant_name = s.Restaurant_Name

JOIN dim_category AS dc
ON dc.category = s.Category

JOIN dim_dish AS ds
ON ds.dish = s.Dish_Name
;
SELECT * FROM fact_swiggy;


-- Now too see all the tables 
SELECT * FROM fact_swiggy AS f
JOIN dim_date AS d ON d.date_id = f.date_ID
JOIN dim_location AS l ON l.location_id = f.location_id
JOIN dim_restaurant AS r ON r.restaurant_id = f.restaurant_id
JOIN dim_category AS c ON c.category_id = f.category_id
JOIN dim_dish AS ds ON ds.dish_id = f.dish_id;



-- KPI 
-- TOTAL ORDERS
SELECT COUNT(*) AS 'Total Orders'
FROM fact_swiggy;


-- TOAL REVENUE IN (INR MILLIONS)
SELECT 
CONCAT(FORMAT(SUM(price_inr)/1000000,'N0'), ' INR MILLIONS') AS 'Total Revenue'       -- using round was giving 52.990000 INR MILLIONS , in such case USE FORMAT
FROM fact_swiggy;
-- Why 'N2'?, N: Tells SQL Server "Format this as a standard Number.", 2: Tells it "Give me 2 decimal places."


-- AVERAGE DISH PRICE
SELECT 
FORMAT(AVG(price_inr),'N2') + ' INR' AS 'Average Dish Price'
FROM fact_swiggy;

-- AVERAGE RATING
SELECT
FORMAT(AVG(rating),'N2') AS 'Avg Rating'
FROM fact_swiggy;



-- MONTHLY ORDER TRENDS
SELECT
dd.year AS 'Year',
dd.month AS 'Month Number',
dd.month_name AS 'Month Name',
COUNT(*) AS 'Total Orders'
FROM fact_swiggy AS s
JOIN dim_date AS dd
ON dd.date_id = s.date_ID
GROUP BY dd.year,dd.month,dd.month_name
ORDER BY dd.month;


-- QUARTERLY ORDER TRENDS
SELECT
dd.year AS 'Year',
dd.quarter AS 'Quarter',
COUNT(*) AS 'Total Orders'
FROM fact_swiggy AS s
JOIN dim_date AS dd
ON dd.date_id = s.date_ID
GROUP BY dd.year,dd.quarter;


-- YEARLY 
SELECT
dd.year AS 'Year',
COUNT(*) AS 'Total Orders'
FROM fact_swiggy AS s
JOIN dim_date AS dd
ON dd.date_id = s.date_ID
GROUP BY dd.year;

SELECT * FROM dim_date;

-- ORDERS BY DAY OF WEEK
SELECT
DATENAME(WEEKDAY,dd.full_date) AS 'Day',
COUNT(*) AS 'Total Orders'
FROM fact_swiggy AS s
JOIN dim_date AS dd
ON dd.date_id = s.date_ID
GROUP BY DATENAME(WEEKDAY,dd.full_date),DATEPART(WEEKDAY,dd.full_date)
ORDER BY DATEPART(WEEKDAY,dd.full_date);


-- TOP 10 CITIES BY ORDER VOLUME
SELECT * FROM fact_swiggy;
SELECT * FROM dim_location;

SELECT TOP 10
l.city AS 'City',
COUNT(*) AS 'Order Volume'
FROM fact_swiggy AS s
JOIN dim_location AS l
ON l.location_id = s.location_id
GROUP BY l.city 
ORDER BY [Order Volume] DESC;




-- TOP 10 CITIES BY REVENUE
SELECT * FROM fact_swiggy;
SELECT * FROM dim_location;

SELECT TOP 10
l.city AS 'City',
SUM(f.price_inr) AS 'Total Revenue'
FROM fact_swiggy AS f
JOIN dim_location AS l
ON l.location_id = f.location_id
GROUP BY l.city 
ORDER BY [Total Revenue] DESC;


-- Revenue Contribution by States 
SELECT * FROM fact_swiggy;
SELECT * FROM dim_location;

SELECT TOP 10
l.state AS 'State',
SUM(f.price_inr) AS 'Total Revenue'
FROM fact_swiggy AS f
JOIN dim_location AS l
ON l.location_id = f.location_id
GROUP BY l.state
ORDER BY [Total Revenue] DESC;


-- Top 10 restaurants by Order
SELECT * FROM dim_restaurant;
SELECT * FROM fact_swiggy;

SELECT TOP 10
re.restaurant_name AS 'Restaurant',
COUNT(*) AS 'Orders'
FROM fact_swiggy AS s
JOIN dim_restaurant AS re
ON s.restaurant_id = re.restaurant_id
GROUP BY re.restaurant_name
ORDER BY [Orders] DESC;



-- TOP Categories (Indian, Chinese...)
SELECT * FROM dim_category;
SELECT * FROM fact_swiggy;

SELECT c.category AS 'Categories',
COUNT(*) AS 'Total Orders'
FROM fact_swiggy AS s
JOIN dim_category AS c 
ON c.category_id = s.category_id
GROUP BY c.category
ORDER BY [Total Orders] DESC;


-- Cuisine Performance + AVG Rating
SELECT  c.category,
COUNT(*) AS 'Total_Orders',
AVG(CONVERT(float,f.rating)) AS 'Avg Rating'
FROM fact_swiggy AS f
JOIN dim_category AS c 
ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY Total_Orders DESC;