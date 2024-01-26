--Proceso almacenado
Create procedure sp_par_impar
as
Declare @numero int 
set @numero = 0
while (@numero<=10)
Begin
	if (@numero%2=0)
		print 'El numero ' + Cast(@numero as varchar(10)) + ' es par'
	else
		print 'El numero ' + Cast(@numero as varchar(10)) + ' es impar'
	set @numero=@numero+1
End
go
Execute sp_par_impar
go

------------------------------------------------------------------------
select * from customers

--proceso almacenado que borra datos de la tabla customers
Create procedure sp_delete_customersxd @codigocliente varchar(5)
as
	if ((select count(*) from orders where customerID=@codigocliente))>0
		Begin
			Delete from [Order Details] where orderid in (
				Select orderid from orders where customerid = @codigocliente
			)
			Delete from orders where customerid = @codigocliente
			Delete from customers where customerid = @codigocliente
		End
	else
		Delete from customers where customerid = @codigocliente
go

execute sp_delete_customers1 'ANATR'

------------------------------------------------
-- Insertar datos en una tabla usando un select
insert into customers (customerid, companyname)
select  substring(replace(companyname, ' ',''),1,4)+'5', companyname from suppliers

-- Actualizar datos de una tabla respecto a otra
Update customers set companyname = 'Juanito Perez' 
where customerid='ALFKP'
--
Select * from customers where country='Argentina' --auxj9
Select * from orders where customerid = 'CACTU' or customerid = 'OCEAN' 
or customerid = 'RANCH'

Select o.orderid, o.customerid, c.country
from customers as c inner join orders as o on c.customerid = o.customerid
where c.country = 'Argentina'

--
Update o set o.customerid = 'auxj9'
from customers as c inner join orders as o on c.customerid = o.customerid
where c.country = 'Argentina'


--- ELIMINAR DATOS DE UNA TABLA CON RESPECTO A UNA CONDICION DE UN CAMPO DE OTRA TABLA
Select o.orderid, o.orderdate, d.productid
from [order details] as d inner join orders as o
on o.orderid = d.orderid
where o.customerid='ANTON'

Delete from d
from [order details] as d inner join orders as o
on o.orderid = d.orderid
where o.customerid='ANTON'
-----------
Delete from customers where customerid = 'ALFKP'