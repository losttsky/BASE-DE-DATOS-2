use pruebaXD;
go

--func escalar, devuelve funcion 
create function Iva (@valor money)
returns money
as 
begin 
	declare @Resultado money 
	set @Resultado = @valor * 0.12
	return @Resultado
end 
go 

select productname, unitprice, dbo.Iva(unitprice) as Iva from products
go

--crear una funcion donde si la venta de la orden son mayores a mil que indique que es buen cliente
-- si no entonces que diga lo contrario

create function typeorder (@valor money)
returns varchar(100)
as
begin 
	declare @resultado varchar(150)
	if @valor > 1000 set @resultado = 'Buena venta'
	else set @resultado = 'Mala venta'
	return @resultado
end
go 

--ventas
select c.companyname, c.country, o.orderid, o.orderdate
, sum(d.unitprice * d.quantity) as total
, dbo.typeorder(sum(d.unitprice * d.quantity)) as typeorder
, dbo.convertirnumero(sum(d.unitprice * d.quantity)) as letra
from customers as c inner join orders as o on c.customerid = o.customerid
inner join [order details] as d on o.orderid = d.orderid
group by c.companyname, c.country, o.orderid, o.orderdate

--Funciones de tabla en línea
/*Son un hhíbrido entre procedimiento almacenado y vista*/

--Funcion se le ingresan dos fechas y devuelve las ordenes de ese rango de fechas
Create function fn_Order_list_date (@fechainicio date, @fechafin date)
returns table
as
Return(select c.companyname, c.country, o.orderid, o.orderdate
, sum(d.unitprice * d.quantity) as total
, dbo.typeorder(sum(d.unitprice * d.quantity)) as typeorder
, dbo.convertirnumero(sum(d.unitprice * d.quantity)) as letra
from customers as c inner join orders as o on c.customerid = o.customerid
inner join [order details] as d on o.orderid = d.orderid
where o.orderdate between @fechainicio and @fechafin
group by c.companyname, c.country, o.orderid, o.orderdate
)

Select * from fn_Order_list_date('1997-03-01','1997-03-31')

/*
create function nombre_funcion (parametros)
returns table
as 
return (query...)
go
*/


/*Funciones de tablas de multiples instrucciones*/
--funcion que retorne productos vendidos en un rango de fechas
alter function fn_order_products_date(@fechainicio date, @fechafin date)
returns @product table
		(Productname varchar(200), unitprice money, categoryname varchar(200))
as
begin
	insert into @product select distinct p.productname, p.unitprice, ca.categoryname
	from orders as o inner join [order details] as d on o.orderid = d.orderid
	inner join products as p on d.productid = p.productid
	inner join categories as ca on p.categoryid=ca.categoryid
	where o.orderdate between @fechainicio and @fechafin
return 
end

select * from fn_order_products_date ('1997-03-01','1997-03-31')

--consulta de ventas 
-- 1dhl, 2fedex, 3ups

--funcion para pasar a shipvia

select c.companyname, c.country, o.orderid, o.orderdate, 
case o.ShipVia
	when 1 then 'DHL'
	when 2 then 'Fedex'
	when 3 then 'UPS'
	else 'Other'
end as ShipVia,
isnull(c.fax,'---') as fax,
coalesce(c.fax, c.phone, '---') as fax2,
case  
	when c.fax is NULL then '---'
	else c.fax
end as Fax3
, sum(d.unitprice * d.quantity) as Total
from customers as c inner join orders as o on c.customerid = o.customerid
inner join [order details] as d on o.orderid = d.orderid
group by c.companyname, c.country, o.orderid, o.orderdate, o.ShipVia, c.fax, c.phone

/*
cada orden es despachada por un empleado, cada empleado recibe una comision de 2% por orden
cada empleado tiene un jefe, el jefe recibe una comision del 1% por cada orden que hizo un sub
alterno
Muestre las comisiones de los jefes y subalternos o empleados 
*/
--Version MIA 
select o.orderid as Orden
, concat(e.firstname, ' ', e.lastname) as Empleado
, concat(re.Firstname, ' ', re.Lastname) as Jefe
, SUM((d.unitprice * d.quantity)) as Venta
, SUM((d.unitprice * d.quantity)*0.02) as Comision_Empleado
, SUM((d.unitprice * d.quantity)*0.01) as Comision_Jefe
from employees as e inner join employees as re on e.reportsto = re.employeeid
inner join orders as o on e.employeeid = o.employeeid
inner join [order details] as d on o.orderid = d.orderid
inner join products as p on p.productid = d.productid
group by o.orderid, e.firstname, e.lastname, re.Firstname, re.Lastname

--Version INGE
select t.firstname, t.lastname, sum(t.comision) as comision from
(
Select e.firstname, e.lastname
,sum(d.unitprice * d.quantity) * 0.02 as Comision
from orders as o inner join [order details] as d on o.orderid = d.orderid
inner join employees as e on o.employeeid = e.employeeid
group by e.firstname, e.lastname
union all
select j.firstname, j.lastname
, sum(d.unitprice * d.quantity) * 0.01 as Comision
from orders as o inner join [order details] as d on o.orderid=d.orderid
inner join employees as e on o.employeeid=e.employeeid
inner join employees as j on e.reportsto = j.employeeid
group by j.firstname, j.lastname
) as t 
group by t.firstname, t.lastname

