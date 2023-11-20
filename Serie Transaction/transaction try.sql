create database bank;
use bank;
create table banc (
accname varchar(50) primary key, 
montant float check (montant between 0 and 50000)
);

drop table bank;

insert into banc  values('ac1',30000),('ac2',40000);


drop procedure if exists virement ;
delimiter $$
create procedure virement (acc1 varchar (50), acc2 varchar(50) , amount float)
begin
declare flag boolean default false;
begin
declare exit handler for sqlexception
begin
rollback;
set flag =true; 
end;
start transaction;
update banc set montant = montant -amount where accname=acc1;
update banc set montant = montant +amount where accname=acc2;
commit;
select 'virement effectue';
end ;
if flag then 
select 'virement annulé';
end if;
end$$
delimiter ;
call virement ('ac1','ac2',5000);
select*from banc;
