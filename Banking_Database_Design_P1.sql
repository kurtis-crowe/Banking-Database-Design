--Creating ENUM as only selected cities can be in branch_city
CREATE TYPE city_enum AS ENUM ('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers');


--using the CHECK constraint to specify that assets can not be negative and utilizing money data type for monetary format
CREATE TABLE branch (
	branch_name varchar(40) PRIMARY KEY,
	branch_city city_enum NOT NULL,
	assets money CHECK (assets::numeric >= 0)
);

--utilizing NOT NULL for name/street as these values have to be inputted
CREATE TABLE customer(
	cust_ID varchar(40) PRIMARY KEY,
	customer_name varchar(40) NOT NULL,
	customer_street varchar(40) NOT NULL,
	customer_city varchar(40)
);

--utilizing CASCADE to define that if something changes/deletes in branch table, it will also update in this table
--utilizing DEFAULT constraint to ensure that $0 is set if no input were provided.
--utilizing CHECK constraint to ensure no values are below 0
CREATE TABLE loan(
	loan_number varchar(40) PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch(branch_name) ON UPDATE CASCADE ON DELETE CASCADE,
	amount money DEFAULT '$0.00' CHECK (amount::numeric >= 0.00)
);


--creating a composite primary key for our 'Many-to-Many Relationship'
CREATE TABLE borrower(
	cust_ID varchar(40) REFERENCES customer(cust_ID) ON UPDATE CASCADE ON DELETE CASCADE,
	loan_number varchar(40) REFERENCES loan(loan_number) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(cust_ID, loan_number)

);

--creating branch_name that is updated/deleted when branch(branch_name) is
--creating default value for balance as $0.00 (Note: instructions did not ask to check for negatives)
CREATE TABLE account(
	account_number varchar(40) PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch(branch_name) ON UPDATE CASCADE ON DELETE CASCADE,
	balance money DEFAULT '$0.00'
);

--creating a composite primary key for our 'Many-to-Many Relationship'
CREATE TABLE Depositor(
	cust_ID varchar(40) REFERENCES customer(cust_ID) ON UPDATE CASCADE ON DELETE CASCADE,
	account_number varchar(40) REFERENCES account(account_number) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(cust_ID, account_number)
);