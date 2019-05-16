--�������� �������� ������� �� ��������� �� ������ �� ����� PC. ���
-- ��������� �� ������������ ��������� �� �����������:

--��� ������� �� ������ �� ����� �������� �� �������, �� ���� 
-- �������� � ��-����� ���� � ������ ������� �� ���������;
use pc

go

create trigger tr_price_pc on pc
after update
as
if exists(select *
		from inserted i join pc p on i.speed = p.speed
		where p.price < i.price)
begin
	rollback
end

go

drop trigger tr_price_pc

--  ����� ������������ �� �������� �� ���� �� ���������� � ��������;
go
create trigger tr_maker on product
after insert, update
as
if exists(select *
			from inserted i join product p on i.maker = p.maker
			where (i.type = 'PC' and p.type = 'Printer')
					or
					(i.type = 'Printer' and p.type = 'PC'))
begin rollback
end
go

drop trigger tr_maker

-- ����� ������������ �� �������� ������ �� ���������� � ������, 
-- ����� �� ��� ������ ��� ��-������ ������� �� ���������;
go
create trigger tr_maker2 on pc
after insert, update
as
if not exists(select *
			from inserted i join product p on i.model = p.model
				join product c on p.maker = c.maker and c.type = 'Laptop'
				join laptop l on c.model = l.model
			where l.speed >= i.speed)
begin rollback
end
go

select * from product

-- ��� ��������� �� ������� � ��������� Laptop �� �������, �� 
-- �������� ���� �� ��������� �� ����� ������������ � ���� 2000
go

create trigger tr_laptop_price on laptop
after update, insert
as
if exists(select *
			from laptop l join product p
				on l.model = p.model
			group by p.maker
			having avg(l.price) < 2000)
begin rollback
end
go

-- ��� ���������� �� RAM ��� HD �������� �� ����� �������� �� 
-- �������, �� ������� ���� � ���� 100 ���� ��-����� �� �������
go

create trigger tr_ram_hd on pc
after update
as
if exists(select *
			from inserted
			where hd < 100 * ram)
begin rollback
end

go

-- ��� ����� ������ ��� ������ ����� �� ����� �������� ������ 
-- �� ���� � ��-���� �� ����
go

create trigger tr_ram on laptop
after insert, update
as
if exists(select *
			from inserted i join pc p on i.ram > p.ram
			where i.price <= p.price)
begin rollback
end

go

-- ��� ���������� �� ��� ��������, ������ ��� ������� �� �������, 
-- �� ������ �� ���������� � ��������� PC, Laptop � Printer
go

create trigger tr_model_pc on pc
after insert
as
if exists(select *
			from inserted
			where model in (select model from pc
							union
							select model from laptop
							union
							select model from printer))
begin rollback
end

go

-- ��� � ��������� Products � ��������� ����� ����� � ������� ���, 
-- �� ���� ����� ������ �� �� ������ � � ����� �� ��������� � 
-- ���������� �� ����
go

create trigger tr_prod on products
after insert, update
as
if exists(select *
		from inserted
		where type = 'PC' and model not in(select model
											from pc))
	or
	exists(select *
		from inserted
		where type = 'Laptop' and model not in(select model
											from laptop))
	or
	exists(select *
		from inserted
		where type = 'Printer' and model not in(select model
											from printer))
begin rollback
end

go

