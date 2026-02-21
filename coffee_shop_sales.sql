SELECT * FROM coffee_shop

ALTER TABLE coffee_shop

CHANGE COLUMN ï»¿transaction_id transaction_id INT;

describe coffee_shop

--total sales analysis for month

select round(sum(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop
where
month(transaction_date) = 5 --for may month for specific month

--comparing monthly sales on selected month to previous month sm -may=5 pm april=4



SELECT
    -- Number of the month (e.g. 4 for April)
    MONTH(transaction_date) AS month,
    -- Total sales
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    -- Month-on-month sales difference
    SUM(unit_price * transaction_qty)- LAG(SUM(unit_price * transaction_qty), 1)
	OVER (ORDER BY MONTH(transaction_date)) AS sales_diff,
    -- Percentage increase
    (SUM(unit_price * transaction_qty)- LAG(SUM(unit_price * transaction_qty), 1)
	OVER (ORDER BY MONTH(transaction_date)))/ LAG(SUM(unit_price * transaction_qty), 1)
	OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
    coffee_shop
WHERE
    MONTH(transaction_date) IN (4, 5)
GROUP BY
    MONTH(transaction_date)
ORDER BY
    MONTH(transaction_date);
    
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop 
WHERE MONTH (transaction_date)= 5 -- for month of (CM-May);

--total quantity sales 

SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop
--CALENDAR table – DAILY SALES, QUANTITY and TOTAL ORDERS

SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM 
    coffee_shop
WHERE 
    transaction_date = '2023-05-18'; --For 18 May 2023
    
--weekends sat and sun
--weekdays mon to fri

Sun = 1
.
.
sat = 7 

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END
    
-----location

SELECT 
	store_location,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2), 'K') as Total_Sales
FROM coffee_shop
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC  --descending order

----AVG sales

SELECT 
CONCAT(ROUND(AVG(total_sales)/1000, 1), 'K' ) AS average_sales
FROM (
    SELECT SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

--Daily sales for selected month 

SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

--product category SALES BY PRODUCTS (TOP 10)

SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10

--by hour

SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

---TO GET SALES FOR ALL HOURS FOR MONTH OF MAY

SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);

--TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;










