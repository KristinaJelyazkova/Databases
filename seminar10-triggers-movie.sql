-- Да се напише тригер за таблицата MovieExec, който не позволява 
-- средната стойност на Networth да е по-малка от 500 000 (ако при
-- промени в таблицата тази стойност стане по-малка от 500 000, 
-- промените да бъдат отхвърлени).
go

create trigger tr_networth on movieexec
after insert, update, delete
as
if (select avg(networth)
	from movieexec) < 500000
begin
	raiserror('Average Networth below 50000', 11, 1)
	rollback
end

go

drop trigger tr_networth

select *
from movieexec

insert into movieexec(cert#, name, networth) values (700, 'austin powers', -2000000000)
delete from movieexec where cert# = 700
