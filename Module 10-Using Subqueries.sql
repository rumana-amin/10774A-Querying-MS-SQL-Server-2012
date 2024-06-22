/* Exercise 1: Writing Queries That Use Self-Contained Subqueries.*/
--Task 1: Write a SELECT statement to retrieve the last order date.

Select max(orderdate) as lastorderdate
From Sales.Orders;

--Task 2: Write a SELECT statement to retrieve all orders on the last order date.

Select orderid, orderdate, empid, custid
From Sales.Orders
Where orderdate = (Select max(orderdate) 
					From Sales.Orders);

--Task 3: Observe the T-SQL statement provided by the IT department.

Select orderid, orderdate, empid, custid
From Sales.Orders
Where custid = (Select custid 
					From Sales.Customers
					Where contactname Like N'I%');
--Modified query
Select orderid, orderdate, empid, custid
From Sales.Orders
Where custid IN (Select custid 
					From Sales.Customers
					Where contactname Like N'B%');

--Task 2: Write a SELECT statement to analyze each order's sales as a percentage of the total sales amount.
Select
	o.orderid,
	SUM(d.qty*d.unitprice) as totalsalesamount,
	SUM(d.qty*d.unitprice) /
		(
		Select SUM(d.qty*d.unitprice)
		From Sales.Orders as o
		Inner Join Sales.OrderDetails as d	
		ON d.orderid = o.orderid
		Where o.orderdate >= '20080501' AND <'20080601'
		) * 100.0 as salesptcoftotal 
From 
	Sales.Orders as o
	Inner Join Sales.Orderdetails as d
	ON d.orderid = o.orderid
Where 
	o.orderdate >= '20080501' AND <'20080601'
Group by 
	o.orderid;


/* Exercise 2: Writing Queries That Use Scaler and Multi-Valued Subqueries.*/
--Task 1: Write a SELECT statement to retrieve specific products.

Select productid, productname
From Production.Products
Where productid IN
		(Select productid
		From Sales.OrderDetails
		Where qty > 100);

--Task 2: Write a SELECT statement to retrieve those customers without orders.

Select custid, contactname
From Sales.Customers 
Where custid NOT IN
		(Select custid
		From Sales.Orders);

--Task 3: Add a rowand return the query that retrieve those customers without orders.

Select custid, contactname
From Sales.Customers 
Where custid NOT IN
		(Select custid
		From Sales.Orders
		where custid is Not Null);


		/* Exercise 3: Writing Queries That Use Corelated Subqueries and an EXISTS predicate.*/
--Task 1: Write a SELECT statement to retrieve the last orderdate for each customer.

Select	
	c.custid, c.contactname.
	(
		Select Max(o.orderdate)
		From Sales.Orders as o
		Where o.custid = c.custid
	) as lastorderdate
From 
	Sales.Customers as c;

--Task 2: Write a SELECT statement that uses the EXISTS predicate to retrieve those customers without orders.

Select	
	c.custid, c.contactname.
From Sales.Customers as c
Where 
	Not Exists (Select* From Sales.Orders as o Where o.custid = c.custid);

--Task 3: Write a SELECT statement to retrieve customers that bought expensive products.

Select	
	c.custid, c.contactname
From 
	Sales.Customers as c
Where Exists
	(
		Select*
		From Sales.Orders as o
		Inner Join Sales.OrderDetails as d 
		ON d.orderid = o.orderid
		Where c.custid = o.custid
			AND d.unitprice > 100.0
			AND o.orderdate >= '20080401'
	);

--Task 4: Write a SELECT statement to display the total sales amount and the running total sales amount.

Select 
	Year(o.orderdate) as orderyear,
	SUM(d.qty * d.unitprice) as totalsales,
	(
		Select SUM(d2.qty * d2.unitprice)
		From Sales.Orders as o2
		Inner Join Sales.OrderDetaails as d2
		ON d2.orderid = o2.orderid
		Where Year(o2.orderdate) <= Year(o.orderdate)
		) as runsales

From Sales.Orders as o
Inner Join Sales.OrderDetails as d ON d.orderid = o.orderid
Group by Year(o.orderid)
Order by orderyear

--Task 5: Clean the Sales.Customers Table
Delete Sales.Customers
Where custid Is Null;
