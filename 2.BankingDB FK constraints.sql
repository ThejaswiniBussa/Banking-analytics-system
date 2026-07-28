
USE BANKINGDB;

-- Validating foreign keys and then adding FK constraints

-- ACCOUNTS TO CUSTOMERS FK VALIDATION
SELECT a.customer_id
FROM Accounts a
LEFT JOIN Customers c
ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Cards TO Accounts
SELECT c.account_id
FROM Cards c
LEFT JOIN Accounts a
ON c.account_id = a.account_id
WHERE c.account_id IS NOT NULL
  AND a.account_id IS NULL;

-- Transactions TO Accounts (account_id)
SELECT t.account_id
FROM Transactions t
LEFT JOIN Accounts a
ON t.account_id = a.account_id
WHERE t.account_id IS NOT NULL
  AND a.account_id IS NULL;

-- Transactions → Merchants (merchant_id)
SELECT t.merchant_id
FROM Transactions t
LEFT JOIN Merchants m
ON t.merchant_id = m.merchant_id
WHERE t.merchant_id IS NOT NULL
  AND m.merchant_id IS NULL;

-- Loans → Customers (customer_id)
SELECT l.customer_id
FROM Loans l
LEFT JOIN Customers c
ON l.customer_id = c.customer_id
WHERE l.customer_id IS NOT NULL
  AND c.customer_id IS NULL;


/* ADDING FOREIGN KEY CONSTRAINTS*/

-- ACCOUNTS TO CUSTOMERS
ALTER TABLE Accounts
ADD CONSTRAINT fk_accounts_customer
FOREIGN KEY (customer_id)
REFERENCES Customers(customer_id);

-- CARDS TO ACCOUNTS
ALTER TABLE Cards
ADD CONSTRAINT fk_cards_account
FOREIGN KEY (account_id)
REFERENCES Accounts(account_id);

-- TRANSACTIONS TO ACCOUNTS
ALTER TABLE Transactions
ADD CONSTRAINT fk_transactions_account
FOREIGN KEY (account_id)
REFERENCES Accounts(account_id);

-- TRANSACTIONS TO MERCHNATS
ALTER TABLE Transactions
ADD CONSTRAINT fk_transactions_merchant
FOREIGN KEY (merchant_id)
REFERENCES Merchants(merchant_id);

-- LOANS TO CUSTOMERS
ALTER TABLE Loans
ADD CONSTRAINT fk_loans_customer
FOREIGN KEY (customer_id)
REFERENCES Customers(customer_id);

-- RELATIONSHIP CHECKS
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'BankingDB'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

