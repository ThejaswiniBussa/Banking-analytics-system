CREATE DATABASE BankingDB;

USE BankingDB;

CREATE TABLE Accounts (
    account_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20),
    account_type VARCHAR(30),
    balance_usd DECIMAL(15,2),
    open_date DATE,
    PRIMARY KEY (account_id)
);

CREATE TABLE Branches (
  branch_id VARCHAR(20) NOT NULL,
  branch_name VARCHAR(100),
  manager_name VARCHAR(100),
  PRIMARY KEY (branch_id)
);

CREATE TABLE Cards (
  card_id varchar(20) NOT NULL,
  account_id varchar(20),
  card_type varchar(20),
  expiration_date date,
  PRIMARY KEY (card_id)
);


CREATE TABLE Customers (
  customer_id varchar(20) NOT NULL,
  first_name varchar(50),
  last_name varchar(50),
  email varchar(100),
  city varchar(50),
  credit_score int,
  created_at date,
  PRIMARY KEY (customer_id)
);


CREATE TABLE Loans (
  loan_id varchar(20) NOT NULL,
  customer_id varchar(20),
  loan_amount decimal(15,2),
  interest_rate decimal(5,2),
  start_date date,
  PRIMARY KEY (loan_id)
);

CREATE TABLE Merchants (
  merchant_id varchar(20) NOT NULL,
  merchant_name varchar(100),
  city varchar(100),
  PRIMARY KEY (merchant_id)
);

CREATE TABLE Transactions (
  transaction_id varchar(20),
  account_id varchar(20),
  merchant_id varchar(20),
  amount_usd decimal(15,2),
  transaction_date timestamp,
  PRIMARY KEY (transaction_id)
);




Show create table Transactions;
