/*Excercise 1: Writing  Queries That Return Date and Timme Data*/
--Task 1: Write a SELECT statement to retrieve the current date and time.
Select 
	Current_timestamp As currentdatetime,
	Cast (current_timestamp as date) As currentdate,
	cast (current_timestamp as time) As currenttime,
	Year (CURRENT_TIMESTAMP) As currentyear,
	Month (current_timestamp) As currentmonthno,
	Day (current_timestamp) As currentday,
	Datepart (week, current_timestamp) as currentweek,
	DateName (month, current_timestamp) as currentmonthname

--Task 2: Write a SELECT statement to retrieve the data type date.
--Writing December 11, 2011 in diffarent format as Date data type
Select 
	DATEFROMPARTS (2011, 12, 11) as somedate;
Select 
	CAST ('20111211' as Date) as somedate;
Select 
	convert (Date, '12/11/2011', 101) as somedate;

--Task 3: Write a SELECT statement that uses different date and time functions.
Select 
	DATEADD (month, 3, current_timestamp) as threemonths,
	DATEDIFF (Day, CURRENT_TIMESTAMP, DateAdd (month, 3, current_timestamp)) as diffdays,
	DATEDIFF (Week, '19920404', '20110916') as diffweeks,
	DateAdd (Day, -day(current_timestamp)+1, current_timestamp) as firstday;

--Task 4: Observe the table provided by IT department.
Select isitdate,
Case When isdate(isitdate) = 1 then
	convert(Date,isitdate) Else Null
		End as converteddate
From Sales.Somedates;

--Use the Try_Convert function
Select isdate, 
	TRY_CONVERT(date,isitdate) as converteddate
From Sales.Somedates;


/*Exercise 2: Writing  Queries That Use Date and Timme Functions.*/
--Task 1: Write a SELECT statement to retrieve all distinct customers.
Use AdventureWorks2008R2
Select distinct CustomerID
From Sales.SalesOrderHeader
Where OrderDate between '20080201' and '20080229';

--Alternative Solution
Use AdventureWorks2008R2
Select distinct CustomerID
From Sales.SalesOrderHeader
Where Year(OrderDate) = '2008'
	and month(OrderDate) = '02';

--Task 2: Write a SELECT statement to calculate the first  and last day of the month.
Select 
	CURRENT_TIMESTAMP as currentdate,
	DATEADD (day, 1, EOMonth(current_timestamp,-1)) as firstdayofmonth,
	EOMONTH(current_timestamp) as endofmonth;

--Task 3: Write a SELECT statement to retrieve the orders placed in the last five days of the ordered month. 
Use AdventureWorks2008R2
Select
	SalesOrderID,
	CustomerID,
	OrderDate
From 
	Sales.SalesOrderHeader
Where 
	Datediff (day, OrderDate, Eomonth(OrderDate)) < 5;

--Task 4: Write a SELECT statement to retrieve all distinct products sold in the first 10 weeks of the year 2007.
Use AdventureWorks2008R2
Select Distinct 
	o.ProductID,
	h.OrderDate
From Sales.SalesOrderDetail as o
Inner Join Sales.SalesOrderHeader as h
	ON o.SalesOrderID = h.SalesOrderID
Where Year(OrderDate) = '2007'
 And DatePart(Week,OrderDate) <= 10;


/*Exercise 3: Writing  Queries That Return Character Data.*/
 --Task 1: Write a SELECT statement to concatenate two columns.
 Select 
	contactname + '(city:' + city +')' as namewithcity
 From Sales.Customer; 

 --Task 2: Add an additional column and treat NULL as an empty string.
 Select 
	contactname + '(city:' + city + 'region:' + coalesce(region, ' ') + ')' as namewithcity
 From Sales.Customer; 

 --Task 3: Write a SELECT statement to retrieve all customers based on the first character in the contact name.
 Select 
	 contactname, 
	 contacttitle
 From Sales.Customers
 Where contactname like [A-G]%
 Order by contactname; 


/*Exercise 4: Writing  Queries That Use Character Functions.*/
 --Task 1: Write a SELECT statement that uses the SUBSTRING function.
 --contactname value stored like this (Rumana,Amin)
 Select 
	contactname,
	substring(contactname,0,charindex(',',contactname)) as lastname
 From Sales.Customer;

 --Task 2: Extend the SUBSTRING function to retrieve the first name.
 --contactname value stored like this (Rumana,Amin)
Select 
	replace(contactname,',', ' ') as name 
	substring(contactname,charindex(',',contactname)+1, len(contactname)-charindex(',',contactname)+1) as firsttname
From Sales.Customer;

--Task 3: Write a SELECT statement to change the customer IDs.
Use AdventureWorks2008R2
Select 
	CustomerID,
	'C' + Right(Replicate('0',5) + CAST(CustomerID as varchar(5)),5) as customerid
From Sales.Customer;

--Task 4: Write a SELECT statement to return the number of character occurences.
Select 
	contactname,
	Len(contactname)-Len(Replace(contactname, 'a', ' ')) as numberofa
From Sales.Customers
Order by numberofa desc;
