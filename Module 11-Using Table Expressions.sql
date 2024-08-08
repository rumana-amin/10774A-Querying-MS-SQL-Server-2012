
/********* Exercise 1: Writing Queries That Use Views ***********/

----Task 1: Write a Select Statement to retrieve all products for a specific category.
Select productid, productname, supplierid, unitprice, discontinued
From Production.Products
Where caetgoryid = 1;

---- Modyfy the query to create VIEW
Create View Production.ProductsBeverages AS
Select
	productid, productname, supplierid, unitprice, discontinued
From Production.Products
Where caetgoryid = 1;

---- Task 2: Write a Select Statement against the created view.----
Select productid, productname
From Production.ProductsBeverages
Where supplierid = 1;

----Task 3: Try to use an ORDER BY clause in the created view.----
Alter View Production.ProductsBeverages AS
Select
	productid, productname, supplierid, unitprice, discountinued
From Production.Products
Where categoryid = 1
Order by productname;  -- results in error

----Modify by including TOP(100) percent----
Alter View Production.ProductsBeverages AS
Select TOP(100) PERCENT
	productid, productname, supplierid, unitprice, discountinued
From Production.Products
Where categoryid = 1
Order by productname;

----Task 4: Add a calculated column to the view. ----
Select
	productid, productname, supplierid, unitprice, discountinued,
	CASE When unitprice > 100 Then N'High' Else N'Normal' END AS pricetype
From Production.Products
Where categoryid = 1;

----Task 5: Remove the Production.ProductsBeverages view. ----
IF OBJECT_ID(N'Production.ProductsBeverages', N'V') IS NOT NULL
	DROP VIEW Production.ProductsBeverages;


/********* Exercise 2: Writing Queries That Use Derived Tables ***********/

----Task 1: Write a Select Statement against a derived table.
Select 
	p.productid, p.productname
From
	(
	Select
		productid, productname, supplierid, unitprice, discountinued,
		CASE When unitprice > 100 Then N'High' Else N'Normal' END AS pricetype
	From Production.Products
	Where categoryid = 1;
	) As p
Where p.pricetype = N'High';

----Task 2: Write a Select statement to calculate the total and average sales amount.
Select
	c.custid,
	SUM(c.totalsalesamountperorder) as totalsalesamount,
	Avg(c.totalsalesamountperorder) as avgsalesamount
From
		(
		Select
			o.custid, o.orderid, SUM(d.unitprice * d.qty) As totalsalesamountperorder
		From Sales.Orders As o
		Inner Join Sales.OrderDetails As d
			ON d.orderid = o.orderid
		Group By o.custid, o.orderid
		) As c
Group by c.custid;

----Task 3: Write a Select statement to retrieve the sales growth percentage.

Select
	cy.orderyear,
	cy.totalsalesamount As curtotalsales,
	py.totalsalesamount As prevtotalsales,
	(cy.totalsalesamount - py.totalsalesamount) / py.totalsalesamount * 100.0 as percentgrowth
From
		(
		Select Year(orderdate) As orderyear, SUM(val) as totalsalesamount
		From Sales.OrderValues
		Group By Year(orderdate)
		) As cy
Left Outer Join
		(
		Select Year(orderdate) As orderyear, SUM(val) as totalsalesamount
		From Sales.OrderValues
		Group By Year(orderdate)
		) As py ON cy.orderyear = py.orderyear + 1

Order by cy.orderyear;


/********* Exercise 3: Writing Queries That Use Common Table Expressions(CTEs) ***********/
----Task 1: Write a Select Statement that uses a CTE.
With ProductBeverages AS
(	
	Select
		productid, productname, supplierid, unitprice, discountinued,
		CASE When unitprice > 100 Then N'High' Else N'Normal' END AS pricetype
	From Production.Products
	Where categoryid = 1
	) As p
Select p.productid, p.productname
From ProductBeverages
Where p.uniprice = N'High';

----Task 2: Write a Select Statement to retrieve the toatl sales amount for each customer.
With c2008 (custid, salesamount2008) As
(
	Select custid, SUM(val)
	From Sales.OrderValues
	Where Year(orderdate) = 2008
	Group by custid
)
Select c.custid, c.contactname, c2008.salesamount2008
From Sales.Customeres As c
Left Outer Join c2008, ON c.custid = c2008.custid;

----Task 3: Write a Select Statement to compare the total sales amount for each customer over the previous year.
With c2008 (custid, salesamount2008) As
(
	Select custid, SUM(val)
	From Sales.OrderValues
	Where Year(orderdate) = 2008
	Group by custid
),
c2007 (custid, salesamount2007) As
(
	Select custid, SUM(val)
	From Sales.OrderValues
	Where Year(orderdate) = 2007
	Group by custid
)
Select
	c.custid, c.contactname,
	c2008.salesamount2008,
	c2007.salesamount2007,
	COALESCE((c2008.salesamount2008 - c2007.salesamount2007) / c2007.salesamount2007 *100.0, 0) As percentgrowth
From Sales.Customers As c
Left Outer Join c2008 ON c.custid = c2008.custid
Left Outer Join c2007 ON c.custid = c2007.custid
Order by percentgrowth DESC;

/********* Exercise 4: Writing Queries That Use Inline Table-Valued Function ***********/
----Task 1: Write a Select Statement to retrieve the total sales amount for each.
Select custid, SUM(val) as totalsalesamount
From Sales.OrderValues
Where Year(orderdate) = 2007
Group by custid;

---- Modify the code using an inline table-valued function.
Create Function dbo.fnGetSalesByCustomer
(@orderyear As INT) Returns Table
AS
RETURN
		Select custid, SUM(val) as totalsalesamount
		From Sales.OrderValues
		Where Year(orderdate) = @orderyear
		Group by custid;

----Task 2: Write a Select Statement against the inline table-valued function.
Select custid, totalsalesamount
From dbo.fnGetSalesByCustomer(2007);

----Task 3: Write a Select Statement to retrieve the top three products based on the total sales value for a specific customer.
Select Top(3) 
	d.productid,
	MAX(p.productname) As productname,
	SUM(d.qty * d.unitprice) as totalsalesamount
From Sales.Orders As o
Inner Join Sales.orderDetails as d
	ON d.orderid = o.orderid
Inner Join Production.Products As p 
	ON p.productid = d.productid
Where custid = 1
Group By d.productid
Order By totalsalesamount DESC;

----- Modify the code using an inline table valued function
Create Function dbo.fnGetTop3ProductsForCustomer
(@custid As INT) Returns Table
As
Return
		Select Top(3) 
			d.productid,
			MAX(p.productname) As productname,
			SUM(d.qty * d.unitprice) as totalsalesamount
		From Sales.Orders As o
		Inner Join Sales.orderDetails as d
			ON d.orderid = o.orderid
		Inner Join Production.Products As p 
			ON p.productid = d.productid
		Where custid = @custid
		Group By d.productid
		Order By totalsalesamount DESC;

---- Test the function
Select
	p.productid, p.productname, p.totalsalesamount
From dbo.fnGetTop3ProductsForCustomer(1) as p;

----Task 4: Write a Select Statement to comapre the total sales amountfor each customer over the previous year using inline table-valued functions.
Select
	c.custid, c.contactname,
	c2008.salesamount2008,
	c2007.salesamount2007,
	COALESCE((c2008.salesamount2008 - c2007.salesamount2007) / c2007.salesamount2007 *100.0, 0) As percentgrowth
From Sales.Customers As c
Left Outer Join dbo.fnGetSalesByCustomer(2007) AS c2007 ON c.custid = c2008.custid
Left Outer Join dbo.fnGetSalesByCustomer(2008) AS c2008 ON c.custid = c2007.custid;

----Task 5: Remove the created inline table-valued function.
IF OBJECT_ID('dbo.fnGetSalesByCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetSalesByCustomer;

IF Object_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT Null
	DROP Function dbo.fnGetTop3ProductsForCustomer;

