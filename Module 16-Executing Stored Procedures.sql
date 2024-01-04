/* Exercise 1: Using the EXECUTE Statement to Invoke Stored Procedures
Task 1: Create and execute a stored procedure */

Create Procedure Sales.GetTopCustomers As 
Select Top (10)
	c.custid,
	c.contactname,
	Sum(o.val) as salesvalue
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Group by c.custid, c.contactname
Order by salesvalue Desc;

Execute Sales.GetTopCustomers;

--Task 2: Modify the stored procedure and execute it

Alter Procedure Sales.GetTopCustomers As 
Select
	c.custid,
	c.contactname,
	Sum(o.val) as salesvalue
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Group by c.custid, c.contactname
Order by salesvalue Desc
Offset 0 Rows Fetch Next 10 Rows Only;

Execute Sales.GetTopCustomers;

/* Exercise 2: Passing Parameters to Stored Procedures
Task 1: Execute a stored procedure with a parameter for order year */

Alter Procedure Sales.GetTopCustomers
	@orderyear int
As 
Select
	c.custid,
	c.contactname,
	Sum(o.val) as salesvalue
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Where orderyear = @orderyear
Group by c.custid, c.contactname
Order by salesvalue Desc
Offset 0 Rows Fetch Next 10 Rows Only;

/* Better approach would be to use the DateTimeFromParts Function to provide a search argument for orderdate:
Where o.orderdate >= DATETIMEFROMPARTS(@orderyear, 1,1,0,0,0,0)
	and o.orderdate < DATETIMEFROMPARTS(@orderyear + 1,1,1,0,0,0,0) */

Execute Sales.GetTopCustomers @orderyear = 2007;

Execute Sales.GetTopCustomers @orderyear = 2008;


--Task 2: Modify the stored procedure to have a default value for the parameter and execute it

Alter Procedure Sales.GetTopCustomers
	@orderyear int = Null
As 
Select
	c.custid,
	c.contactname,
	Sum(o.val) as salesvalue
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Where Year(o.orderdate) = @orderyear OR @orderyear IS NULL
Group by c.custid, c.contactname
Order by salesvalue Desc
Offset 0 Rows Fetch Next 10 Rows Only;

Execute Sales.GetTopCustomers;

--Task 3: Pass Multiple parameters to the stored procedure.

Alter Procedure Sales.GetTopCustomers
	@orderyear int = Null,
	@n = 10
As 
Select
	c.custid,
	c.contactname,
	Sum(o.val) as salesvalue
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Where Year(o.orderdate) = @orderyear OR @orderyear IS NULL
Group by c.custid, c.contactname
Order by salesvalue Desc
Offset 0 Rows Fetch Next @n Rows Only;

Execute Sales.GetTopCustomers;
Execute Sales.GetTopCustomers @orderyear = 2008, @n = 5;
Execute Sales.GetTopCustomers @n = 25;

--Task 4: Return the result from a stored procedute using the OUTPUT clause 

Alter Procedure Sales.GetTopCustomers
	@customerpos int = 1,
	@customername NVARCHAR(30) OUTPUT
As 
SET @customername = (
Select
	c.contactname,
From Sales.OrderValues as o 
Inner Join Sales.Customer as c ON c.custid = o.custid
Group by c.custid, c.contactname
Order by SUM(o.val) Desc
Offset @customerpos - 1 Rows Fetch Next 1 Rows Only
);

Declare @outcustomername NVARCHAR(30);

Execute Sales.GetTopCustomers @customerpos = 1, @customername = @outcustomername
OUTPUT;

Select @outcustomername as customername;
