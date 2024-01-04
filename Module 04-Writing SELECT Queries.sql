/*Exercise 1: Writing Simple SELECT Statements */
--Task-3: Write a SELECT statement that includes specific columns. 
Select contactname, address, postalcode, city, country
From Sales.Customers;


/* Exercise 2: Eliminating Duplicates Using Distinct */
--Task 1: Write a SELECT statement that includes a specific column.
Select country
From Sales.Customers

--Task 2: Write a SELECT statement that uses the DISTINCT clause.
Select Distinct country
From Sales.Customers


/* Exercise 3: Using Table and Column Aliases */
--Task 1: Write a SELECT statement that uses a table alias
Select c.contactname, c.contacttitle
From Sales.Customers As c

--Task 2: Write a SELECT statement that uses a column alias
Select contactname As Name, contacttitle As Title, companyname as [Company Name]
From Sales.Customers;

--Task 3: Write a SELECT statement that uses a table alias and a column alias
Select p.productname As [Product Name]
From Productions.Products As p;


/*Exercise 4: Using a Simple CASE Expression
--Task 1: Write a SELECT statement */
Select categoryid, productname
From Production.Products;

--Task 2: Write a SELECT statement that uses a CASE expression
Select categoryid, productname
Case categoryid
	When 1 Then 'Beverages'
	When 2 Then 'Condiments'
	When 3 Then 'Confections'
	When 4 Then 'Daily Products'
	When 5 Then 'Grains/Cereals'
	When 6 Then 'Meat/Poultry'
	When 7 Then 'Produce'
	When 8 Then 'Seafood'
	Else 'other'
End As categoryname
From Production.Products;

--Task 3: Write a SELECT statement that uses a CASE expression to differentiate campaign-focused products.
Select p.categoryid, p.productname
Case 
	When p.categoryid = 1 Then 'Beverages'
	When p.categoryid = 2 Then 'Condiments'
	When p.categoryid = 3 Then 'Confections'
	When p.categoryid = 4 Then 'Daily Products'
	When p.categoryid = 5 Then 'Grains/Cereals'
	When p.categoryid = 6 Then 'Meat/Poultry'
	When p.categoryid = 7 Then 'Produce'
	When p.categoryid = 8 Then 'Seafood'
	Else 'other'
End As categoryname,
CASE
	When p.categoryid In (1,7,8) Then 'Campaign Products'
	Else 'Non-Campaign Products'
End As iscampaign
From Production.Products As p;




