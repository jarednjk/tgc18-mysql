-- display all columns from all rows
select * from employees;

-- 

-- use where to filter the rows
select * from employees where officeCode = 1;
select firstName, lastName, email, officeCode from employees where officeCode = 1;

-- use LIKE with wildcard to match partial strings
SELECT * FROM employees WHERE jobtitle LIKE "%sales%";

-- %sales will match as long as the job title ends with 'sales';
SELECT * FROM employees WHERE jobtitle LIKE "%sales";

-- %sales will match as long as the job title begins with 'sales';
SELECT * FROM employees WHERE jobtitle LIKE "sales%";

-- filter for multiple conditions using logical operators
SELECT * FROM employees WHERE officeCode = 1 AND jobTitle LIKE "Sales Rep";
SELECT * FROM employees WHERE officeCode = 1 OR jobTitle LIKE "Sales Rep";

SELECT * FROM employees WHERE jobTitle LIKE officeCode = 1 OR jobTitle LIKE "Sales Rep";

-- joining
SELECT * FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode
	WHERE country="USA";

-- show only customers with sales rep
SELECT customerName, firstName, lastName, email FROM customers JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- left join if all rows on the left are to be included
SELECT customerName, firstName, lastName, email FROM customers LEFT JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;


-- SELECT customerName, firstName, lastName, employees.email FROM customers LEFT JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;


-- for each customer in the USA, show the name of the sales rep and their office number
SELECT customerName AS "Customer Name", customers.country as "Customer Country", firstName, lastName, offices.phone as "Office Phone Number" from customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber
	JOIN offices ON employees.officeCode = offices.officeCode
	WHERE customers.country = "USA";

-- date manipulation

-- current date of server
SELECT curdate();

-- current date and time
select now();

-- show all payments made after 30 jun 2003
select * from payments where paymentDate > "2003-06-30"

-- show all payments between XX and XX date
select * from payments where paymentDate >= "2003-01-01" and paymentDate <= "2003-06-30"

select * from payments where paymentDate between "2003-01-01" and "2003-06-30"

-- Display only a specific year where payment is made
SELECT checkNumber, YEAR(paymentDate) from payments

-- show all payments made in 2003
SELECT checkNumber, YEAR(paymentDate) from payments where YEAR(paymentDate) = 2003

-- year, month and day functions
SELECT checkNumber, YEAR(paymentDate), MONTH(paymentDate), DAY(paymentDate) from payments

-- count how many rows there are in employees table
select count(*) from employees

-- sum: allow you to sum to the value of a column across all the rows
select sum(quantityOrdered) from orderdetails

-- can filter the rows or join the table, before using aggregate function
select sum(quantityOrdered) from orderdetails where productCode = "S18_1749"

select sum(quantityOrdered * priceEach) as "total worth ordered" from orderdetails where productCode = "S18_1749"

-- find total amount paid by customers in june 2003
SELECT sum(amount) from payments where year(paymentDate) = 2003 and month(paymentDate) = 06

-- GROUP BY
-- count how many customers there are in country
SELECT country, count(*) FROM customers 
GROUP BY country

-- get the credit limit of 
select country, avg(creditLimit) from customers 
group by country

-- countries where sales rep has customers in and the count
SELECT country, avg(creditLimit), count(*) FROM customers
WHERE salesRepEmployeeNumber = 1504
GROUP BY country

-- to select something that is not an aggregate, you have to group by it
SELECT country, firstName, lastName, email, avg(creditLimit), count(*) FROM customers
JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE salesRepEmployeeNumber = 1504
GROUP BY country, firstName, lastName, email

-- order by is the last
SELECT country, firstName, lastName, email, avg(creditLimit), count(*) FROM customers
JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE salesRepEmployeeNumber = 1504
GROUP BY country, firstName, lastName, email
ORDER BY avg(creditLimit)

-- LIMIT
SELECT country, firstName, lastName, email, avg(creditLimit), count(*) FROM customers
JOIN employees on customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE salesRepEmployeeNumber = 1504
GROUP BY country, firstName, lastName, email
ORDER BY avg(creditLimit) DESC
LIMIT 3

-- filtering the groups using having
SELECT country, count(*) FROM customers
group by country
having count(*) > 5

-- Order
FROM
join
where
group by
having
order by

-- SUBQUERY
SELECT productCode from (SELECT productName, count(*), orderdetails.productCode FROM products
join orderdetails on products.productCode = orderdetails.productCode
group by orderdetails.productCode, productName
order by count(*) desc
limit 1) as sub;

-- find all customers whose credit limit is above the average
-- when the select only returns one value, it will be treated as a primitive
select * from customers where creditLimit > (SELECT avg(creditLimit) from customers)

SELECT * from products where productCode not in (select distinct(productCode) from orderdetails)

SELECT employeeNumber, sum(amount) FROM employees join customers
	on employees.employeeNumber = customers.salesRepEmployeeNumber
	join payments on customers.customerNumber = payments.customerNumber
	group by employees.employeeNumber
	having sum(amount) > (select sum(amount) * 0.1 from payments)