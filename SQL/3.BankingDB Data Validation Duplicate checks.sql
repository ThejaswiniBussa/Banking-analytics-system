use bankingDB;

/* Verify record count */

SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM merchants;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM cards;
SELECT COUNT(*) FROM Branches;

/* Duplicate Primary keys check */

-- Customers
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Accounts
SELECT account_id, COUNT(*)
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

-- Transactions
SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Merchants
SELECT merchant_id, COUNT(*)
FROM merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;

-- Cards
SELECT card_id, COUNT(*)
FROM cards
GROUP BY card_id
HAVING COUNT(*) > 1;

-- Branches
SELECT branch_id, COUNT(*)
FROM branches
GROUP BY branch_id
HAVING COUNT(*) > 1; 

-- loans
SELECT loan_id, COUNT(*)
FROM Loans
GROUP BY loan_id
HAVING COUNT(*) > 1;




