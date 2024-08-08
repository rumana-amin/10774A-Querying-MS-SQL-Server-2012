/***************** Exercise 1: Writing Queries That USe The PIVOT Operator ***********************/
----Task 1: Write a Select statement to retrieve the number of customers for a specific customer group.----
Create View Sales.CustGroups As
Select
	custid, 
	Choose(custid % 3+1, N'A', N'B', N'C') As custgroup,
	country
From Sales.Customers

---- Modify the query to use Pivot operator.----
Select 
	country,
	p.A,
	p.B,
	p.C
From Sales.CustGroups
Pivot(Count(custid) For custgroup IN (A, B, C)) As p

----Task 2: Specify the grouping element for the Pivot operator.----
Alter View Sales.CustGroups As
Select
	custid, 
	Choose(custid % 3+1, N'A', N'B', N'C') As custgroup,
	country,
	city,
	contactname
From Sales.Customers

---- Modify the query to use Pivot operator.----
Select 
	country,
	city,
	contactname,
	p.A,
	p.B,
	p.C
From Sales.CustGroups
Pivot(Count(custid) For custgroup IN (A, B, C)) As p

----Task 3: Use a common table expression (CTE) to specify the grouping element for the Pivot operator.----
With PivotCustGroup As
(
	Select
		custid, country, contactname
	From Sales.CustGroups
	)
Select 
	country,
	p.A,
	p.B,
	p.C
From Sales.CustGroups
Pivot(Count(custid) For custgroup IN (A, B, C)) As p

----Task 4: Write a Select statement to retrieve the total sales amount for each customer and product category.----
With SalesByCategory AS
(
	Select
		o.custid,
		d.qty * d.unitprice as salesvalue,
		c.categoryname
	From Sales.Orders As o
	Inner Join Sales.OrderDetails As d ON d.orderid = o.orderid
	Inner Join Production.Products As p ON p.productid = d.productid
	Inner Join Production.Categories AS c ON c.catergoryid = p.categoryid
	Where o.orderdate >= '20080101' AND o.orderdate < '20090101'
)
Select 
	custid,
	p.Beverages,
	p.Condiments,
	p.Confectionaries,
	p.[Dairy Products],
	p.[Grains/Cereals],
	p.[Meat/Poultry],
	p.Produce,
	p.Seafood
From SalesByCategory
PIVOT (SUM(salesvalue) FOR categoryname
	IN (Beverages, Condiments, Confectionaries, [Dairy Products], [Grains/Cereals], [Meat/Poultry], Produce, Seafood) ) As p


/***************** Exercise 2: Writing Queries That USe The UNPIVOT Operator ***********************/
----Task 1: Create and query the Sales.PivotCustGroups.----
With Sales.PivotCustGroups AS
(
	Select
		custid,
		country,
		custgroup
	From Sales.CustGroups
)
Select
	country,
	p.A,
	p.B,
	p.C
From PivotCustGroups
Pivot(Count(custid) For custgroup IN (A, B, C)) As p

---Modify the query
Select
	country, A, B, C
From Sales.PivotCustGroups

----Task 2: Write a Select statement to retrieve a row for each country and customer group.
Select
	custgroup,
	country,
	numberofcustomers
From Sales.PivotCustGroups
UNPIVOT (numberofcustomers For custgroup IN(A, B, C)) As p

----Task 3: Remove the created views.----


/***************** Exercise 3: Writing Queries That USe The PIVOT Operator ***********************/
----Task 1: Write a Select statement that uses a Grouping Sets subclause to return the number of customers for different grouping sets.----
Select
	country,
	city,
	count(custid) as noofcustomers
From Sales.Customers
Group by 
Grouping Sets
(
	(country,city),
	(country),
	(city),
	()
);

----Task 2: Write a Select statement that uses the CUBE subclause to retrieve grouping sets based on yearly, monthly, daily sales values.----
Select
	Year(orderdate) As orderyear,
	Month(orderdate) As ordermonth,
	Day(orderdate) As orderday,
	SUM(val) as salesvalue
From Sales.OrderValues
Group by
CUBE (Year(orderdate), Month(orderdate), Day(orderdate));


----Task 3: Write a Select statement using the ROLLUP subbclause.----
Select
	Year(orderdate) As orderyear,
	Month(orderdate) As ordermonth,
	Day(orderdate) As orderday,
	SUM(val) as salesvalue
From Sales.OrderValues
Group by
ROLLUP (Year(orderdate), Month(orderdate), Day(orderdate));

---- Task 4: Analyze the total sales value by year and month.
Select
	Grouping_ID(Year(orderdate), Month(orderdate)) As groupid,
	Year(orderdate) As orderyear,
	Month(orderdate) As ordermonth,
	SUM(val) as salesvalue
From Sales.OrderValues
Group by
ROLLUP (Year(orderdate), Month(orderdate))
ORDER By groupid, orderyear, ordermonth;

