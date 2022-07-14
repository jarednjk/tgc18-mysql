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

