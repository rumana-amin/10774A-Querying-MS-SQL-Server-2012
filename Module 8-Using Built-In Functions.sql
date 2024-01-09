/* Exercise 1: Writing Queries That Use Conversion Functions.*/
--Task 1: Write a SELECT statement that uses the CAST or CONVERT function.
Select	
	'The unit price for the ' + productname + ' is' + CAST(unitprice as nvarchar(10)) + ' $.'  as productdesc
From Productions.Products;

--Task 2: Write a SELECT statement to filter rows based on specific date information.
Select	
	orderid, orderdate, shippeddate, coalesce(shipregion, 'No region') as shipregion 
From Sales.Orders
Where 
	orderdate >= convert(Datetime, '4/1/2007', 101)
	and orderdate <= convert(Datetime, '11/30/2007', 101)
	and shippeddate > DateAdd(Day, 30, orderdate);

--Alternate Solution: Using PARSE function
Select	
	orderid, orderdate, shippeddate, coalesce(shipregion, 'No region') as shipregion 
From Sales.Orders
Where 
	orderdate >= PARSE('4/1/2007' as Datetime using 'en-us')
	and orderdate <= PARSE('11/30/2007'as Datetime using 'en-us')
	and shippeddate > DateAdd(Day, 30, orderdate);

--Task 3: Write a SELECT statement to convert the phone number information to an integer value.
Select
	convert(int, replace(replace(replace(replace(phone, '-', ''),'(', ''),')',''), ' ', '')) as phoneint
From Sales.Customers;

--Using Try_Convert
Select
	try_convert(int, replace(replace(replace(replace(phone, '-', ''),'(', ''),')',''), ' ', '')) as phoneint
From Sales.Customers;


/* Exercise 2: Writing Queries That Use Logical Functions.*/
--Task 1: Write a SELECT statement to mark specific customers based on their country and contact title.
Select	
	custid,
	contactname,
	iif(country = 'Mexico' and contacttitle = 'Owner', 'Target Group', 'Other') as segmentgroup
From Sales. Customers;

--Task 2: Modify the SQL statement to mark different customers.
Select	
	custid,
	contactname,
	iif(contacttitle = 'Owner' or region is not null, 'Target Group', 'Other') as segmentgroup
From Sales. Customers;

--Task 3: Create four groups of Customers.
Select	
	custid,
	contactname,
	Choose(custid % 4 +1, 'Group one', 'Group two', 'Group three', 'Group four') as segmentgroup
From Sales. Customers;


/* Exercise 3: Writing Queries That Test for Nullability.*/
--Task 1: Write a SELECT statement to retrieve customers fax information.
Select	
	contactname,
	coalesce(fax, 'No in formation') as fax_number
From Sales. Customers;

--Using ISNULL
Select	
	contactname,
	ISNULL(fax, 'No in formation') as fax_number
From Sales. Customers;

--Task 2: Write a filter for a variable that could be NULL.
Declare @region as NVARCHAR(30) = NULL;
Select	
	custid, region
From Sales.Customers
Where region = @region OR (region is NULL and @region is NULL);

GO

Declare @region as NVARCHAR(30) = 'WA';
Select	
	custid, region
From Sales.Customers
Where region = @region OR (region is NULL and @region is NULL);

--Task 3: Write a SELECT statement to return all the customers that do not have a two-character abbreviation for the region.
Select	
	custid, contactname, city, region
From 
	Sales.Customers
Where 
	region is NULL 
	OR len(region) != 2;


