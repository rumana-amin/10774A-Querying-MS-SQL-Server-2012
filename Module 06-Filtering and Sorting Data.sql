/* Exercise 1: Writing Queries That Filter Data Using a Where Clause. */
--Task 1: Write a SELECT statement that uses a WHERE clause.
Select 
	custid, 
	companyname, 
	contactname, 
	address, 
	city, 
	country, 
	phone
From
	Sales.Customers
Where
	country = 'Brazil';
 
 --Task 2: Write a SELECT statement that uses an IN predicate in the WHERE clause.
Select 
	custid, companyname, contactname, address, city, country, phone
From 
	Sales.Customers
Where 
	country IN ('Brazil', 'UK', 'USA');

--Task 3: Write a SELECT statement that uses an LIKE predicate in the WHERE clause.
Select 
	custid, companyname, contactname, address, city, country, phone
From
	Sales.Customers
Where
	contactname LIKE 'A%';

--Task 4: Observe the T-SQL statement provided by the IT department.
Select 
	c.custid, c.companyname, o.orderid
From Sales.Customers AS c
Left Outer Join Sales.Orders AS o 
	ON c.custid = o.custid AND c.city = 'Paris';

Select 
	c.custid, c.companyname, o.orderid
From Sales.Customers AS c
Left Outer Join Sales.Orders AS o 
	ON c.custid = o.custid
Where 
	c.city = 'Paris';

--Task 5: Write a SELECT statement to retrieve those customers without orders.
Select 
	c.custid, c.companyname, o.orderid
From Sales.Customers AS c
Left Outer Join Sales.Orders AS o 
	ON c.custid = o.custid
Where
	o.orderid IS NULL;


/* Exercise 2: Writing Queries That Sort Data Using an ORDER BY Clause. */
--Task 1: Write a SELECT statement that uses an ORDER BY clause.
Select 
	c.custid, c.contactname, o.orderid, o.orderdate
From Sales.Customers AS c 
Inner JOIN Sales.Orders AS o
	ON c.custid = o.custid
Where
	o.orderdate >= '20080401'
Order by 
	o.orderdate DESC, c.custid ASC;

--Task 2: Apply the needed changes and execute the T-SQL statement.
Select e.empid, e.lastname, e.firstname, e.title, e.mgrid,	
		m.lastname AS mgrlastname, m.firstname AS mgrfirstname
From HR.Employees AS e
Inner Join HR.Employees AS m
	ON e.mgrid = m.mgrid
Where 
	m.lastname = 'Buck';

--Task 3: Order the result by the firstname column.
Select e.empid, e.lastname, e.firstname, e.title, e.mgrid,	
		m.lastname AS mgrlastname, m.firstname AS mgrfirstname
From HR.Employees AS e
Inner Join HR.Employees AS m
	ON e.mgrid = m.mgrid
Where 
	m.lastname = 'Buck'
Order by
	mgrfirstname;


/* Exercise 3: Writing Queries That Filter Data Using the TOP Option. */
--Task 1: Write a SELECT statement to retrieve the last 20 orders.
Use AdventureWorks2008R2
Select Top (20) SalesOrderID, OrderDate
From Sales.SalesOrderHeader
Order by Orderdate Desc;

--Task 2: Use the OFFSET-FETCH clause to implement the same task. 
Use AdventureWorks2008R2
Select SalesOrderID, OrderDate
From Sales.SalesOrderHeader
Order by Orderdate Desc
Offset 0 Rows Fetch NExt 20 Rows Only;


--Task 3: Write a SELECT statement to retrieve the the most expensive products.
Use AdventureWorks2008R2
Select Top (10) Percent Name, ListPrice
From Production.Product
Where ListPrice <> 0
order by ListPrice Desc;


/* Exercise 4: Writing Queries That Filter Data Using the TOP Option. */
--Task 1: Use the OFFSET-FETCH clause to fetch the first 20 rows.
Use AdventureWorks2008R2
Select CustomerID, SalesOrderID, OrderDate
From Sales.SalesOrderHeader
Order by orderDate Desc, SalesOrderID
Offset 0 Rows Fetch Next 20 Rows Only;

--Task 2: Use the OFFSET-FETCH clause to skip the first 20 rows.
Use AdventureWorks2008R2
Select 
	CustomerID, SalesOrderID, OrderDate
From 
	Sales.SalesOrderHeader
Order by 
	orderDate Desc, SalesOrderID
Offset 20 Rows Fetch Next 20 Rows Only;

--Task 3: Write a generic form of the OFFSET-FETCH clause for paging.
OFFSET (@pagenum-1)*@pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;