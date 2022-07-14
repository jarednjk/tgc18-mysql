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

-- QNS 6
SELECT productName, orderNumber, orderdetails.productCode, quantityOrdered, orderLineNumber 
FROM products join orderdetails on products.productCode = orderdetails.productCode