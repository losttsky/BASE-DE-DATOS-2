create database MonetariosAhorrosMYSQL;
use MonetariosAhorrosMYSQL;
/*Creo tabla Monetarios*/
create table Monetarios(
Numerocuenta bigint not null primary key,
nombreCuenta varchar(500),
saldo decimal(15,2)
);
/*Creo tabla ahorros*/
create table Ahorros (
Numerocuenta bigint not null primary key,
nombreCuenta varchar(500),
saldo decimal(15,2)
);

/*Inserto datos*/
/*Datos Monetarios*/
insert into Monetarios values
(25010101, 'Juan Perez', 30000)
,(25010102, 'Juan Luis Garcia', 25000);
/*Datos Ahorros*/
insert into Ahorros values 
(10010101, 'Juan Perez', 0)
,(10010102, 'Juan Luis Garcia', 0);

/*Creo el procedimiento*/
/*Cambio el delimitador*/
Delimiter $$
create procedure traslado(
cuentaMonetaria bigint
,cuentaAhorros bigint
,Monto decimal(15,2)
,Orden varchar(10))
begin
	if(Monto < (select saldo from Monetarios as m where cuentaMonetaria = m.Numerocuenta) and Orden = 'Ahorros')
			then
				update monetarios set saldo = saldo - Monto where cuentaMonetaria = Numerocuenta;
				update ahorros set saldo = saldo + Monto where cuentaAhorros = Numerocuenta;
				select 'Saldo actualizado';
	elseif(Monto < (select saldo from Ahorros as a where cuentaAhorros = a.Numerocuenta) and Orden = 'Monetarios')
		then
				update monetarios set saldo = saldo + Monto where cuentaMonetaria = Numerocuenta;
				update ahorros set saldo = saldo - Monto where cuentaAhorros = Numerocuenta;
				select 'Saldo actualizado';
	else 
		select 'Saldo insuficiente';
	end if;
end
$$

/*Regreso al delimitador*/
Delimiter ;

/*Borro el procedimiento por si acaso*/
drop procedure traslado;

/*Llamo al procedimiento*/
call traslado (25010102, 10010102, 200, 'Ahorros');

/*Select a las tablas para ver que si funcionen*/
select * from Monetarios;
select * from Ahorros;

