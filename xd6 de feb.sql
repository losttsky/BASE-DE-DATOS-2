/*Crear vista, si ya existe entonces reemplazarla con las nuevas modificaciones*/
create or replace view vw_salesreport
as
select c.customerid, c.companyname, c.country
, o.orderid, o.orderdate, p.productname, d.unitprice
, d.quantity, (d.unitprice * d.quantity) as Total
from customers as c 
inner join orders as o on c.customerid=o.customerid
inner join orderdetails as d on o.orderid = d.orderid
inner join products as p on p.productid = d.productid
inner join categories as ca on ca.categoryid=p.categoryid;

/*Ejecutar la visa*/
select * from vw_salesreport

/*Procedimiento Almacenado*/
delimiter $$
create procedure proc_sales( 
IN par_codigocliente varchar(5))
begin
	select * from vw_salesreport
	where customerid=par_codigocliente ;
end
$$
Delimiter ;

drop procedure proc_sales;

/*Ejecutar el procedure*/
call proc_sales('BERGS');

/*Procedimiento con parametro de salida*/
delimiter // 
create procedure proc_ordercount(
IN parCodigocliente varchar(5), out parnumberrows bigint)
begin
	select count(*) into parnumberrows from orders 
    where customerid=parCodigocliente; 
end
//
delimiter ;

delimiter $$
create procedure proc_deletecustomer(
parcustomerid varchar(5))
begin
	declare var_numero bigint;
	call proc_ordercount(parcustomerid, var_numero) ;
	select var_numero;
    if var_numero=0 then
		delete from customers where customerid=parcustomerid;
        SELECT 'si lo borre';
	else 
		select 'No es posible borrar un ciente con ordenes';
	end if;
end
$$
delimiter ;

drop procedure proc_ordercount;
drop procedure proc_deletecustomer;

/*probar el procedimiento*/
set sql_safe_updates=0;
call proc_deletecustomer ('PARIS');

/*Regresar a las consultas*/
select e.employeeid, e.lastname, e.firstname, concat(ee.firstname, ' ', ee.lastname) as Le_Reporta_A
from employees as e inner join employees as ee on e.reportsto=ee.employeeid;


