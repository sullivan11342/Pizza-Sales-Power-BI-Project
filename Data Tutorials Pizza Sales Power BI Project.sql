--USE DATA TUTORIALS DATABASE

-- Tutorial and raw data can be found at https://www.youtube.com/watch?v=V-s8c6jMRN0&t=6191s 


select * from Pizza_sales

--We need to analyze key indicators for our pizza sales data to gain insight into our business performance.
--Specifically, we want to calculate the following metrics:

--1. Total Revenue: The sum of the total price of all pizza orders.

select sum(total_price) AS Total_Revenue FROM pizza_sales; 

--2. Average Order Value: The average amount spent per order, calculated by dividing the total revenue by the total number of orders.

	select (sum(total_price)/count(distinct(order_id))) AS Average_order_value FROM pizza_sales 

--3. Total Pizzas sold: The sum of the quantities of all pizzas sold.

Select SUM(Quantity) AS total_pizza_sold FROM pizza_sales 

--Total pizzas sold per pizza name

select pizza_name_id, sum(quantity) AS Total_pizzas_sold FROM pizza_sales
GROUP BY pizza_name_id 
ORDER BY total_pizzas_sold desc

--4. Total Orders: The total number of orders placed:

select count(distinct(order_id)) AS Total_Number_of_Orders_placed from pizza_sales; 


--5. Average Pizzas per Order: The average number of pizzas sold per order, calculated by dividing the total number of pizzas 
--sold by the total number of orders.

select (count(pizza_id)/count(distinct(order_id))) AS Average_pizzas_per_order FROM Pizza_sales; 

SELECT * FROM pizza_sales

select CAST(CAST(SUM(Quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT(order_id)) AS DECIMAL (10,2)) AS DECIMAL(10,2)) AS Average_Pizzas_Per_Order FROM pizza_sales; 




--CHARTS REQUIREMENTS

--1. Daily Trend for Total Orders: Create a bar chart that displays the daily trend of total orders over a specific time period. This chart will help us identify any 
--patterns or fluctuations in order volumes on a daily basis.

SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT (order_id)) AS Total_Daily_orders FROM pizza_sales 
GROUP BY DATENAME(DW, order_date) 

--NOTE the data that is reflected when running this query, the sum is 21,350. This is representative of the total annual orders, broken down by how many of those 
-- were ordered on each day of the week.

--2. Monthly Trend for Total Orders: Create a line chart that illustrates the hourly trend of total orders throughout the day. This chart will allow us to identify 
--peak hours or periods of high order activity.

SELECT DATENAME(MONTH, order_date) AS Month_Name, COUNT(Distinct(order_id)) Total_Monthly_Orders FROM Pizza_sales
GROUP BY DATENAME(Month, order_date) 

--NOTE the data that is reflected when running this query, the sum is 21,350. This is representative of the total annual orders, broken down by how many of those 
-- were ordered within each month of the year.


--3. Percentage of Sales by Pizza Category: Create a pie chart that shows the distribution of sales across different piza categories. This chart will provide
--insights into the popularity of various pizza categories and their contribution to overall sales.

SELECT Pizza_Category, sum(total_price) AS Total_Sales, sum(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT FROM Pizza_Sales
GROUP BY Pizza_category; 

--see the data but only for the month of January: 

SELECT Pizza_Category, sum(total_price) AS Total_Sales, sum(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT FROM Pizza_Sales
WHERE Month(Order_date) = 1
GROUP BY Pizza_category; 


SELECT Pizza_Category, sum(total_price) AS Total_Sales, sum(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE Month(Order_date)=1) AS PCT FROM Pizza_Sales
WHERE Month(Order_date) = 1
GROUP BY Pizza_category; 



--4. Percentage of Sales by Pizza Size: Generate a pie chart that representsthe percentage of sales attributed to different pizza sizes. This chart
-- will help us understand customer preferences for pizza sizes and their impact on sales.

SELECT Pizza_size, CAST(sum(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(sum(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT 
FROM Pizza_Sales
GROUP BY Pizza_size
ORDER BY PCT DESC; 


-- Using the query below will generate the information for the first quarter. 

SELECT Pizza_size, CAST(sum(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(sum(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(Quarter,Order_date)=1) AS DECIMAL(10,2)) AS PCT 
FROM Pizza_Sales
WHERE DATEPART(Quarter,Order_date)=1
GROUP BY Pizza_size
ORDER BY PCT DESC; 

select * from pizza_sales; 


--5. Total Pizzas sold by pizza category: Create a funnel chart that presents the total number of pizzas sold for each pizza category. This chart 
-- will allow us to compare the sales performance of different pizza categories. 

Select pizza_category, SUM(Quantity) AS total_pizza_sold FROM pizza_sales 
GROUP BY Pizza_category

--What about total pizzas sold by pizza category for the month of February?

Select pizza_category, SUM(Quantity) AS total_pizza_sold FROM pizza_sales 
WHERE Month(Order_date) = 2
GROUP BY Pizza_category
ORDER BY Total_pizza_sold DESC


--6. Top 5 Best Sellers by Total Pizzas Sold: 
--Create a bar chart highlighting the top 5 best-selling pizzas based on the total number of pizzas sold.
--This chart will help us identify the most popular pizza options.

-- The query below will show all performers, but remember, we are looking for top 5.

SELECT pizza_name, sum(quantity) AS TOTAL_quantity FROM pizza_sales 
GROUP BY Pizza_name 
ORDER BY total_quantity DESC

--top 5, in query below:

SELECT TOP 5 pizza_name, sum(quantity) AS TOTAL_quantity FROM pizza_sales 
GROUP BY Pizza_name 
ORDER BY total_quantity DESC



--7. Bottom 5 worst sellers by Total Pizzas sold:
--Create a bar chart showcasing teh bottom 5 worst-selling pizzas based on the total number of pizzas sold. 
--This chart will help us identify underperforming or less popular pizza options. 

-- Same query as above, but we are using the "ASC" in the order clause. 

SELECT TOP 5 pizza_name, sum(quantity) AS TOTAL_quantity FROM pizza_sales 
GROUP BY Pizza_name 
ORDER BY total_quantity ASC