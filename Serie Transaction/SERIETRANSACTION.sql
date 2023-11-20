create database Serie_Transaction;
use Serie_Transaction;
drop table Transfert ;
create table Salle (NumSalle int primary key , Etage int, NombreChaises int);
create table Transfert (NumSalleOrigine int not null, NumSalleDestination int not null , DateTransfert date , NbChaisesTransférées int
);
alter table Transfert  add constraint  fk_numsalleorigine  foreign key (NumSalleOrigine) references Salle (NumSalle);
alter table Transfert add constraint fk_numsalledestination foreign key (NumSalleDestination) references Salle (NumSalle);#
alter table Salle add constraint chk_nbrchaise check (NombreChaises between 20 and 30 );
alter table Salle modify Etage int;
#3
insert into Salle values (1,1,24);
insert into Salle values (2,1,26),(3,1,26),(4,2,28);
 
#4
#a
drop procedure if exists deplacer;
delimiter $$
create procedure deplacer ()
begin
declare SallOrigine int default 2;
declare SalleDest int default 3;
declare Nbchaises int default 4;
declare dateTransfert Date default current_date();
declare flag boolean default false;
begin
declare exit handler for sqlexception 
		begin
			rollback;
			set flag = true;
		end;
		start transaction;
        update Salle set NombreChaises = NombreChaises- Nbchaises where NumSalle=SallOrigine;
        update Salle set NombreChaises = NombreChaises+ Nbchaises where NumSalle=SalleDest;
        insert into  Transfert values ( SallOrigine , SalleDest ,dateTransfert, Nbchaises);
        commit;
        select "deplacement avec success";
        end;
	if flag then
    select 'Impossible d’effectuer le transfert des chaises';
    end if;
    
    end$$
delimiter ;
call deplacer();