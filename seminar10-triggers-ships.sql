-- ��� ���������� �� ��� ���� � ��������� Classes �������� � ����� 
-- ��� ������ ��� � ��������� Ships, ����� �� ��� ���� �� ������� 
-- NULL
go

create trigger tr_class on classes
after insert
as
insert into ships(name, class)
	select class, class
	from inserted

go

-- ��� ���� ������� ��� ���� � ��������������� ��-������ �� 35000, 
-- �������� ����� � ���������, �� �� ������� ��������������� 35000
go

create trigger tr_disp on classes
instead of insert
as
insert into classes(class, type, country, numguns, bore, displacement)
	select class, type, country, numguns, bore, displacement
	from inserted
	where displacement <= 35000
	union
	select class, type, country, numguns, bore, 35000
	from inserted
	where displacement > 35000

go


-- ����� ���� �� ���� �� ��� ������ �� ��� ������
go

create trigger tr_ships_cl on ships
instead of insert 
as
if not exists(select *
			from inserted
			where class in (select class
							from ships
							group by class
							having count(*) >= 2))
begin insert into ships
			select *
			from inserted
end

go

drop trigger tr_ships_cl

select *
from ships

insert into ships(name) values ('hey')


-- ����� � ������ �� 9 ������ �� ���� �� ������� � ����� � �����, 
-- ����� � � ��-����� �� 9 ������
go

create trigger tr_numguns on outcomes
after insert
as
if exists(select *
			from inserted i join ships s on i.ship = s.name
				join classes c on s.class = c.class
			where (c.numguns > 9 and i.battle in (select distinct battle 
												from outcomes o join ships s1 on o.ship = s1.name
																join classes c1 on s1.class = c1.class
												where c1.numguns < 9))
			or
			(c.numguns < 9 and i.battle in (select distinct battle 
												from outcomes o join ships s1 on o.ship = s1.name
																join classes c1 on s1.class = c1.class
												where c1.numguns > 9)))
begin rollback
end

go

-- ��� ���������� �� ��� ����� � ��������� Outcomes �� �������, ��
-- ������� � ������� ����������� � ��������� Ships � Battles. ��� 
-- �� ����������� �������� ������������ �� ��� � ����������� 
-- ��������� ���� �������� NULL ���������, ������ � ����������
go

create trigger tr_out on outcomes
after insert
as
insert into battles(name)
		select battle
		from inserted
		where battle not in (select name
							from battles)
insert into ships(name)
		select ship
		from inserted
		where ship not in (select name
							from ships)

go

-- ��� ���������� �� ��� ����� ��� ��� ������� �� ����� �� ����� 
-- ����� �� �������, �� ����� ������� ���� ������ �� 20 ������;
go

create trigger tr_20ships on ships
after insert, update
as
if exists(select country
		from classes c join ships s on c.class = s.class
		group by country
		having count(distinct s.name) > 20)
begin rollback
end

go

-- �����, ����� ���� � ������� �� ���� �� ������� � �����, ����� 
-- ���� � ���� ������ �� ���������� ��
go

create trigger tr_sunk on outcomes
after insert, update
as
if exists(select *
			from outcomes o1 join outcomes o2 on o1.ship = o2.ship
				join battles b1 on o1.battle = b1.name
				join battles b2 on o2.battle = b2.name
			where o1.result = 'sunk' and b1.date < b2.date)
begin rollback
end

go