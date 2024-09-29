
Bike-Share Data Analysis README

Overview
This project analyzes bike-sharing data across two years to identify trends, profitability, customer behavior, and demand patterns. The dataset includes hourly rentals, weather conditions, and rider types. SQL queries are used to derive actionable insights.

Requirements
MYSQL Environment: Required for executing queries.
PowerBI : To visualize

Data Sources:
cost_table.csv: Pricing and COGS data.
bike_share_yr_0.csv & bike_share_yr_1.csv: Hourly rental data.

Project Structure

Data Import: Import CSV files to create tables (cost_table, bike_share_yr_0, bike_share_yr_1).

SQL Analysis: Queries grouped into various analyses: Profit, Seasonal Demand, Rider Behavior, Profit Contribution, Weather Impact, Demand Fluctuation, Resource Allocation, and Comparative Trends.

Analysis Areas

Profit Analysis: Calculate yearly profit and identify highest margins.
Seasonal Demand: Analyze hourly demand by season and growth rates.
Rider Behavior: Compare holiday vs. working day ridership and weather impact.
Profit Contribution: Assess profit by rider type.
Weather Impact: Analyze how weather affects riders and profitability.
Demand Fluctuation: Compare weekend vs. weekday demand.
Optimization: Identify busiest hours for better resource allocation.
Yearly Trends: Compare hourly and weekly trends year-over-year.

Advanced Analysis

Weather & Rider Behavior: Correlate weather conditions with casual vs. registered riders.
Peak Hours Analysis: Identify peak and off-peak hours by season.
Demand Prediction: Calculate moving average demand over 3-hour windows.

Usage
Import the CSV files into the database.
Execute the SQL queries to gain insights.
Modify queries to explore additional hypotheses.
visualized in POWER BI


![image](https://github.com/user-attachments/assets/acb45fc3-7381-446d-8116-c95c15c8063a)


Key Insights
Profitability: Targeted marketing based on rider type and season.

Rider Behavior: Plan promotions based on weather and holiday impact.

Operational Optimization: Allocate bikes effectively during peak periods.

Forecasting: Use moving averages for inventory management and demand planning.
