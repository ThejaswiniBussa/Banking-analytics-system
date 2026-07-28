use BankingDB;

-- CUSTOMER LEVEL

CREATE VIEW vw_customers AS
SELECT *,
YEAR(created_at) AS Registration_Year,
MONTH(created_at) AS Registration_Month
FROM Customers;

-- ACCOUNT LEVEL
CREATE VIEW vw_accounts AS
SELECT *,
YEAR(open_date) AS Opening_Year,
MONTH(open_date) AS Opening_Month
FROM Accounts;

-- TRANSACTION LEVEL
CREATE VIEW vw_transactions AS
SELECT *,
YEAR(transaction_date) AS Transaction_Year,
QUARTER(transaction_date) AS Transaction_Quarter,
MONTH(transaction_date) AS Transaction_Month,
DAY(transaction_date) AS Transaction_Day,
DAYNAME(transaction_date) AS Transaction_Weekday
FROM Transactions;

-- LOAN LEVEL
CREATE VIEW vw_loans AS
SELECT *,
YEAR(start_date) AS Loan_Start_Year,
MONTH(start_date) AS Loan_Start_Month
FROM Loans;


SELECT * FROM vw_transactions;
SELECT * FROM vw_accounts;
SELECT * FROM vw_customers;
SELECT * FROM vw_loans;
