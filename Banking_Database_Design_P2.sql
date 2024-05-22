-- DTSC660 --
-- Assignment 4 Part 2 --
--Kurtis Crowe--




--Query 1--
--find all customers who have at least one loan and one deposit account. Include cust_ID, account_number, and loan_number
--Some customers may appear multiple times due to having multiple loans or deposit accounts. Your solution must include a Join

SELECT bor.cust_ID,
	dep.account_number, 
	bor.loan_number
FROM borrower as bor
JOIN depositor as dep ON bor.cust_ID = dep.cust_ID

--Query 2--
--find all customers who have a deposit account in the same city they live
--city of a deposit account is city where its branch is located

SELECT dep.cust_id,
    cus.customer_city,
    bra.branch_city,
    bra.branch_name,
    dep.account_number
FROM depositor as dep
INNER JOIN customer as cus ON dep.cust_ID = cus.cust_ID
INNER JOIN account as acc ON dep.account_number = acc.account_number
INNER JOIN branch as bra ON acc.branch_name = bra.branch_name
WHERE cus.customer_city = bra.branch_city::varchar;



--Query 3--
--return cust_ID, customer_name customers who have 1 loan with bank but 0 deposit accounts
--include subquery and a SET operator

SELECT cust_ID,
	customer_name FROM customer
WHERE cust_ID IN(
SELECT DISTINCT cust_ID
FROM borrower
EXCEPT
SELECT DISTINCT cust_ID 
FROM depositor
);


--Query 4-- 
--Return cust_ID, customer_name all customers residing on the same street and in the same city as customer '12345'
SELECT cust_ID,
customer_name FROM customer
WHERE (customer_street, customer_city) IN (
SELECT customer_street, customer_city
FROM customer
WHERE cust_ID = '12345');




--Query 5--
--write a query to retrieve branch_names for every branch that has at least one customer living in harrison
--has a deposit account with them.
--branch names should not be duplicated
--include subquery and a join

SELECT DISTINCT bra.branch_name
FROM branch AS bra
JOIN account AS acc ON bra.branch_name = acc.branch_name
JOIN depositor AS dep ON acc.account_number = dep.account_number
JOIN customer AS cus ON dep.cust_ID = cus.cust_ID
WHERE bra.branch_name IN (
SELECT DISTINCT bra.branch_name WHERE cus.customer_city = 'Harrison');



--Query 6--
--write a query to return cust_ID/customer_name WHO HAS a deposit account at every branch @ Brooklyn
--no hardcode brooklyn branch
--must include a subquery

--find the customers who have deposits in the city with 3 branches(only brooklyn has 3 branches)
SELECT DISTINCT cus.cust_ID, cus.customer_name
FROM customer AS cus
JOIN depositor AS dep on cus.cust_ID = dep.cust_ID
JOIN account as acc ON dep.account_number = acc.account_number
JOIN branch as bra ON acc.branch_name = bra.branch_name
WHERE bra.branch_city IN (
	SELECT DISTINCT branch_city
	FROM branch
	GROUP BY branch_city
	HAVING COUNT(DISTINCT branch_name::varchar) = 3)
-- join both query to show rows that appear in both result sets
INTERSECT 
-- while running the first query, I noticed billy boi and hank handles were showing up.
--filter out who have their names returned 3 times (all 3 branches in brooklyn)
SELECT DISTINCT cus.cust_ID, cus.customer_name
FROM customer AS cus
JOIN depositor AS dep on cus.cust_ID = dep.cust_ID
JOIN account as acc ON dep.account_number = acc.account_number
JOIN branch as bra ON acc.branch_name = bra.branch_name
GROUP BY cus.customer_name, cus.cust_ID
HAVING COUNT(*) = 3;



--Query 7--
--get loan_number, customer_name, branch_name customers who have a loan at Yonkahs Bankahs branch
--whose loan amount exceeds average loan amount for that branch. 
--include a join and subquery

--get proper joins and where clause. Note: hardcoding was not mentioned in instructions
SELECT loa.loan_number,
	cus.customer_name,
	loa.branch_name
FROM loan as loa
JOIN borrower as bor on loa.loan_number = bor.loan_number
JOIN customer as cus on bor.cust_ID = cus.cust_ID
WHERE loa.branch_name::varchar = 'Yonkahs Bankahs'
--subquery to determine if each individual loan was greater than the total avg of loans taken out of yokahs bankahs
AND CAST(loa.amount AS numeric) > (
	SELECT AVG(CAST(loa.amount AS numeric))
	FROM loan AS loa
	WHERE loa.branch_name = 'Yonkahs Bankahs');
	
	






	

