use inventory;

select * from store;

#1. Identify which stores are showing consistent revenue growth
with mom_revenue_growth as (
#create the MoM revenue 
select *, round(((avg_revenue-prev_revenue)/prev_revenue )*100,2) as MoM_Revenue from (
#create a lag column to shift revenue and partion by store_ID, order by date
select *, lag(avg_revenue) over(partition by Store_ID order by date) as prev_revenue from (
#group by month and store_id to get avg_revnue 
select date_format(date, '%Y-%m') as Date, store_id, round(avg(revenue),2) as Avg_Revenue from(
#calculate the revenue
select *,(units_sold *price)*(1-(discount/100)) as revenue 
from store ) as rev
group by date_format(date, '%Y-%m') , Store_ID
) as gp
) as final
)
# counting only the positive revenue growths(since it is consistent growth revenue) and averaging them by store
select store_id, round(avg(case when mom_revenue> 0 then mom_revenue end ),2) as avg_revenue_growth from mom_revenue_growth
group by store_id
order by avg_revenue_growth desc;
#Result: Store5 shows 5.55% avg revenue growth followed by store 3 with 5.39%. The least is by store4 with 3.2% 

#2. Top 5 products across different regions
with top5_products as (
#select top 5 ranking products in each region
select * from (
#use rank function to rank each product based on avg revenue by region
select *, rank() over(partition by region order by avg_revenue desc) as ranking from (
#do a group by function to get average revenue by region and product id
select region, product_id, round(avg(revenue),2) as avg_revenue from(
#get the revenue for each row
select *, round((units_sold *price)*(1-(discount/100)),2) as revenue from store) as rev
group by region, product_id
) as gp
) as final
where ranking <=5
)
select product_id, count(product_id) from top5_products
group by product_id;
#Result: Out of all the regions product 20 seems to be in top 5 in 3 regions followed by product13-16 in 2 out of 4 regions


#3. Evaluate whether promotions are increasing revenue
select *, round(((rev_by_promo - rev_by_NO_promo)/rev_by_NO_promo)*100,2) as promo_ROI_percent
from (
#use case function in aggregation to find sum of promo and no promor
select store_id, round(sum(case when promotion=1 then revenue end),2) as rev_by_promo,
round(sum(case when promotion=0 then revenue end),2) as rev_by_NO_promo   from (
#calculate the revenue
select *, (units_sold * price)*(1-(discount/100)) as revenue from store
) as rev
group by store_id) as promo_rev;
#Result: store2 slightly received more roi by 1.21%, store1 had negative roi of -4.47% followed by store5 with -1.31%

#4. Which store has higher YoY inventory turn over?
select *, round(((Inventory_Turnover - prev_turnover)/ prev_turnover)*100,2) yoy_improvement
 from (
#create a lag function to get previous turn over 
select *, lag(Inventory_Turnover) over(partition by store_id order by year) as prev_turnover
 from (
#calculate the turn over formula
SELECT Store_ID, date_format(date, "%Y") as year,
ROUND(SUM(Units_Sold) / AVG(Inventory_Level), 2) AS Inventory_Turnover
FROM store
GROUP BY Store_ID, date_format(date, "%Y")
) as turn_over
) as prev_turn_over;
#Result: High Turn over acorss all the stores, slightly high for store3 and store 2 in 2022-2023

#5. Sales potential units sold vs previous forcasted demand year-month wise, which store missed most?

with demand_forcast as(
select *, (demand -units_sold) as under_utilised, round(((demand -units_sold)/units_sold )*100,2) as missed_demand_pct
from(
#group by year-month on total units sold and total demand forecast
select date_format(date, "%Y-%m") as date, store_id,
 sum(units_sold) as units_sold, round(sum(demand_forecast),0) as demand
 from store
group by store_id, date_format(date, "%Y-%m") 
) as a
)

select store_id, round(avg(missed_demand_pct),2) as avg_missed_demand_pct
from demand_forcast
group by store_id
order by avg_missed_demand_pct desc;
#Result: almost the same for all stores but store1 and 2 have missed slightly higher by 3.8% -2.7%

#6. Profit Margin across each Product compared to competitive pricing, which store is doing good / bad
select *, round(((avg_revenue - avg_comp_revenue)/ avg_comp_revenue)*100,2) as profit_margin
from (
select store_id , round(avg(revenue),2) as avg_revenue , round(avg(competition_revenue),2) as avg_comp_revenue
from (
select *, (units_sold* price) as revenue, (units_sold *competitor_pricing) as competition_revenue 
 from store 
 )
 as a
 group by store_id) as b;
 #Result: All the stores are not doing significantly better or worse from their competition (0.01% - 0.07%)
 
 #7.Which store has the best demand vs supply ratio/accuracy?
 SELECT
    Store_ID,
    ROUND(SUM(Units_Sold) / SUM(Demand_Forecast) * 100, 2) AS Demand_Accuracy_Pct,
    ROUND(SUM(Units_Sold) / SUM(Inventory_Level) * 100, 2) AS Utilization_Efficiency_Pct
FROM store
GROUP BY Store_ID;
#Result: All the stores have a good demand accuracy up to 96% and utlization efficieny pct at 50%.

#8. Which weather condition has the highest avg revenue and units sold
with cte as (
#calculate te avg_units_sold and avg_revenue
SELECT
    Weather_Condition,
    ROUND(AVG(Units_Sold), 2) AS Avg_Units_Sold,
    ROUND(AVG(Units_Sold * Price), 2) AS Avg_Revenue
FROM store
GROUP BY Weather_Condition
ORDER BY Avg_Revenue DESC)

#what portion of revenue is occupied by each weather
select *, round((avg_revenue)/ (select sum(avg_revenue) from cte),2) as pct_revenue from 
cte;
# Result: All the weather conditons equate to 25% of revenue each

#9. Competitve Pricing Index: how aggressively each store is priced relative to competitors.
SELECT
    Store_ID,
    ROUND(AVG(Price / Competitor_Pricing), 2) AS Price_Competitiveness_Index
FROM store
GROUP BY Store_ID;
#Result: Each store's competitive index is 1.01, which is less aggressive. The stores charge, 1.01 for 1 

#10. Revenue Concentration (Pareto Analysis: Identify top contributors — 80/20 rule for product or store portfolio)
#Divind the running total with the total revenue to see what products make up to 80% of revenue
select product_id, revenue, running_total, round(((running_total/ total_revenue) *100),2) as cumulative_revenue_pct
 from (
# calculate the running_total using sum() over() function, and the total_revenue make sure to use the descending order 
select *, sum(revenue) over() as total_revenue,
round(sum(revenue) over(order by revenue desc),2) as running_total
from (
#calculate the revneue
select product_id, round(sum(price* units_sold),2) as revenue from store
group by product_id
) a
) as b
#Result: Products which are not 3,8,2,12 make up to 80% of the revenue
