-- �� �� ������ ������ �� ��������� MovieExec, ����� �� ��������� 
-- �������� �������� �� Networth �� � ��-����� �� 500 000 (��� ���
-- ������� � ��������� ���� �������� ����� ��-����� �� 500 000, 
-- ��������� �� ����� ����������).
go

create trigger tr_networth on movieexec
after insert, update
as
if (select avg(networth)
	from movieexec) < 500000
begin
	print 'Networth error!'
	rollback
end

go

drop trigger tr_networth

select *
from movieexec

insert into movieexec(cert#, name, networth) values (700, 'austin powers', -2000000000)
delete from movieexec where cert# = 700