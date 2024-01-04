--Execise 1: Writing Queries That Use Ranking Functions 
--Task 1: Write a SELECT statement that uses ROW_NUMBER function to create a calculated column.
Select
	orderid,
	orderdate,
	val,
	row_number() over(order by orderdate) as serialno
From Sales.OrderValues; 

----Task 2: Write a SELECT statement that uses ROW_NUMBER function to create a calculated column.
--Add an additional column using The Rank function.
Select
	orderid,
	orderdate,
	val,
	row_number() over(order by orderdate) as serialno,
	rank() over(order by orderdate)
From Sales.OrderValues;

--Task 3: Write a SELECT statement to calculate a rank, partitioned by customer and ordered by the order value.
Select
	orderid,
	orderdate,
	custid,
	val,
	rank() over(partition by custid order by val desc) as orderrankno
From Sales.OrderValues;

--Task 4: Write a select statement to rank orders, partition by customer and orderyear, and ordered by the order value.
Select
	custid,
	val,
	year(orderdate) as orderyear,
	rank() over(partition by custid, year(orderdate) order by val desc) as orderrankno
From Sales.OrderValues;

--Task 5: Filter only orders with the top two ranks.
Select 
	s.custid,
	s.val,
	s.orderyear,
	s.orderranknno
From
	(
	Select
		custid,
		val,
		year(orderdate) as orderyear,
		rank() over(partition by custid, year(orderdate) order by val desc) as orderrankno
	From Sales.OrderValues
	) as s
Where s.orderrankno >= 2;

--Execise 2: Writing Queries That Use OFFSET Functions 
--Task 1: Write a SELECT statement to retrieve the next row using a common table expression(CTE).
With OrderRows as
(
	Select
		orderid, 
		orderdate,
		val,
		row_number()over(order by orderdate, orderid) as rowno
	From Sales.OrderValues
	)
Select
	s.orderid,
	s.orderdate, 
	s.val,
	o.val as preval,
	s.val - o.val as diffprev
From OrderRows as s
Left Join OrderRows as o  --Left Join with the same CTE
	ON s.rowno = o.rowno+1;

--Task 2: Write a SELECT statement that uses the LAG function.

Select
	orderid, 
	orderdate,
	val,
	lag(val) over(order by orderdate, orderid) as preval,
	val - lag(val) over(order by orderdate, orderid) as preval,
From Sales.OrderValues

--Task 3: Analyze the sales information for the year 2007.
With SalesMonth2007 as
(
	Select 
		Month(orderdate) as monthno,
		sum(val) as sales,
	From Sales.OrderValues
	Where 
		orderdate >= '20070101' and orderdate < '20080101'
	Group by 
		Month(orderdate)
	) 
Select 
	monthno,
	sales,
	(lag(sales,1,0) over(oeder by monthno) + lag(sales,2,0) over(oeder by monthno) + lag(sales,3,0) over(oeder by monthno))/3 as avglast3months,
	sales - First_Value(sales) over (order by monthno Rows Unbounded Preceding) as diffjanuary,
	Lead(sales) over (order by monthno) as nextsales
From SalesMonth2007;

--Execise 3: Writing Queries That Use Window Aggregate Functions 
--Task 1: Write a SELECT statement to display the contribution of each customer's order compared to that customer's total purchase.
Select
	custid,
	ordrid,
	orderdate,
	val,
	100.0 * val / sum(val) over (partition by custid) as percentoftotal
From Sales.OrderValues
Order by custid, percentoftotal Desc;

--Task 2: Add a column to display the running total sales.
Select
	custid,
	ordrid,
	orderdate,
	val,
	100.0 * val / sum(val) over (partition by custid) as percentoftotal,
	sum(val) over (partition by custid 
					order by orderdate, orderid rows between unbounded preceding and current row) as runval
From Sales.OrderValues;

--Task 3: Analyze the year-to-date sales amount and average sales amount for the last threee months.
With SalesMonth2007 as
(
	Select 
		Month(orderdate) as monthno,
		sum(val) as val,
	From Sales.OrderValues
	Where 
		orderdate >= '20070101' and orderdate < '20080101'
	Group by 
		Month(orderdate)
	) 
Select 
	monthno,
	val,
	avg(val) over (order by monthno ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as avglast3months,
	sum(val) over (order by monthno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ytdval
From SalesMonth2007;