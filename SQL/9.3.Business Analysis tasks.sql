use BankingDB;


/*-----------------------------------------------------------------------
*
*
*Task 16 – Merchant Revenue Contribution Analysis
*
*
------------------------------------------------------------------------*/

-- 1.Total Transaction Value per Merchant

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
ORDER BY total_transaction_value DESC;

-- 2. Average Transaction Size per Merchant

SELECT
    m.merchant_id,
    m.merchant_name,
    ROUND(AVG(t.amount_usd),2) AS average_transaction_size
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY average_transaction_size DESC;

-- 3. Top 20 Merchants

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
LIMIT 20;

-- 4. Bottom Performing Merchants

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
ORDER BY total_transaction_value ASC
LIMIT 10;

-- 5.Percentage Contribution of Each Merchant

SELECT
    m.merchant_id,
    m.merchant_name,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value,
    ROUND(
        (SUM(t.amount_usd) /
        (SELECT SUM(amount_usd) FROM Transactions)) * 100,
        4
    ) AS contribution_percentage
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transaction_value DESC
LIMIT 20;

/*-----------------------------------------------------------------------
*
*
*Task 17 – Card Usage Portfolio Analysis
*
*
------------------------------------------------------------------------*/

-- 1.Card Type Distribution

SELECT
    card_type,
    COUNT(card_id) AS total_cards
FROM Cards
GROUP BY card_type
ORDER BY total_cards DESC;

-- 2. Accounts with Multiple Cards

SELECT
    account_id,
    COUNT(card_id) AS total_cards
FROM Cards
GROUP BY account_id
HAVING COUNT(card_id) > 1
ORDER BY total_cards DESC, account_id;

-- 3.Card Issuance Trend (Based on Expiration Year)

SELECT
    YEAR(expiration_date) AS expiration_year,
    COUNT(card_id) AS total_cards
FROM Cards
GROUP BY YEAR(expiration_date)
ORDER BY expiration_year;

-- 4.Customer Card Ownership

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(cd.card_id) AS total_cards
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Cards cd
    ON a.account_id = cd.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_cards DESC
LIMIT 10;


/*-----------------------------------------------------------------------
*
*
*Task 18 – Customer Credit Portfolio Analysis
*
*
------------------------------------------------------------------------*/


-- 1.Credit Score Segmentation

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

-- 2.Average Account Balance by Credit Score

SELECT
    CASE
        WHEN c.credit_score >= 750 THEN 'Excellent'
        WHEN c.credit_score BETWEEN 700 AND 749 THEN 'Good'
        WHEN c.credit_score BETWEEN 650 AND 699 THEN 'Fair'
        WHEN c.credit_score BETWEEN 600 AND 649 THEN 'Poor'
        ELSE 'Very Poor'
    END AS credit_segment,
    ROUND(AVG(a.balance_usd),2) AS average_account_balance
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
GROUP BY credit_segment
ORDER BY average_account_balance DESC;

-- 3.Average Loan Amount by Credit Score

SELECT
    CASE
        WHEN c.credit_score >= 750 THEN 'Excellent'
        WHEN c.credit_score BETWEEN 700 AND 749 THEN 'Good'
        WHEN c.credit_score BETWEEN 650 AND 699 THEN 'Fair'
        WHEN c.credit_score BETWEEN 600 AND 649 THEN 'Poor'
        ELSE 'Very Poor'
    END AS credit_segment,
    ROUND(AVG(l.loan_amount),2) AS average_loan_amount
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY credit_segment
ORDER BY average_loan_amount DESC;

-- 4.Customer Distribution Across Credit Score Categories

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
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customers),
        2
    ) AS percentage
FROM Customers
GROUP BY credit_segment
ORDER BY total_customers DESC;

/*-----------------------------------------------------------------------
*
*
*Task 19 – Executive Banking Performance Summary
*
*
------------------------------------------------------------------------*/

-- 1.Executive KPI Summary

SELECT
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Accounts) AS Total_Accounts,
    (SELECT COUNT(*) FROM Transactions) AS Total_Transactions,
    (SELECT ROUND(SUM(balance_usd),2) FROM Accounts) AS Total_Account_Balance,
    (SELECT ROUND(SUM(loan_amount),2) FROM Loans) AS Total_Loan_Amount,
    (SELECT ROUND(AVG(credit_score),2) FROM Customers) AS Average_Credit_Score;

-- 2.Top Customers (Top 10 by Account Balance)

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

-- 3.Top Merchants (Top 10 by Transaction Value)

SELECT
    m.merchant_name,m.merchant_id,
    ROUND(SUM(t.amount_usd),2) AS total_transaction_value
FROM Merchants m
INNER JOIN Transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_name,
    m.merchant_id
ORDER BY total_transaction_value DESC
LIMIT 10;

use bankingdb;

SELECT COUNT(distinct merchant_name) from Merchants;
