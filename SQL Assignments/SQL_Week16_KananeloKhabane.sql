select CustomerName, Country, Notes from KCC.dbo.Customers

select CustomerName as [ Customer Name], 
Country as [ Region], 
Notes as [ Remarks] 
from KCC.dbo.Customers

select distinct CustomerName from KCC.dbo.Customers
select distinct Country from KCC.dbo.Customers

select * from dbo.Customers
select top (5) * from dbo.Customers

select * 
from dbo.Customers 
where City = 'Seattle' 
-- this is all about spacing and adding comments

select * 
from dbo.Customers 
where City <> 'Seattle' 
-- "<>" and "!=" means NOT EQUAL

select * 
from dbo.Customers 
where City = 'Seattle' or City = 'Mobile'
-- OR statement

select * 
from dbo.Customers 
where City not in('Seattle', 'Mobile', 'Paris')
-- IN and NOT IN statements

select * 
from dbo.Customers 
where CustomerName = 'Tres  Delicious'and City = 'Paris'

select * 
from dbo.Customers 
where CustomerName Like 'A%'
-- means where customer name begins with A, NOT like means doesn't begin with A

SELECT TOP (1000) [OrderID]
      ,[OrderDate]
      ,[CustomerID]
      ,[OrderTotal]
  FROM [KCC].[dbo].[Orders]
  where OrderTotal between 1000 and 3000
  -- between, and' are inclusive. can use <,>,>=
  
  Select OrderID, 
         OrderDate, 
         OrderTotal,
         CustomerName,
         Phone
  from dbo.Orders
  Join dbo.Customers 
  ON dbo.Orders.CustomerID = dbo.Customers.CustomerID
  -- Using (INNERJOIN) 

   Select OrderID, 
         OrderDate, 
         OrderTotal,
         CustomerName,
         Phone
  from dbo.Orders
 Right outer Join dbo.Customers 
  ON dbo.Orders.CustomerID = dbo.Customers.CustomerID
  -- joins the table on the right to the left regardless

   Select OrderID, 
         OrderDate, 
         OrderTotal,
         CustomerName,
         Phone
  from dbo.Orders o
  Join dbo.Customers c  
  ON o.CustomerID = c.CustomerID
  ORDER BY OrderTotal desc
  -- using ALIAS, place it after the name you want to replace like 'o' and 'c' here
  -- order by shoes the order in which the result appears, in a specific column/ category: desc descending

  Select * from [dbo].[Orders]
  Where OrderDate >= '2/18/2022'
  -- better with the funtion below
  Select * from [dbo].[Orders]
  Where OrderDate >= DATEADD(month,-1, GETDATE())
   Select count(*) from [dbo].[Orders]
  Where OrderDate >= DATEADD(month,-1, GETDATE())
  -- other functions include count, sum, 