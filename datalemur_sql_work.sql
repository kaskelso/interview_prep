SELECT
    COUNT(CASE WHEN device_type = 'laptop' THEN 1 END) AS laptop_views,
    COUNT(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 END) AS mobile_views
FROM viewership;


-- sort table and grab third observations

SELECT user_id, spend, transaction_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) sub
WHERE rn = 3;


SELECT pg.page_id
FROM pages pg
LEFT JOIN page_likes pl ON pg.page_id = pl.page_id
WHERE pl.liked_date IS NULL
ORDER BY pg.page_id::integer DESC;


SELECT salary
FROM (
    SELECT salary,
           RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee
) sub
WHERE rnk = 2;


SELECT user_id, tweet_date
FROM tweets
ORDER BY user_id, tweet_date;


-- calc 3 day avg by user

SELECT user_id, tweet_date,
   ROUND(AVG(tweet_count) OVER (
     PARTITION BY user_id
     ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
         AS moving_average
FROM tweets;

-- calc 3 day avg for all tweets (will overlap user avgs)

SELECT user_id, tweet_date,
   ROUND(AVG(tweet_count) OVER (
     ORDER BY user_id, tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
         AS rolling_avg_3d
FROM tweets;

--- from df with colum topping and cost, get every combo of toppings, sum of costs, sort by cost then toppings alphabetically

SELECT
  t1.topping_name || ',' || t2.topping_name || ',' || t3.topping_name AS topping_combo,
  t1.ingredient_cost + t2.ingredient_cost + t3.ingredient_cost AS total_cost
FROM
  pizza_toppings t1
JOIN
  pizza_toppings t2 ON t1.topping_name < t2.topping_name
JOIN
  pizza_toppings t3 ON t2.topping_name < t3.topping_name
ORDER BY
  total_cost DESC, topping_combo;


/*
Ok so you need to think of this as inside out
first you start by counting tweets above 2022
then you count the number of users and their tweets from that query
*/

SELECT
  tweet_count,
  COUNT(*) AS num_users
FROM (
  SELECT
    user_id,
    COUNT(*) AS tweet_count
  FROM tweets
  WHERE tweet_date > '2021-12-31 00:00:00'
  GROUP BY user_id
) AS per_user_counts
GROUP BY tweet_count
ORDER BY tweet_count;

/*
WHERE comes into play before any aggregation is done. That is why it operates only on row-level data.
Meanwhile, HAVING comes after executing the GROUP BY clause.
That means it comes into play after transforming the table and grouping it on a level that is different from the source table
*/

SELECT
  candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) = 3;



-- this gets the days between posts for users with more than two  posts

SELECT user_id, EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) AS "days_between"
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING count(post_id) > 1;


-- counts messages from senders in august 2022 then ranks the count of the top 2

SELECT sender_id,
COUNT (*) AS messages_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31'
GROUP BY sender_id
ORDER BY messages_count DESC LIMIT 2;

-- this counts cases then divides them grouping by app_id, be careful depending on our how you () SQL wont treat is as floating number

SELECT
  app_id,
    ROUND(100.0 * COUNT(CASE WHEN event_type = 'click' THEN 1 END) / COUNT(CASE WHEN event_type = 'impression' THEN 1 END), 2) AS ctr
FROM events
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY app_id

-- counts duplicate job postings

SELECT COUNT(company_id)
FROM (
SELECT company_id, description, COUNT(description)
FROM job_listings
GROUP BY company_id, description
HAVING COUNT(description) > 1
) AS duplicates


-- gives top three cities with completed trades

SELECT city, COUNT(city) as city_count
FROM (
SELECT *
FROM trades
JOIN users ON trades.user_id = users.user_id
WHERE status = 'Completed'
) AS sub
GROUP BY city
ORDER BY city_count DESC LIMIT 3

-- get average rating per month by product and sort my month and product

SELECT EXTRACT (MONTH FROM submit_date) as mth, product_id, ROUND(AVG(stars), 2)
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id

SELECT e1.employee_id, e1.name, e2.name, e1.salary as emp_sal, e2.salary as mana_sal
FROM employee e1
JOIN employee e2 on e1.employee_id = e2.manager_id;


-- in a table of employee and manager info and salaries this finds employees who make more than managers

SELECT employee_id, emp_name
FROM(
SELECT e2.employee_id, e1.name AS mana_name, e2.name AS emp_name, e1.salary as mana_sal, e2.salary as emp_sal
FROM employee e1
JOIN employee e2 on e1.employee_id = e2.manager_id
) AS mana_emp_sal
WHERE emp_sal > mana_sal

-- get user_id for users who signed up the next day

SELECT user_id
FROM (
SELECT user_id, EXTRACT( DAY FROM (tx.action_date - em.signup_date)) AS "days_between"
FROM emails em
JOIN texts tx ON em.email_id = tx.email_id
) AS action_date
WHERE days_between > 0 AND days_between < 2


/*
This was a challenging problem but I learned a a lot
Ok so the goal was to have two tables where one was of employee queries and the other
employee info and you had to count the number of employees for bins of unique queriers (historgram)
first you had to left join the queries table to employees but first filter the table to only have queries from
certain dates then turn that into a temperary table
then you need to make another subtable counting the number of employee id occurences in that previous tables
Then count those count categories (I know so annoying)
Then count the zeros
Then merge it all together
Pretty sure this is the straight up least optimal way to do this but I learned about temporary tables
and filtering a table before joining which is neat
*/

WITH temp_table AS (
SELECT q.employee_id
FROM employees e
LEFT JOIN queries q ON e.employee_id = q.employee_id
AND q.query_starttime > '07/01/2023'
AND q.query_starttime < '10/01/2023'
),

temp1_table AS (
SELECT COUNT(employee_id)
FROM temp_table
WHERE employee_id IS NOT NULL
GROUP BY employee_id
),

non_zero_count AS (
SELECT count AS unique_queries, COUNT(count) AS employee_count
FROM temp1_table
GROUP BY count
),

zero_count AS (
SELECT 0 AS unique_queries, SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS employee_count
FROM temp_table
)

SELECT * FROM non_zero_count
UNION ALL
SELECT * FROM zero_count
ORDER BY unique_queries

-- This is the optimal solution

WITH query_counts AS (
  SELECT
    e.employee_id,
    COUNT(DISTINCT q.query_id) AS unique_queries
  FROM employees e
  LEFT JOIN queries q
    ON e.employee_id = q.employee_id
    AND q.query_starttime >= '2023-07-01'
    AND q.query_starttime <  '2023-10-01'
  GROUP BY e.employee_id
)

SELECT
  unique_queries,
  COUNT(*) AS employee_count
FROM query_counts
GROUP BY unique_queries
ORDER BY unique_queries;


-- finds the difference between the max and min issued amount for cards

SELECT card_name, MAX(issued_amount)  - MIN(issued_amount) AS diff
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY diff DESC;


-- gives mean from a table of occurances and number of items, learned integer truncates numbers and need numeric

SELECT ROUND(
(SUM((order_occurrences * item_count)) / SUM(order_occurrences))::numeric, 1)
FROM items_per_order;

-- finds total profit (sales - cost), sorts and prints three highest

SELECT drug, (total_sales - cogs) AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC LIMIT 3;

-- Gets the count of lossing medications from manufacturers by absolute value and sorts

SELECT manufacturer, COUNT(drug), ABS(SUM((total_sales - cogs))) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;


-- gets percentages of time spent opening and sending by age buckets

SELECT
ROUND(
(SUM(CASE WHEN av.activity_type = 'open' THEN time_spent ELSE 0 END) / (SUM(CASE WHEN av.activity_type = 'send' THEN time_spent ELSE 0 END) + SUM(CASE WHEN av.activity_type = 'open' THEN time_spent ELSE 0 END)) * 100),
2) AS open_perc,
ROUND(
(SUM(CASE WHEN av.activity_type = 'send' THEN time_spent ELSE 0 END) / (SUM(CASE WHEN av.activity_type = 'send' THEN time_spent ELSE 0 END) + SUM(CASE WHEN av.activity_type = 'open' THEN time_spent ELSE 0 END)) * 100),
2) AS send_perc,
ab.age_bucket
age_bucket
FROM activities av
LEFT JOIN age_breakdown ab ON ab.user_id = av.user_id
GROUP BY ab.age_bucket


/*
sums sales by manufacturer and rounds to millions. concat is a way to add strings to output
can still sort the alias column but using the orginal aggregate SUM(total_sales)
*/

SELECT manufacturer, CONCAT('$', ROUND(SUM(total_sales/1000000), 0), ' million') AS summed_sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC;


-- find the total number of policy holders who called more than three times

SELECT COUNT(policy_holder_id)
FROM (
SELECT policy_holder_id, COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
) AS call_summary

/*
this gets the highest grossing products on Amazon for 2022 by category and product
it then ranks these based on the total sum
then query this subquery to get only the top 2 ranks
*/

SELECT category, product, sum
FROM (
SELECT category, product, SUM(spend),
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) as rnk
FROM product_spend
WHERE transaction_date >= '01/01/2022' AND transaction_date <= '12/31/2022'
GROUP BY category, product
ORDER BY category, SUM(spend) DESC
) AS tmp_data
WHERE rnk <= 2

/*
This gets top three salaries for each department
learned that RANK will treat tie counting as 1, 2, 2, 4
where DENSE_RANK will treat tie counting as 1, 2, 2, 3
so in this case I wanted DENSE_RANK
*/

SELECT department_name, name, salary
FROM (
SELECT name, salary, department_name,
DENSE_RANK () OVER (PARTITION BY department_name ORDER BY salary DESC) as rnk
FROM employee e
LEFT JOIN department d ON e.department_id = d.department_id
ORDER BY department_name, salary DESC, name
) tmp_table
WHERE rnk <= 3

-- count activation rates and get activation rate afte removing null

SELECT ROUND(COUNT( CASE WHEN signup_action = 'Confirmed' THEN 1 END )::NUMERIC / COUNT(signup_action)::NUMERIC, 2) as confirm_rate
FROM (
SELECT signup_action
FROM emails e
LEFT JOIN texts t ON e.email_id = t.email_id
WHERE signup_action IS NOT NULL
) tmp_table

/*
This finds the customer who purchased the most product categories
I learned you can do a count function in ORDER BY to prevent the count column from showing up in the output! Neat!
*/

SELECT customer_id
FROM customer_contracts cc
LEFT JOIN products p ON cc.product_id = p.product_id
GROUP BY customer_id
ORDER BY COUNT(DISTINCT product_category) DESC
LIMIT 1;

/*
this SQL query does a cumulative count grouped by day for measurments
then uses a subquery to sum odd and even measurments
learned date_trunc which was helpful
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW is used for cumulative counts
*/

SELECT DATE_TRUNC('day', measurement_time) AS measurement_day,
SUM(CASE WHEN cumulative_count % 2 != 0 THEN measurement_value ELSE 0 END) AS odd_sum,
SUM(CASE WHEN cumulative_count % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM (
SELECT COUNT (*) OVER (PARTITION BY EXTRACT( DAY FROM measurement_time) ORDER BY EXTRACT( DAY FROM measurement_time), EXTRACT( HOUR FROM measurement_time) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count,
measurement_id, measurement_value, measurement_time
FROM measurements
ORDER BY EXTRACT( DAY FROM measurement_time), EXTRACT( HOUR FROM measurement_time)
) tmp_table
GROUP BY measurement_day
ORDER BY measurement_day

/*
for this there were two columns where the order IDs were switched with the first and second order.
So for even numbers you needed to minus 1 and odd you needed to add 1.
But the the final order needed to be skipped
learned that in case when then, if there are overlaps the order of when statements take predcent
for MAX OVER() is required because its an aggregate function and OVER() will just give the max of all rows
*/

SELECT CASE
WHEN order_id = MAX(order_id) OVER() THEN order_id
WHEN order_id % 2 != 0 THEN order_id + 1
WHEN order_id % 2 = 0 THEN order_id - 1 END AS fixed, item
FROM orders
ORDER BY fixed

/*
Ok this was a bit tricky. First I went through a labeled the max and min for each ticker
Then I used these MAX() statements which collapses the values down into a single non-null (min would have done the same)
in PostgreSQL converting dates is done with TO_CHAR(date, 'Mon-YYYY')
*/

SELECT ticker,
MAX(CASE WHEN min_max = 'max_month' THEN TO_CHAR(date, 'Mon-YYYY') END) AS highest_mth,
MAX(CASE WHEN min_max = 'max_month' THEN open END) AS highest_open,
MAX(CASE WHEN min_max = 'min_month' THEN TO_CHAR(date, 'Mon-YYYY') END) AS lowest_mth,
MAX(CASE WHEN min_max = 'min_month' THEN open END) AS lowest_open
FROM (
SELECT ticker, open, date,
CASE
WHEN open = MAX(open) OVER(PARTITION BY ticker) THEN 'max_month'
WHEN open = MIN(open) OVER(PARTITION BY ticker) THEN 'min_month'
ELSE NULL END AS min_max
FROM stock_prices
) tmp_table
WHERE min_max IS NOT NULL
GROUP BY ticker

/*
for this you needed to identify users who went on a shopping spree which is shopping three days in a row
to do it you needed to do repeated inner joins on the same table on dates where the original date = date + 1 or + 2
*/

SELECT DISTINCT T1.user_id
FROM transactions T1
INNER JOIN transactions T2 ON DATE(T2.transaction_date) = DATE(T1.transaction_date) + 1
INNER JOIN transactions T3 ON DATE(T3.transaction_date) = DATE(T1.transaction_date) + 2
ORDER BY T1.user_id
