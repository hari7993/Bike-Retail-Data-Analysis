with bike_market as (
select * from bike_share_yr_0
union 
select * from bike_share_yr_1
)

select *,
round(riders*price,2) as revenue,
round(riders*price-cogs,2) as profit
from bike_market a
left join cost_table b
on a.yr = b.yr ;


-- Problems Solving 


--  Identify which year had the highest profit margin for each product.

 with bike_market as (
select * from bike_share_yr_0
union 
select * from bike_share_yr_1
)
SELECT  a.yr as year, max(round((price - COGS)* riders,2)) AS  Max_yearly_profit
from bike_market a
left join cost_table b
on a.yr = b.yr 
group by  a.yr;

--  Which hour and weekday combination experienced the highest growth in bike-sharing demand between Year 0 and Year 1?

-- Seasonal Demand and Sales

SELECT season, hr, yr, SUM(riders) AS total_riders
FROM bike_share_yr_0
GROUP BY season, hr, yr
UNION ALL
SELECT season, hr, yr, SUM(riders) AS total_riders
FROM bike_share_yr_1
GROUP BY season, hr, yr
ORDER BY season, hr, yr;

-- Finding Peak and Off-Peak Hours for Each Season and Evaluating Their Contribution to Annual Profit

WITH rental_summary AS (
    SELECT season, hr, SUM(riders) AS total_riders,
           AVG((price - COGS) * riders) AS avg_profit
    FROM (
        SELECT bike.*, cost.price, cost.COGS
        FROM bike_share_yr_0 AS bike
        JOIN cost_table AS cost ON bike.yr = cost.yr
        UNION ALL
        SELECT bike.*, cost.price, cost.COGS
        FROM bike_share_yr_1 AS bike
        JOIN cost_table AS cost ON bike.yr = cost.yr
    ) AS combined
    GROUP BY season, hr
)
SELECT season, hr, total_riders, avg_profit,
       CASE WHEN total_riders = MAX(total_riders) OVER (PARTITION BY season) THEN 'Peak Hour'
            WHEN total_riders = MIN(total_riders) OVER (PARTITION BY season) THEN 'Off-Peak Hour'
            ELSE 'Normal' END AS hour_category
FROM rental_summary
ORDER BY season, hr;

-- Highest Growth in Demand

WITH hourly_comparison AS (
    SELECT season, hr, weekday, 
           SUM(CASE WHEN yr = 0 THEN riders ELSE 0 END) AS riders_yr0,
           SUM(CASE WHEN yr = 1 THEN riders ELSE 0 END) AS riders_yr1
    FROM (
        SELECT * FROM bike_share_yr_0
        UNION ALL
        SELECT * FROM bike_share_yr_1
    ) AS combined
    GROUP BY season, hr, weekday
)
SELECT season, hr, weekday, (riders_yr1 - riders_yr0) AS growth
FROM hourly_comparison
ORDER BY season,growth DESC
LIMIT 10;

--  How do rider behaviors of casual and registered users differ on holidays versus working days, and how do weather conditions affect each group?

-- Difference in Rider Patterns on Holidays vs. Working Days:

SELECT holiday, rider_type, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY holiday, rider_type
ORDER BY holiday, rider_type;
 
 -- Influence of Weather on Rider Type
 
SELECT rider_type, AVG(temp) AS avg_temp, AVG(hum) AS avg_humidity, AVG(windspeed) AS avg_windspeed, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY rider_type;

-- Predicting Future Bike Demand Based on Weather and Time Using a Moving Average

WITH weather_demand AS (
    SELECT weekday, hr, dteday, 
           SUM(riders) AS total_riders,
           AVG(temp) AS avg_temp,
           AVG(hum) AS avg_humidity,
           AVG(windspeed) AS avg_windspeed
    FROM (
        SELECT * FROM bike_share_yr_0
        UNION ALL
        SELECT * FROM bike_share_yr_1
    ) AS combined
    GROUP BY weekday, hr, dteday
),
moving_avg_demand AS (
    SELECT weekday, hr, dteday, total_riders, avg_temp, avg_humidity, avg_windspeed,
           AVG(total_riders) OVER (PARTITION BY weekday ORDER BY dteday, hr ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_riders
    FROM weather_demand
)
SELECT weekday, hr, dteday, total_riders, moving_avg_riders
FROM moving_avg_demand
ORDER BY dteday, hr;

--  What is the total profit contribution of casual and registered riders for each year, given the bike-sharing price and COGS? 

SELECT yr, rider_type, SUM((price - COGS) * riders) AS profit_contribution
FROM (
    SELECT bike.*, cost.price, cost.COGS
    FROM bike_share_yr_0 AS bike
    JOIN cost_table AS cost ON bike.yr = cost.yr
    UNION ALL
    SELECT bike.*, cost.price, cost.COGS
    FROM bike_share_yr_1 AS bike
    JOIN cost_table AS cost ON bike.yr = cost.yr
) AS combined
GROUP BY yr, rider_type
ORDER BY yr, rider_type;

--  How does weather impact profitability? 

SELECT temp, hum, windspeed, SUM(riders) AS total_riders, SUM((price - COGS) * riders) AS total_profit
FROM (
    SELECT bike.*, cost.price, cost.COGS
    FROM bike_share_yr_0 AS bike
    JOIN cost_table AS cost ON bike.yr = cost.yr
    UNION ALL
    SELECT bike.*, cost.price, cost.COGS
    FROM bike_share_yr_1 AS bike
    JOIN cost_table AS cost ON bike.yr = cost.yr
) AS combined
GROUP BY temp, hum, windspeed
ORDER BY total_riders DESC;

--  What is the hourly bike demand for weekends versus weekdays by season and rider type, and which hours show the most significant changes in usage patterns each year?

-- Weekend vs Weekday Demand by Season and Rider Type 

SELECT season, weekday, rider_type, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY season, weekday, rider_type
ORDER BY season, weekday, rider_type;

-- Hours with Significant Changes

SELECT hr, yr, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY hr, yr
ORDER BY hr, yr;

--  What is the busiest hour for each day of the week, and which time slots would benefit most from increased resource allocation, such as adding more bikes?
-- Busiest Hour Per Day of Week  

SELECT weekday, hr, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY weekday, hr
ORDER BY weekday, total_riders DESC;

--  How do hourly trends and weekly user behaviors compare between the same months and weeks across both years?

-- Hourly Trend Comparison for Similar Months
 
SELECT mnth, hr, yr, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY mnth, hr, yr
ORDER BY mnth, hr, yr;

-- Weekly Trend Comparison

SELECT weekday, yr, SUM(riders) AS total_riders
FROM (
    SELECT * FROM bike_share_yr_0
    UNION ALL
    SELECT * FROM bike_share_yr_1
) AS combined
GROUP BY weekday, yr
ORDER BY weekday, yr;
