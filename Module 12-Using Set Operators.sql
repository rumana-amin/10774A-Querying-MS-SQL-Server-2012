/************ Exercise 1: Writing Queries That Use UNION Set Operations and UNION ALL Multi-Set Operators ***********/
---- Task 1: Write a Select statement to retrieve specific products. ----
Select productid, productname
From Production.Produtcts
Where categoryid = 4;

---- Task 2: Write a Select statement to retrieve all products with more than $50000 total sales amount. ----
Select
	d.productid, p.productname
From Sales.OrderDetails As d
Inner Join Production.Products As p
	ON p.productid = d.productid
Group by d.productid, p.productname
Having SUM(d.unitprice * d.qty) >50000;

---- Task 3: Merge the results from task 1 and task 2. ----
Select productid, productname
From Production.Produtcts
Where categoryid = 4

UNION     ---or UNION ALL

Select
	d.productid, p.productname
From Sales.OrderDetails As d
Inner Join Production.Products As p
	ON p.productid = d.productid
Group by d.productid, p.productname
Having SUM(d.unitprice * d.qty) >50000;

---- Task 4: Write a Select statement to retrieve the top 10 customer by sales amount for january 2008 and February 2008. ----
Select c1.custid, c1.contactname
From
(
	Select Top (10)
		o.custid, c.contactname
	From Sales.OrderValues As o
	Inner Join Sales.Customers As c
		ON c.custid = o.custid
	Where o.orderdate >='20080101' And o.orderdate <'20080201'
	Group by o.custid, c.contactname
	Order By SUM(o.val) DESC
	) As c1

UNION

Select c2.custid, c2.contactname
From
(
	Select Top (10)
		o.custid, c.contactname
	From Sales.OrderValues As o
	Inner Join Sales.Customers As c
		ON c.custid = o.custid
	Where o.orderdate >='20080101' And o.orderdate <'20080201'
	Group by o.custid, c.contactname
	Order By SUM(o.val) DESC
	) As c2;

/************ Exercise 2: Writing Queries That Use the CROSS APPLY and OUTER APPLY Operators ***********/
---- Task 1: Write a Select statement that uses the Cross Apply operator to retrieve the last two orders for each product. ----
Select 
	p.productid, p.productname, o.orderid
From Production.Products As p
CROSS APPLY
(
	Select Top (2)
		d.orderid
	From Sales.OrderDetails As d
	where d.productid = p.prooductid
	Order by d.orderid DESC
	) As o
Order by p.productid;

---- Task 2: Write a Select statement that uses the Cross Apply operator to retrieve the top three products based on sales revenue for each customer. ----
Select
	c.custid, c.contactname, p.productid, p.totalsalsamount
From Sales.Customeres As c
CROSS APPLY dbo.fnGetTop3ProductsForCustomer(c.custid) as p
Order by c.custid

---- Task 3: Use the Outer Apply operator. ----
Select
	c.custid, c.contactname, p.productid, p.totalsalsamount
From Sales.Customeres As c
OUTER APPLY dbo.fnGetTop3ProductsForCustomer(c.custid) as p
Order by c.custid

---- Task 4: Analyze the Outer Apply operator. ----
Select
	c.custid, c.contactname, p.productid, p.totalsalsamount
From Sales.Customeres As c
CROSS APPLY dbo.fnGetTop3ProductsForCustomer(c.custid) as p
Where p.productid IS NUll;

---- Task 5: Remove the created inline table-valued function. ----
If Object_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	Drop Function dbo.fnGetTop3ProductsForCustomer;

/************ Exercise 3: Writing Queries That Use the EXCEPT and INTERSECT Operators ***********/
---- Task 1: Write a Select statement to return all customers that bought more than 20 distinct products. ----
Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving Count(distinct d.productid >20);

---- Task 2: Write a Select statement to retrieve all customers from USA except that bought more than 20 distinct products. ----
Select custid
From Sales.Customers
Where country = 'USA'

EXCEPT

Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving Count(distinct d.productid >20);

---- Task 3: Write a Select statement to retrieve all customers that spent more than 10000. ----
Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving SUM(d.unitprice * d.qty) > 10000;

---- Task 4: Write a Select statement that uses the EXCEPT and INTERSECT operator. ----
Select c.custid
From Sales.Customers As c

EXCEPT

Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving Count(distinct d.productid >20)

INTERSECT

Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving SUM(d.unitprice * d.qty) > 10000;

---- Task 5: Change the operator procedure.----
(
Select c.custid
From Sales.Customers As c

EXCEPT

Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving Count(distinct d.productid >20)
)

INTERSECT

Select o.custid
From Sales.orders as o
Inner Join Sales.OrderDetails as d
	ON d.orderid = o.orderid
Group By o.custid
HAving SUM(d.unitprice * d.qty) > 10000;