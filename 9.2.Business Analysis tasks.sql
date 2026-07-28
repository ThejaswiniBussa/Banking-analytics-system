use bankingdb;

/*-------------------------------------------------------------------------
*
*
Task 9 – Loan Portfolio Analysis
*
*
--------------------------------------------------------------------------*/

-- 1.Total Loan Amount

SELECT
    ROUND(SUM(loan_amount),2) AS total_loan_amount
FROM Loans;


-- 2.Average Loan Amount

SELECT
    ROUND(AVG(loan_amount),2) AS average_loan_amount
FROM Loans;


-- 3.Highest Loan Values

SELECT
    l.loan_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_amount
FROM Loans l
INNER JOIN Customers c
    ON l.customer_id = c.customer_id
ORDER BY l.loan_amount DESC
LIMIT 10;

-- 4.Average Interest Rate

SELECT
    ROUND(AVG(interest_rate),2) AS average_interest_rate
FROM Loans;

-- 5.Customer Loan Distribution

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount),2) AS total_loan_amount
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_loan_amount DESC
LIMIT 10;


/* ----------------------------------------------------------------------
*
*Task 10 – Card Portfolio Analysis
*
------------------------------------------------------------------------*/

-- 1.Total Cards Issued

SELECT COUNT(*) AS total_cards_issued
FROM Cards;

-- 2.Card Distribution by Type

SELECT
    card_type,
    COUNT(*) AS total_cards
FROM Cards
GROUP BY card_type
ORDER BY total_cards DESC;

-- 3. Card Expiration Trends

SELECT
    YEAR(expiration_date) AS expiration_year,
    COUNT(*) AS cards_expiring
FROM Cards
GROUP BY YEAR(expiration_date)
ORDER BY expiration_year;

-- 4.Accounts Owning Multiple Cards

SELECT
    account_id,
    COUNT(card_id) AS total_cards
FROM Cards
GROUP BY account_id
HAVING COUNT(card_id) > 1
ORDER BY total_cards DESC, account_id;


/* ----------------------------------------------------------------------
*
*Task 11 – Customer Loan Analysis
*
------------------------------------------------------------------------*/

-- 1. Customers Who Have Taken Loans

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(l.loan_id) AS total_loans
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_loans DESC
LIMIT 10;

-- 2. Average Loan Amount per Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(AVG(l.loan_amount),2) AS average_loan_amount
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY average_loan_amount DESC
LIMIT 10;

-- 3. Customers with Multiple Loans

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(l.loan_id) AS total_loans
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(l.loan_id) > 1
ORDER BY total_loans DESC
LIMIT 10;

-- 4. Highest Loan Amounts

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(l.loan_amount) AS highest_loan_amount
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY highest_loan_amount DESC
LIMIT 10;

-- 5. Loan Distribution Across Customer Cities

SELECT
    c.city,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount),2) AS total_loan_amount,
    ROUND(AVG(l.loan_amount),2) AS average_loan_amount
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY c.city
ORDER BY total_loan_amount DESC
LIMIT 10;

-- 6. Interest Rate Comparison Among Customers

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(AVG(l.interest_rate),2) AS average_interest_rate
FROM Customers c
INNER JOIN Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY average_interest_rate DESC
LIMIT 10;


/* ----------------------------------------------------------------------
*
*Task 12 – Customer Banking Relationship Analysis
*
------------------------------------------------------------------------*/

-- 1.Customers with Multiple Accounts

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(a.account_id) AS total_accounts
FROM Customers c
INNER JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY total_accounts DESC;

-- 2. Customers with Multiple Cards

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
HAVING COUNT(cd.card_id) > 1
ORDER BY total_cards DESC;

-- 3. Customers Having Both Accounts and Loans

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT a.account_id) AS accounts,
    COUNT(DISTINCT l.loan_id) AS loans
FROM Customers c
INNER JOIN Accounts a
ON c.customer_id = a.customer_id
INNER JOIN Loans l
ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY loans DESC, accounts DESC;



-- 4. Customer Banking Relationship Summary

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,

    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT cd.card_id) AS total_cards,

    CASE
        WHEN COUNT(DISTINCT l.loan_id) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_loan,

    ROUND(SUM(DISTINCT a.balance_usd),2) AS total_account_balance,

    ROUND(SUM(DISTINCT l.loan_amount),2) AS total_loan_amount

FROM Customers c

LEFT JOIN Accounts a
    ON c.customer_id = a.customer_id

LEFT JOIN Cards cd
    ON a.account_id = cd.account_id

LEFT JOIN Loans l
    ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY
    total_account_balance DESC;

-- 5. overall customer portfolio

SELECT
    customer_portfolio,
    COUNT(*) AS total_customers
FROM
(
    SELECT
        c.customer_id,
        CASE
            WHEN COUNT(DISTINCT a.account_id) > 0
             AND COUNT(DISTINCT l.loan_id) > 0
             AND COUNT(DISTINCT cd.card_id) > 0
                THEN 'Account + Loan + Card'

            WHEN COUNT(DISTINCT a.account_id) > 0
             AND COUNT(DISTINCT l.loan_id) > 0
                THEN 'Account + Loan'

            WHEN COUNT(DISTINCT a.account_id) > 0
             AND COUNT(DISTINCT cd.card_id) > 0
                THEN 'Account + Card'

            WHEN COUNT(DISTINCT a.account_id) > 0
                THEN 'Account Only'

            WHEN COUNT(DISTINCT l.loan_id) > 0
                THEN 'Loan Only'

            ELSE 'Other'
        END AS customer_portfolio
    FROM Customers c
    LEFT JOIN Accounts a
        ON c.customer_id = a.customer_id
    LEFT JOIN Cards cd
        ON a.account_id = cd.account_id
    LEFT JOIN Loans l
        ON c.customer_id = l.customer_id
    GROUP BY c.customer_id
) AS t
GROUP BY customer_portfolio
ORDER BY total_customers DESC;

/* ----------------------------------------------------------------------
*
*Task 13 – Transaction Trend Analysis
*
------------------------------------------------------------------------*/

-- 1. Monthly Transaction Trend

SELECT
    transaction_year,
    transaction_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM vw_transactions
GROUP BY
    transaction_year,
    transaction_month
ORDER BY
    transaction_year,
    transaction_month;

-- 2. Quarterly Transaction Trend

SELECT
    transaction_year,
    transaction_quarter,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value
FROM vw_transactions
GROUP BY
    transaction_year,
    transaction_quarter
ORDER BY
    transaction_year,
    transaction_quarter;

-- 3. Year-wise Transaction Comparison

SELECT
    transaction_year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd),2) AS total_transaction_value,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM vw_transactions
GROUP BY transaction_year
ORDER BY transaction_year;

-- 4. Peak Transaction Months

SELECT
    transaction_year,
    transaction_month,
    COUNT(*) AS total_transactions
FROM vw_transactions
GROUP BY
    transaction_year,
    transaction_month
ORDER BY total_transactions DESC
LIMIT 10;

-- 5. Lowest Transaction Months

SELECT
    transaction_year,
    transaction_month,
    COUNT(*) AS total_transactions
FROM vw_transactions
GROUP BY
    transaction_year,
    transaction_month
ORDER BY total_transactions ASC
LIMIT 10;

-- 6. Average Monthly Transaction Value

SELECT
    transaction_year,
    transaction_month,
    ROUND(AVG(amount_usd),2) AS average_transaction_value
FROM vw_transactions
GROUP BY
    transaction_year,
    transaction_month
ORDER BY
    transaction_year,
    transaction_month;

/*-------------------------------------------------------------------------
*
*
TASK 14 – CUSTOMER LIFETIME TRANSACTION VALUE
*
*
--------------------------------------------------------------------------*/

-- 1.Top Customers by Total Transaction Value

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS lifetime_transaction_value
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY lifetime_transaction_value DESC
LIMIT 10;

-- 2. Average Lifetime Transaction Value

SELECT
    ROUND(AVG(customer_total),2) AS average_lifetime_transaction_value
FROM
(
    SELECT
        a.customer_id,
        SUM(t.amount_usd) AS customer_total
    FROM Accounts a
    INNER JOIN Transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
) AS customer_totals;

-- 3. Highest Spending Customers

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS total_spent
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Customer Transaction Ranking

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS lifetime_transaction_value,
    DENSE_RANK() OVER (
        ORDER BY SUM(t.amount_usd) DESC
    ) AS customer_rank
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY customer_rank
LIMIT 10;

-- 5.Percentage Contribution of Top Customers

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(t.amount_usd),2) AS lifetime_transaction_value,
    ROUND(
        (SUM(t.amount_usd) /
        (SELECT SUM(amount_usd) FROM Transactions)) * 100,
        4
    ) AS contribution_percentage
FROM Customers c
INNER JOIN Accounts a
    ON c.customer_id = a.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY lifetime_transaction_value DESC
LIMIT 10;


/*-------------------------------------------------------------------------
*
*
15 – Account Type Performance Analysis
*
*
--------------------------------------------------------------------------*/

-- 1. Number of Accounts by Account Type

SELECT
    account_type,
    COUNT(account_id) AS total_accounts
FROM Accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

-- 2. Total Account Balances by Account Type

SELECT
    account_type,
    ROUND(SUM(balance_usd),2) AS total_balance
FROM Accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- 3. Average Account Balance by Account Type

SELECT
    account_type,
    ROUND(AVG(balance_usd),2) AS average_balance
FROM Accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- 4. Average Transaction Value by Account Type

SELECT
    a.account_type,
    ROUND(AVG(t.amount_usd),2) AS average_transaction_value
FROM Accounts a
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY average_transaction_value DESC;

-- 5. Transaction Frequency by Account Type

SELECT
    a.account_type,
    COUNT(t.transaction_id) AS total_transactions
FROM Accounts a
INNER JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY total_transactions DESC;
