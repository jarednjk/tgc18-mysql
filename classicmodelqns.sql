-- QNS 1
SELECT city, phone, country FROM offices

-- QNS 2
SELECT * FROM orders where comments LIKE '%fedex%'

-- QNS 3
SELECT contactFirstName, contactLastName FROM customers order by customerName DESC

-- QNS 4
SELECT * FROM employees WHERE  jobTitle = 'Sales Rep' and (firstName LIKE '%son%' or lastname LIKE '%son%')
	AND (officeCode = 1 or officeCode = 2 or officeCode = 3)

-- QNS 5
SELECT customerName, contactLastName, contactFirstName FROM orders join customers
	on orders.customerNumber = customers.customerNumber where orders.customerNumber = 124

-- QNS 6 // products.* , orderdetails.* (join all columns from both table)
SELECT productName, orderNumber, orderdetails.productCode, quantityOrdered, orderLineNumber 
FROM products join orderdetails on products.productCode = orderdetails.productCode

-- QNS 7 
SELECT customerName, country, sum(amount) FROM payments
JOIN customers on payments.customerNumber = customers.customerNumber
WHERE country = 'USA'
GROUP BY customerName, country

-- QNS 8 
SELECT state, count(*) FROM employees 
JOIN offices on employees.officeCode = offices.officeCode
WHERE country = 'USA'
GROUP BY state

-- QNS 9
SELECT customerName, avg(amount) FROM payments 
join customers on payments.customerNumber = customers.customerNumber
GROUP BY customerName, payments.customerName

-- QNS 10
select customerName, avg(amount) from payments 
join customers on payments.customerNumber = customers.customerNumber
group by customerName, payments.customerName
having sum(amount) > 10000

-- QNS 11
SELECT productName, count(*), orderdetails.productCode FROM products
join orderdetails on products.productCode = orderdetails.productCode
group by orderdetails.productCode, productName
order by count(*) desc
limit 10

-- SET 2
-- QNS 1
SELECT * FROM offices
GROUP BY country, state, city

--QNS 2
select count(customerNumber) from customers

-- QNS 3
SELECT sum(amount) FROM payments
WHERE year(paymentDate) = 2004

-- QNS 4
SELECT * FROM productlines
WHERE productLine LIKE "%cars%"

-- QNS 5
SELECT productName, quantityOrdered FROM products
JOIN orderdetails on products.productCode = orderdetails.productCode
WHERE quantityOrdered >= 10

--QNS 6
SELECT sum(amount) FROM payments
WHERE paymentDate = "2004-10-28"

--QNS 7
SELECT * FROM payments
WHERE amount > 100000

-- QNS 8
SELECT productLine, productName FROM products
GROUP BY productLine, productName

-- QNS 9
SELECT productLine, count(*) FROM products
group by productLine


--qNS 10
SELECT min(amount) FROM payments;

-- QNS 11
SELECT customerName, city FROM customers
WHERE salesRepEmployeeNumber is null

-- QNS 12
SELECT CONCAT(firstName, ' ', lastName) as 'Full Name', jobTitle FROM employees
WHERE jobTitle LIKE '%vp%' OR jobTitle LIKE '%manager%'

-- QNS 13
SELECT * FROM orderdetails
WHERE (quantityOrdered * priceEach) > 5000

-- SUBQUERY 
-- QNS 1
SELECT * FROM payments
WHERE amount > (SELECT AVG(amount) from payments) *2

-- QNS 2
