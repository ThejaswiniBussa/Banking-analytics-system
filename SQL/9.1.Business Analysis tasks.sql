/*-----------------------------------------------------------
 * 
 * Task 1 – Customer Portfolio Analysis
 * 
 * 
 ----------------------------------------------------------*/

-- 1. Total Customers

use bankingDB;

SELECT COUNT(*) AS total_customers
FROM Customers;


-- 2.Customer Registrations by Year

SELECT
    YEAR(created_at) AS registration_year,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY YEAR(created_at)
ORDER BY registration_year;


-- 3. Customer Registrations by Month

SELECT
    YEAR(created_at) AS registration_year,
    MONTH(created_at) AS registration_month,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY
    YEAR(created_at),
    MONTH(created_at)
ORDER BY
    registration_year,
    registration_month;


-- 4. Customer Registrations by Quarter

SELECT
    YEAR(created_at) AS registration_year,
    QUARTER(created_at) AS registration_quarter,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY
    YEAR(created_at),
    QUARTER(created_at)
ORDER BY
    registration_year,
    registration_quarter;


-- 5. Customers by City

SELECT
    city,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY city
ORDER BY total_customers DESC;


-- 6. Top 10 Cities by Customer Count

SELECT
    city,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY city
ORDER BY total_customers DESC
LIMIT 10;


-- 7. Customer Growth Trend (Cumulative)

SELECT
    registration_year,
    customers_registered,
    SUM(customers_registered)
        OVER (ORDER BY registration_year) AS cumulative_customers
FROM
(
    SELECT
        YEAR(created_at) AS registration_year,
        COUNT(*) AS customers_registered
    FROM Customers
    GROUP BY YEAR(created_at)
) AS yearly_customers;


-- 8. Year-over-Year Customer Growth

SELECT
    registration_year,
    customers_registered,
    customers_registered -
    LAG(customers_registered)
    OVER (ORDER BY registration_year) AS yearly_growth
FROM
(
    SELECT
        YEAR(created_at) AS registration_year,
        COUNT(*) AS customers_registered
    FROM Customers
    GROUP BY YEAR(created_at)
) AS yearly_customers;


-- 9. Average Customers Registered Per Year

SELECT
    ROUND(AVG(customers_registered),2) AS avg_customers_per_year
FROM
(
    SELECT
        YEAR(created_at) AS registration_year,
        COUNT(*) AS customers_registered
    FROM Customers
    GROUP BY YEAR(created_at)
) AS yearly_customers;

/*-----------------------------------------------------------------------------------------

Task 2 – Credit Score Analysis

------------------------------------------------------------------------------------------*/
-- 1. Average Credit Score

SELECT
    ROUND(AVG(credit_score),2) AS average_credit_score
FROM Customers;

-- 2. Highest Credit Score

SELECT
    MAX(credit_score) AS highest_credit_score
FROM Customers;

-- 3. Lowest Credit Score

SELECT
    MIN(credit_score) AS lowest_credit_score
FROM Customers;

-- 4. Customers with Highest Credit Score

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    credit_score
FROM Customers
WHERE credit_score =
(
    SELECT MAX(credit_score)
    FROM Customers
);

-- 5. Customers with Lowest Credit Score

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    credit_score
FROM Customers
WHERE credit_score =
(
    SELECT MIN(credit_score)
    FROM Customers
);

-- 6. Credit Score Segmentation

SELECT
CASE
    WHEN credit_score >= 750 THEN 'Excellent'
    WHEN credit_score BETWEEN 700 AND 749 THEN 'Good'
    WHEN credit_score BETWEEN 650 AND 699 THEN 'Fair'
    WHEN credit_score BETWEEN 600 AND 649 THEN 'Poor'
    ELSE 'Very Poor'
END AS credit_segment,
COUNT(*) AS total_customers
FROM Customers
GROUP BY credit_segment
ORDER BY total_customers DESC;

-- 7. Percentage Distribution of Credit Segments

SELECT
CASE
    WHEN credit_score >= 750 THEN 'Excellent'
    WHEN credit_score BETWEEN 700 AND 749 THEN 'Good'
    WHEN credit_score BETWEEN 650 AND 699 THEN 'Fair'
    WHEN credit_score BETWEEN 600 AND 649 THEN 'Poor'
    ELSE 'Very Poor'
END AS credit_segment,

COUNT(*) AS total_customers,

ROUND(
COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM Customers),
2
) AS percentage
FROM Customers
GROUP BY credit_segment
ORDER BY percentage DESC;

-- 8. Average Credit Score by City

SELECT
    city,
    ROUND(AVG(credit_score),2) AS average_credit_score,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY city
ORDER BY average_credit_score DESC;

-- 9. Credit Score Statistics

SELECT
    COUNT(*) AS total_customers,
    MIN(credit_score) AS minimum_score,
    MAX(credit_score) AS maximum_score,
    ROUND(AVG(credit_score),2) AS average_score
FROM Customers;


-- 10. Rank Customers by Credit Score

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    credit_score,
    DENSE_RANK() OVER (ORDER BY credit_score DESC) AS credit_rank
FROM Customers;


-- 11. Top 10 Customers by Credit Score

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    credit_score
FROM Customers
ORDER BY credit_score DESC
LIMIT 10;

-- 12. Bottom 10 Customers by Credit Score

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    credit_score
FROM Customers
ORDER BY credit_score ASC
LIMIT 10;

/*--------------------------------------------------------------------------------------------------
 * 
 * Task 3 – Account Performance Analysis
 * 
 * ------------------------------------------------------------------------------------------------*/

-- 1. Total Accounts

SELECT COUNT(*) AS total_accounts
FROM Accounts;

-- 2. Account Type Distribution

SELECT
    account_type,
    COUNT(*) AS total_accounts
FROM Accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

-- 3. Percentage Distribution by Account Type

SELECT
    account_type,
    COUNT(*) AS total_accounts,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Accounts),
        2
    ) AS percentage
FROM Accounts
GROUP BY account_type
ORDER BY percentage DESC;

-- 4. Average Account Balance

SELECT
    ROUND(AVG(balance_usd),2) AS average_balance
FROM Accounts;

-- 5. Total Account Balance

SELECT
    ROUND(SUM(balance_usd),2) AS total_balance
FROM Accounts;

-- 6. Minimum, Maximum & Average Balance

SELECT
    MIN(balance_usd) AS minimum_balance,
    MAX(balance_usd) AS maximum_balance,
    ROUND(AVG(balance_usd),2) AS average_balance
FROM Accounts;


-- 7. Highest Balance Accounts (Top 10)

SELECT
    account_id,
    customer_id,
    account_type,
    balance_usd
FROM Accounts
ORDER BY CAST(balance_usd AS DECIMAL(15,2)) DESC
LIMIT 10;

-- 8. Lowest Balance Accounts (Bottom 10)

SELECT
    account_id,
    customer_id,
    account_type,
    balance_usd
FROM Accounts
ORDER BY balance_usd
LIMIT 10;

-- 9. Average Balance by Account Type

SELECT
    account_type,
    COUNT(*) AS total_accounts,
    ROUND(AVG(balance_usd),2) AS average_balance,
    ROUND(SUM(balance_usd),2) AS total_balance
FROM Accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- 10. Rank Accounts by Balance

SELECT
    account_id,
    customer_id,
    account_type,
    balance_usd,
    DENSE_RANK() OVER
    (
        ORDER BY balance_usd DESC
    ) AS balance_rank
FROM Accounts;


-- 11. Running Total of Bank Deposits

SELECT
    account_id,
    balance_usd,
    SUM(balance_usd)
    OVER(
        ORDER BY balance_usd DESC
    ) AS running_total_balance
FROM Accounts;


-- 12. Accounts Above Average Balance

SELECT
    account_id,
    customer_id,
    account_type,
    balance_usd
FROM Accounts
WHERE balance_usd >
(
    SELECT AVG(balance_usd)
    FROM Accounts
)
ORDER BY balance_usd DESC;

-- 13. Customers Having More Than One Account

SELECT
    customer_id,
    COUNT(account_id) AS total_accounts
FROM Accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1
ORDER BY total_accounts DESC;


-- 14. Account Opening Trend

SELECT
    YEAR(open_date) AS opening_year,
    COUNT(*) AS total_accounts
FROM Accounts
GROUP BY YEAR(open_date)
ORDER BY opening_year;


-- 15. Monthly Account Openings

SELECT
    YEAR(open_date) AS opening_year,
    MONTH(open_date) AS opening_month,
    COUNT(*) AS total_accounts
FROM Accounts
GROUP BY
    YEAR(open_date),
    MONTH(open_date)
ORDER BY
    opening_year,
    opening_month;



/*---------------------------------------------------------------------
 * 
 * 
Task 4 – Customer Balance Analysis
*
*
----------------------------------------------------------------------*/

-- 1. Customers with the Highest Total Balances

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(a.balance_usd),2) AS total_balance
FROM Customers c
INNER JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC
LIMIT 10;


-- 2. Top 10 Customers by Total Balance

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance_usd) AS total_balance
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC
LIMIT 10;

-- 3. Average Balance per Customer

SELECT
    ROUND(AVG(customer_balance),2) AS average_balance_per_customer
FROM
(
    SELECT
        customer_id,
        SUM(balance_usd) AS customer_balance
    FROM Accounts
    GROUP BY customer_id
) AS customer_balances;

-- 4. Customers Having Above Average Total Balance

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance_usd) AS total_balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(a.balance_usd) >
(
    SELECT AVG(balance_usd)
    FROM Accounts
)
ORDER BY total_balance DESC;

-- 5. Customer Balance Ranking

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance_usd) AS total_balance,
    DENSE_RANK() OVER
    (
        ORDER BY SUM(a.balance_usd) DESC
    ) AS customer_rank
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

-- 6. Running Total of Customer Balances

SELECT
    c.customer_id,
    c.first_name,
    SUM(a.balance_usd) AS total_balance,
    SUM(SUM(a.balance_usd))
        OVER(ORDER BY SUM(a.balance_usd) DESC)
        AS running_total
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name;

-- 7. Customers with More Than One Account

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance_usd) AS total_balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY total_accounts DESC;

-- 8. Customer Balance Category

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance_usd) AS total_balance,
    CASE
        WHEN SUM(a.balance_usd) >= 150000 THEN 'Premium'
        WHEN SUM(a.balance_usd) >= 100000 THEN 'Gold'
        WHEN SUM(a.balance_usd) >= 50000 THEN 'Silver'
        ELSE 'Standard'
    END AS balance_category
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC;


-- 9. Customer Portfolio Summary

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(a.account_id) AS total_accounts,
    ROUND(AVG(a.balance_usd),2) AS average_balance,
    SUM(a.balance_usd) AS total_balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC;

-- 10. Top 5 Customers in Each City

SELECT *
FROM
(
    SELECT
        c.city,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(a.balance_usd) AS total_balance,
        DENSE_RANK() OVER
        (
            PARTITION BY c.city
            ORDER BY SUM(a.balance_usd) DESC
        ) AS city_rank
    FROM Customers c
    JOIN Accounts a
    ON c.customer_id = a.customer_id
    GROUP BY
        c.city,
        c.customer_id,
        c.first_name,
        c.last_name
) ranked_customers
WHERE city_rank <= 5
ORDER BY city, city_rank;


use bankingdb;

/*------------------------------------------------------------------------
 * 
 * 
*   Task 5 – Transaction Performance Analysis
* 
* 
*------------------------------------------------------------------------*/

-- 1. Total Number of Transactions

SELECT COUNT(*) AS total_transactions
FROM Transactions;

-- 2. Total Transaction Value

SELECT
    ROUND(SUM(amount_usd),2) AS total_transaction_value
FROM Transactions;

-- 3. Average Transaction Amount

SELECT
    ROUND(AVG(amount_usd),2) AS average_transaction_amount
FROM Transactions;

-- 4. Transaction Statistics

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_value,
    ROUND(AVG(amount_usd),2) AS average_value,
    MIN(amount_usd) AS minimum_transaction,
    MAX(amount_usd) AS maximum_transaction
FROM Transactions;

-- 5. Daily Transaction Activity

SELECT
    DATE(transaction_date) AS transaction_day,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_value
FROM Transactions
GROUP BY DATE(transaction_date)
ORDER BY transaction_day;

-- 6. Monthly Transaction Trend

SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY
    transaction_year,
    transaction_month;

-- 7. Quarterly Transaction Trend

SELECT
    YEAR(transaction_date) AS transaction_year,
    QUARTER(transaction_date) AS transaction_quarter,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value
FROM Transactions
GROUP BY
    YEAR(transaction_date),
    QUARTER(transaction_date)
ORDER BY
    transaction_year,
    transaction_quarter;

-- 8. Yearly Transaction Trend

SELECT
    YEAR(transaction_date) AS transaction_year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM Transactions
GROUP BY YEAR(transaction_date)
ORDER BY transaction_year;

-- 9. Top 10 Highest Transactions

SELECT
    transaction_id,
    account_id,
    merchant_id,
    amount_usd,
    transaction_date
FROM Transactions
ORDER BY amount_usd DESC
LIMIT 10;

-- 10. Lowest 10 Transactions

SELECT
    transaction_id,
    account_id,
    merchant_id,
    amount_usd,
    transaction_date
FROM Transactions
ORDER BY amount_usd ASC
LIMIT 10;

-- 11. Running Transaction Value

SELECT
    transaction_date,
    amount_usd,
    SUM(amount_usd)
    OVER
    (
        ORDER BY transaction_date
    ) AS running_transaction_value
FROM Transactions;

-- 12. Monthly Running Total
 
SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    SUM(amount_usd) AS monthly_total,
    SUM(SUM(amount_usd))
    OVER
    (
        ORDER BY YEAR(transaction_date),
                 MONTH(transaction_date)
    ) AS cumulative_transaction_value
FROM Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date);

-- 13. Rank Months by Transaction Value

SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    DENSE_RANK()
    OVER
    (
        ORDER BY SUM(amount_usd) DESC
    ) AS monthly_rank
FROM Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date);

-- 14. Highest Transaction Day

SELECT
    DATE(transaction_date) AS transaction_day,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value
FROM Transactions
GROUP BY DATE(transaction_date)
ORDER BY total_transaction_value DESC
LIMIT 10;

-- 15. Average Daily Transaction Value

SELECT
    DATE(transaction_date) AS transaction_day,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM Transactions
GROUP BY DATE(transaction_date)
ORDER BY transaction_day;

-- 16. Transaction Activity by Weekday

SELECT
    DAYNAME(transaction_date) AS weekday,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM Transactions
GROUP BY DAYNAME(transaction_date)
ORDER BY FIELD(
    weekday,
    'Monday','Tuesday','Wednesday',
    'Thursday','Friday','Saturday','Sunday'
);



/*-----------------------------------------------------------------------
 * 
 * 
Task 6 – Customer Transaction Behaviour Analysis.
*
*
------------------------------------------------------------------------*/

-- 1.Total Transaction Value per Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_transaction_value DESC
LIMIT 10;

-- 2.Average Transaction Value per Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(AVG(t.amount_usd),2) AS average_transaction_value
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY average_transaction_value DESC
LIMIT 10;

-- 3.Number of Transactions Performed by Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS total_transactions
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_transactions DESC
LIMIT 10;


-- 4.Highest Spending Customers (Ranking)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS total_spent,
    DENSE_RANK() OVER (
        ORDER BY SUM(t.amount_usd) DESC
    ) AS spending_rank
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY spending_rank
LIMIT 10;

/*----------------------------------------------------------------------------------------------------
*
*
Task 7 – Merchant Performance Analysis
*
*
----------------------------------------------------------------------------------------------------*/

-- 1.Total Transactions Received by Each Merchant

SELECT
    m.merchant_id,
    m.merchant_name,
    COUNT(t.transaction_id) AS total_transactions
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transactions DESC
LIMIT 10;

-- 2.Total Transaction Value by Merchant

SELECT
    m.merchant_id,
    m.merchant_name,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transaction_value DESC
LIMIT 10;

-- 3.Average Transaction Value by Merchant

SELECT
    m.merchant_id,
    m.merchant_name,
    ROUND(AVG(t.amount_usd),2) AS average_transaction_value
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY average_transaction_value DESC
LIMIT 10;


-- 4. Top-Performing Merchants

SELECT
    m.merchant_id,
    m.merchant_name,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transaction_value DESC
LIMIT 10;

-- 5.Merchant Ranking

SELECT
    m.merchant_id,
    m.merchant_name,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value,
    DENSE_RANK() OVER (
        ORDER BY SUM(t.amount_usd) DESC
    ) AS merchant_rank
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY merchant_rank
LIMIT 10;


/*----------------------------------------------------------------------------
*
*
Task 8 – Merchant City Analysis
*
*
-----------------------------------------------------------------------------*/

-- 1. Merchant Distribution by City

SELECT
    city,
    COUNT(*) AS total_merchants
FROM Merchants
GROUP BY city
ORDER BY total_merchants DESC;

-- 2. Cities with the Highest Merchant Presence

SELECT
    city,
    COUNT(*) AS total_merchants
FROM Merchants
GROUP BY city
ORDER BY total_merchants DESC
LIMIT 10;


-- 3.Average Transaction Value by Merchant City

SELECT
    m.city,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value,
    ROUND(AVG(t.amount_usd),2) AS average_transaction_value
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.city
ORDER BY average_transaction_value DESC;
