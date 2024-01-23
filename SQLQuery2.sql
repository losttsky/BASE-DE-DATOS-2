use Northwind
go

--Crear vista 
--Una vista es una consulta guardada que se puede reutilizar
--La vista no tiene datos propios y solo puede usar 16536 columnas.
--En la vista no se pude usar la instruccion Order By 

--SQL DDL DCL DML, lo que estamos haciendo es DDL que es Data Definition Language 
/*DDL:
	CREATE
	ALTER
	DROP
*/

Alter view view_salesAnton(Codigo, Compania, Contacto, Pais
, Orden, Fecha, Producto, PrecioUnidad, CantidadPedida)
with 
encryption --para encriptar
, schemabinding --no se pude borrar un objeto con una vista asociada porque estan amarradas 
, VIEW_METADATA -- indica que la vista no es una tabla en el lado de la programacion 
as
	select c.CustomerID, c.CompanyName, c.ContactName, c.Country
	, o.OrderID, o.OrderDate
	, p.ProductName
	, d.UnitPrice, d.Quantity
	from dbo.Customers as c 
	inner join dbo.Orders as o 
	on c.CustomerID = o.CustomerID
	inner join dbo.[Order Details] as d 
	on o.OrderID = d.OrderID
	inner join dbo.Products as p on d.ProductID = p.ProductID
	where c.CustomerID = 'ANTON'
	go

--Ver vistas que no hice yo xd
execute sp_helptext view_salesAnton

select * from view_salesAnton

drop table [Order Details] -- No se elimina por el schemabinding

alter view view_franceCustomers
as 
	select * from customers
	where Country = 'France'
	with check option -- Para cuando se inserten datos a traves de la visata se valide lo que siga en el where y asi se valide cone esas condiciones
	go

select * from view_franceCustomers

Insert into view_franceCustomers(customerId, CompanyName, ContactName, ContactTitle, Address
, City, Region, PostalCode, Country, Phone, Fax) VALUES ('ABCG2', 'ABC COMPUTACION', 'Juan Perez', 'Dr', 'Ciudad', 'Paris', NULL
,'01005', 'France', '12487-1234', '2423-8010')

----------------------------------------------------------------------------------------------
--Store Procedures
--Procedimientos almacenados

Alter procedure sp_sales_customerXD @Cliente varchar(10) --Sin parentesis
as
	select c.CustomerID, c.CompanyName, c.ContactName, c.Country
	, o.OrderID, o.OrderDate
	, p.ProductName
	, d.UnitPrice, d.Quantity
	from dbo.Customers as c 
	inner join dbo.Orders as o 
	on c.CustomerID = o.CustomerID
	inner join dbo.[Order Details] as d 
	on o.OrderID = d.OrderID
	inner join dbo.Products as p on d.ProductID = p.ProductID
	where c.CustomerID = @Cliente
	go

--call sp_sales_customerXD -- en otros 
Execute sp_sales_customerXD 'ALFKI'--Se puede usar exec

create procedure sp_insert_customerXD
@CustomerID varchar(5), @CompanyName varchar(100), @ContactName varchar(100)
, @ContactTitle varchar(100), @Address varchar(100)
, @City varchar(100), @Region varchar(50), @PostalCode varchar(15), @Country varchar(100)
, @Phone varchar(15), @Fax varchar(15)
as
	Insert into Customers (customerId, CompanyName, ContactName, ContactTitle, Address
	, City, Region, PostalCode, Country, Phone, Fax) VALUES (@CustomerID, @CompanyName
	, @ContactName, @ContactTitle, @Address
	, @City, @Region, @PostalCode, @Country, @Phone, @Fax)
	go

Exec sp_insert_customerXD 'SJDF', 'ASD COMPUTACION', 'Juan Perez'
, 'Dr.', 'Ciudad', 'Paris', NULL
, '01005', 'France', '12487-1234', '2423-8010'

Select * 
from customers 
where customerID = 'SJDF'
