/* Exercise 1: Writing Queries That Use Inner Joins. */
--Task 1: Write a SELECT statement that uses an inner join.
Select 
	p.productname, 
	c.categoryname
From Production.Products AS p
Inner Join Production.catergories AS c
	ON p.categoryid = c.categoryid;


/* Exercise 2: Writing Queries That Use  Multiple Table Inner Joins. */ 
--Task 2: Apply the needed changes and execute the T-SQL statements.
--Task 3: Change the table aliases.
Select  
	c.custid, 
	c.contactname,
	o.orderid
From Sales.Customers AS c
Inner Join Sales.Orders AS o
	ON c.custid = o.custid;

--Task 4: Add an additional table and columns. 
Select 
	c.custid, 
	c.contactname, 
	o.orderid, 
	od.productid, 
	od.qty, 
	od.unitprice
From Sales.Customers AS c
Inner Join Sales.Orders AS o
	ON c.custid = o.custid
Inner Join Sales.OrderDetails AS od
	ON od. orderid = o.orderid;

Use AdventureWorks2008R2
Select c.CustomerID, soh.SalesOrderID, od.ProductID, od.OrderQty, od.UnitPrice
From Sales.Customer AS c
Join Sales.SalesOrderHeader AS soh
	ON c.CustomerID = soh.CustomerID
Join Sales.SalesOrderDetail AS od
	ON od.SalesOrderID = soh.SalesOrderID;


/* Exercise 3: Writing Queries That Use Self Joins. */
--Task 1: Write a basic SELECT statement 
Select 
	e.empid,
	e.lastname, 
	e.firstname, 
	e.title, 
	e.mgrid
From HR.Employees AS e;

--Task 2: Write a query that uses a self- Join.
Select 
	e.empid, 
	e.lastname, 
	e.firstname,
	e.title, 
	m.mgrid, 
	m.lastname AS mgrlastname, 
	m.firstname AS mgrfirstname
From HR.Employees AS e
Inner Join HR.Employees AS m
	ON e.empid = m.mgrid;


/* Exercise 4: Writing Queries That Use Outer Joins. */
--Task 1: Write a SELECT statement that uses an outer join.
Select
	c.custid, 
	c.contactname, 
	o.orderid
From Sales.Customers AS c
left outer Join Sales.Orders AS o
	ON c.custid = o.custid;


/* Exercise 5: Writing Queries That Use Cross Joins. */
--Task 2: Write a SELECT statement that uses an cross join.
Select 
	e.empid,
	e.lastname, 
	e.firstname,
	c.calendardate
From HR.Employees AS e
Cross Join HR.Calendar AS c;
	

