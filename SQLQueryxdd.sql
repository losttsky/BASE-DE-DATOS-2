Use Northwind
go
select * from products

--Procedimientos almacenados
--Parametros de salida

alter procedure sp_conteoclientes1 
@pais varchar(100), @filasdevueltas bigint output
as
set @filasdevueltas = (select count(*) from customers where country = @pais)
go

alter procedure sp_conteoordenes1 
@cliente varchar(5),@filasdevueltas bigint output
as
set @filasdevueltas = (select count(*) from orders as c where customerid = @cliente)
go

alter procedure sp_eliminarOrdenes 
@Cliente varchar(100)
as
begin 
	declare @Test22 bigint
	exec sp_conteoordenes1 @Cliente, @Test22 output
	if(@Test22 = 0)
		begin
			delete from customers where customerid = @cliente
			print 'Se elimino al cliente ' + @Cliente
		end
	else 
		print 'Error al eliminar a ' +  @Cliente + ', aun con ordenes existentes'
end

--Ejecucion
declare @Test2 bigint
exec sp_conteoclientes1 'Argentina', @Test2 output
select @Test2
go

exec sp_eliminarOrdenes 'ALFKI'
go

--Crear un procedimiento de traslado 
create table Monetarios(
Numerocuenta bigint not null primary key,
nombrecuenta varchar(500),
saldo money 
)
go
insert into monetarios values(25010101, 'Juan Perez', 30000)
,(25010102, 'Juan Luis Garcia', 25000)


create table Ahorros(
Numerocuenta bigint not null primary key,
nombrecuenta varchar(500),
saldo money 
)
go
insert into Ahorros values(10010101, 'Juan Perez', 0)
,(10010102, 'Juan Luis Garcia', 0)


alter procedure traslado
@cuentaMonetaria bigint
,@cuentaAhorros bigint
,@Monto money
,@Orden varchar(10)
as
--select * from Monetarios where @cuentaMonetaria = Numerocuenta
	if(@Monto < (select saldo from Monetarios as m where @cuentaMonetaria = m.Numerocuenta) and @Orden = 'Ahorros')
			begin
				update monetarios set saldo = saldo - @Monto where @cuentaMonetaria = Numerocuenta 
				update ahorros set saldo = saldo + @Monto where @cuentaAhorros = Numerocuenta
				print 'Saldo actualizado'
			end
	else if(@Monto < (select saldo from Ahorros as a where @cuentaAhorros = a.Numerocuenta) and @Orden = 'Monetarios')
			begin
				update monetarios set saldo = saldo + @Monto where @cuentaMonetaria = Numerocuenta 
				update ahorros set saldo = saldo - @Monto where @cuentaAhorros = Numerocuenta
				print 'Saldo actualizado'
			end
	else 
		print 'Saldo insuficiente'

go

exec traslado 25010102, 10010102, 200, Monetarios
select * from Monetarios
select * from Ahorros

select * 
into deletecustomers --crear un nuevo objeto a partir de los datos de una nueva tabla 
from customers
go 
--Consultar la tabla creada
select * from deletecustomers
go
--Eliminar datos de la tabla creada 
/*delete*/truncate table deletecustomers
go

-- un trigger es una reaccione un procedimiento de acuerdo a si hubo insert update o delete, es reactivo
create trigger TR_DELETE_CUSTOMERS
on CUSTOMERS FOR DELETE -- lo correcto es poner AFTER o FOR en sql server
as
insert into deletecustomers
select * from deleted 
go

delete customers where customerid='PARIS'
GO

SELECT * FROM [Order Details] 
select * from products 

create trigger tr_update_unitsinstock
on [order details] for insert 
as 
--select d.orderid, p.prodcutid, p.productname, d.unitprice, d.quantity 
update p set p.unitsinstock=p.unitsinstock-i.quantity
from inserted as i
inner join products as p 
on i.productid=p.productid

select * from products where productid= 22 --104
select * from [order details] where orderid=10248
insert into [order details](orderid,productid,unitprice,quantity,discount)
values(10248,22,21,20,0)