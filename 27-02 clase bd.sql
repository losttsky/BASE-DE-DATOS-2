--Subconsultas
Select T.productname, T.unitprice, s.companyname from
	(Select p.productname, p.unitprice, c.categoryname, p.supplierid
	from products as p inner join categories as c
	on p.CategoryID = c.CategoryID)as T
	inner join suppliers as s on T.supplierid=s.supplierid
where T.Categoryname = 'Beverages'

-- Obtener la varianza de precios
Select productname, unitprice,
(Select avg(Unitprice) from products) as promedio,
unitprice-(Select avg(Unitprice) from products) as varianza
from products

-----------------------------------
Select companyname, country, phone, fax from customers
where customerid in
(Select distinct customerid from orders)

-- 
Select c.companyname, c.country, c.phone, c.fax from customers as c
where not exists
(Select distinct o.customerid from orders as o
where c.customerid = o.customerid)

-- Ver los indices
Execute sp_helpindex Customers

Select City, PostalCode from Customers
where City = 'México D.F.'

-- Crear una tabla a partir de registros de otra tabla
	--# tabla temporal (dura mientras la sesión existe) 
	--## permite que la tabla temporal sea vista por otros usuarios
Select * 
into Clientes 
from customers

Select * from Clientes where customerid like 'BOTTM'
go