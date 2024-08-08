/************ Exercise 1: Querying System Catalog Views **************/
----Task 1: Write a SELECT statement to retrieve all databases.----
Select
	name, dbid, crdate
From
	sys.sysdatabases;

----Task 2: Write a SELECT statement to retrieve all user-defined tables in TSQL2012 database.----
Select
	object_id, name, schema_id, type, type_desc, create_date, modify_date
From sys.objects;

----Modify the code ----
Select Distinct
	type, type_desc
From sys.objects
Order by type_desc;

--- Modify the code to filter only user defined tables-----
Select
	object_id, name, schema_id, type, type_desc, create_date, modify_date
From sys.objects
Where type = N'U';

----Task 3: Use a different approach to retrieve all user-defined tables in TSQL2012 database.---
Select
	object_id, name, Schema_Name(schema_id) As schemaname, type, type_desc, create_date, modify_date
From sys.tables;

---Modify the code to see views
Select
	object_id, name, Schema_Name(schema_id) As schemaname, type, type_desc, create_date, modify_date
From sys.views;

----Task 4: Write a SELECT statement to retrieve all columns from the Sales.Customers table.----
Select
	c.name As columnname, c.column_id, c.system_type_id, c.max_length, c.precision, c.scale, c.collation_name
From sys.columns As c
Where object_id = OBJECT_ID('Sales.Customers')
Order by c.column_id;

/************ Exercise 2: Querying System Functions **************/
----Task 1: Write a SELECT statement to retrieve the current database name.----
Select
	DB_ID() as databaseid,
	DB_NAME(DB_ID()) as databasename,
	USER_NAME() as currentuser;

----Task 2: Write a SELECT statement to retrieve the object name and schema name.----
Select
	name,
	OBJECT_NAME(object_id) As tablename,
	OBJECT_SCHEMA_NAME(object_id) As schemaname
From sys.columns;

----Task 3: Write a SELECT statement to retrieve all the columns from the user-defined tables that contain the word "name" in the column name .----
Select
	c.name AS columnname,
	OBJECT_NAME(c.object_id) AS tablename,
	OBJECT_SCHEMA_NAME(c.object_id) As schemaname
From sys.columns As c
Where
	c.name Like N'%name%'
	AND OBJECTPROPERTY(c.object_id, N'IsUserTable') = 1;

----Task 4: Retrieve the view definition.----
Select OBJECT_DEFINITION(OBJECT_ID(N'Sales.CustOrders'));



/************ Exercise 3: Querying System Dynamic Management Views **************/
----Task 1: Write a SELECT statement to return all the current sessions.----
Select
	session_id, login_time, host_name, language, date_format
From 
	sys.dm_exec_sessions;

----Task 2: Execute the provided T-SQL statement.----
Select
	cpu_count As 'Logical CPU Count',
	hyperthread_ratio As 'Hyperthread Ratio',
	cpu_count/hyperthread_ratio As 'Physical CPU Count',
	physical_memory_kb/1024 As 'Physical Memory (MB)',
	sqlserver_start_time As 'Last SQL Start'
From sys.dm_os_sys_info;

----Task 3: Write a SELECT statement to return the current memory inforamtion.----
Select 
	total_physical_memory_kb,
	available_physical_memory_kb,
	total_page_file_kb,
	available_page_file_kb,
	system_memory_state_desc
from sys.dm_os_sys_memory;