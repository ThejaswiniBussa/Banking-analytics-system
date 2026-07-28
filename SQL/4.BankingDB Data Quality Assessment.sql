use BankingDB;

-- CUSTOMERS

-- MISSING EMAILS
SELECT *
FROM Customers
WHERE email IS NULL
OR email='';

-- INVALID EMAILS
SELECT *
FROM Customers
WHERE email NOT LIKE '%@%.%';

-- MISSING CITY
SELECT *
FROM Customers
WHERE city IS NULL
OR city='';

-- INVALID CREDIT SCORE
SELECT *
FROM Customers
WHERE credit_score NOT BETWEEN 300 AND 850;

-- MISSING CREATED DATE
SELECT *
FROM Customers
WHERE created_at IS NULL;

-- ----------------------
/* ACCOUNTS */

-- MISSING ACCOUNT TYPE
SELECT *
FROM Accounts
WHERE account_type IS NULL
OR account_type='';

-- NEGATIVE BALANCE
SELECT *
FROM Accounts
WHERE balance_usd<0;

-- MISSING OPEN DATE
SELECT *
FROM Accounts
WHERE open_date IS NULL;

-- ---------------------------
/*CARDS*/

-- MISSING CARD TYPE
SELECT *
FROM Cards
WHERE card_type IS NULL
OR card_type='';

-- MISSING EXPIRY DATE
SELECT *
FROM Cards
WHERE expiration_date IS NULL;

-- ---------------------------

/*MERCHANTS*/

-- MISSING MERCHANT NAME
SELECT *
FROM Merchants
WHERE merchant_name IS NULL
OR merchant_name='';

-- MISSING CITY
SELECT *
FROM Merchants
WHERE city IS NULL
OR city='';

-- -------------------------

/* LOANS */

-- INVALID LOAN AMOUNT
SELECT *
FROM Loans
WHERE loan_amount<=0;

-- INVALID INTEREST RATE 
SELECT *
FROM Loans
WHERE interest_rate<0
OR interest_rate>100;

-- MISSING START DATE
SELECT *
FROM Loans
WHERE start_date IS NULL;

-- -------------------------

/* TRANSACTIONS */

-- INVALID TRANSACTION AMOUNT
SELECT *
FROM Transactions
WHERE amount_usd<=0;

-- MISSING TRANSACTION DATE
SELECT *
FROM Transactions
WHERE transaction_date IS NULL;

