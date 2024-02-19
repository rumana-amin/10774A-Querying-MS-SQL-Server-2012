/****Exercise 1: Writing Queries That Use the GROUP BY Clause.****/
--Task 1: Write a SELECT statement to retrieve different groups of customers.
Select s.custid, c.contanctname
From Sales.Orders as s
    Inner Join Sales.Customers as c 
    ON s.cust_id = c.cust_id
Where s.emp_id = 5
Group by s.custid, c.contanctname;

--Task 2: Add an additional column from the Sales.Customers table.
Select s.custid, c.contanctname, c.city
From Sales.Orders as s
    Inner Join Sales.Customers as c 
    ON s.cust_id = c.cust_id
Where s.emp_id = 5
Group by s.custid, c.contanctname, c.city;

--Task 3: Write a SELECT statement to retrieve the customers with orders for each year.
Select custid, YEAR(orderdate) as orderyear 
From Sales.Oresers
Where s.emp_id = 5
Group by custid, YEAR(orderdate)
Order by custid, orderyear;

--Task 4: Write a SELECT statement to retrieve groups of product categories sold in a specific year.
Select c.categoryid, c.categoryname
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.orderid
    Inner Join Production.Products as p ON p.productid = d.productid
    Inner Join Production.Categories as c ON c.categoryid = p.categoryid
Where Year(o.orderdate) = 2008
Group by c.categoryid, c.categoryname;


/****Exercise 2: Writing Queries That Use the AGGREGATE Functions.****/
--Task 1: Write a SELECT statement to retrieve the total sales amount per order.
Select o.orderid, o.orderdate, SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by o.orderid, o.orderdate
Order by 2 desc;

--Task 2: Add additional columns.
Select 
    o.orderid, 
    SUM(d.qty*d.unitprice) as total_sales, 
    count(*) as no_of_orderlines, 
    AVG(d.qty*d.unitprice) as avg_sales_per_orderline
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by 
    o.orderid, o.orderdate
Order by 3 desc;

--Task 3: Write a SELECT statement to retrieve the sales amount value per month.
Select 
    Year(o.orderdate)*100 + Month(o.orderdate) as yearmonthno, 
    SUM(d.qty*d.unitprice) as total_sales, 
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by 
    Year(o.orderdate), Month(o.orderdate)
Order by yearmonthno;

--Task 4: Write a SELECT statement to list all customers, with the total sales amount and number of order lines added.
Select 
    c.custid, c.contactname,
    SUM(d.qty*d.unitprice) as total_sales,
    MAX(d.qty*d.unitprice) as max_sales_per_orderline,
    count(*) as number_of_rows,
    count(o.orderid) as number_of_orderlines
From Sales.Customers as c
    Left Join Sales.Orders as o On o.custid = c.custid
    Left Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by 
    c.custid, c.contactname
Order by 
    total_sales;


/****Exercise 3: Writing Queries That Use Distinct AGGREGATE Functions.****/
--Task 1: Modify a SELECT statement to retrieve the number of customers.
Select
    Year(orderdate) as orderyear,
    Count(orderid) as no_of_orders,
    Count(Distinct custid) as no_of_customers
From Sales.Orders
Group by Year(orderdate);

--Task 2: Write a SELECT statement to analyze segments of customers.
Select
    Substring(c.contactname,1,1) as firstletter,
    Count(Distinct c.custid) as no_of_customers,
    Count(o.orderid) as no_of_orders
From Sales.Customers as c
    Left Join Sales.Orders as o ON o.custid = c.custid
Group by 
    Substring(c.contactname,1,1)
Order by 
    firstletter;

--Task 3: Write a SELECT statement to retrieve additional sales statistics.
Select 
    c.categoryid, c.categoryname,
    SUM(d.qty*d.unitprice) as total_sales,
    Count(Distinct o.orderid) as no_of_orders,
    SUM(d.qty*d.unitprice) as total_sales / Count(Distinct o.orderid) as avg_sales_per_order
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.orderid
    Inner Join Production.Products as p ON p.productid = d.productid
    Inner Join Production.Categories as c ON c.categoryid = p.categoryid
Where Year(o.orderdate) = 2008
Group by c.categoryid, c.categoryname;


/****Exercise 4: Writing Queries That Filter Groups with the HAVING Clause.****/
--Task 1: Write a SELECT statement to retrieve the top 10 customers.
Select Top (10)
    o.custid, SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by o.custid
Having SUM(d.qty*d.unitprice) >= 10000
Order by 2 desc;

--Task 2: Write a SELECT statement to retrieve specific orders.
Select
    o.orderid, o.empid,
    SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Where 
    o.orderdate >= '20080101' AND o.orderdate < '20090101'
Group by 
    o.orderid, o.empid;

--Task 3: Apply additional filtering.
Select
    o.orderid, o.empid,
    SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Where 
    o.orderdate >= '20080101' AND o.orderdate < '20090101'
Group by 
    o.orderid, o.empid
Having
    SUM(d.qty*d.unitprice) >= 10000;
--------------------------------------------------------------------
Select
    o.orderid, o.empid,
    SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Where 
    o.orderdate >= '20080101' AND o.orderdate < '20090101' 
    AND o.empid = 3
Group by 
    o.orderid, o.empid
Having
    SUM(d.qty*d.unitprice) >= 10000  ;

--Task 4: Retrieve the customers with more than 25 orders.
Select 
    o.custid, 
    Max(o.orderdate) as last_order_date,
    SUM(d.qty*d.unitprice) as total_sales
From Sales.Orders as o
    Inner Join Sales.OrderDetails as d ON d.orderid = o.ordrid
Group by o.custid
Having Count(Distinct o.orderid) > 25;


