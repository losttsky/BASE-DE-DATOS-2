use northwind

go --serparador

select 
c.CustomerID, c.CompanyName, c.ContactName, c.Country
,o.OrderID, o.OrderDate
,od.ProductID, od.UnitPrice, od.Quantity
from Customers as c 
INNER JOIN Orders as o ON c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] as od ON o.OrderID = od.OrderID;

select c.CustomerID, c.CompanyName, c.ContactName, c.Country
from Customers as c 
where c.Country = 'USA' and c.CompanyName like 'L%';

go

select 
c.companyname, c.country
,o.orderid, o.orderdate
from customers as c 
inner join orders as o on c.CustomerID=o.CustomerID

go


CREATE VIEW view_TotalSales
AS
	select 
	c.CompanyName
	,o.OrderID, o.OrderDate
	,SUM(d.unitprice * d.quantity) as Total
	from Customers as c 
	INNER JOIN Orders as o ON c.CustomerID = o.CustomerID 
	INNER JOIN [Order Details] as d ON o.OrderID = d.OrderID
	INNER JOIN Products as p ON d.ProductID = p.ProductID
	Group by c.CompanyName, o.OrderID, o.OrderDate
	go

select * from view_TotalSales

