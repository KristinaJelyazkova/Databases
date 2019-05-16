-- �������� �� Ships ������ �������� � ����� ������.
delete from ships
where name in (select distinct ship
				from outcomes
				where result = 'sunk')

select * from ships

select * from ships s
join outcomes o on s.name = o.ship
where o.result = 'sunk'

-- 2. �������� ������ ������� � ��-����� �� 3 ������.
delete from classes
where class in (select class
				from ships
				group by class
				having count(*) < 3)
	or class not in (select distinct class
					from ships)

-- 3. �������� ������ �� ��������� Battles, ����� �� ��������� ���
-- ��������� �� ��������� �� �����, ���� ������� ������� � �� 
-- ��������� �� Outcomes.
go

create trigger on_del_battle on battles
after delete
as
delete from outcomes
where ship in (select name
				from deleted)

go

select *
from battles b join outcomes o
	on b.name = o.battle

delete from battles
where name = 'North Atlantic'

-- 4. �������� ������, ����� �� �� ��������� ��� ��������� �� �����
-- � ��������� Outcomes. �������� �� ���������, �� �������, ����� 
-- �� �������� � Outcomes, �� Ships (launched) < Battles (Date), � 
-- �������� ������ �� ������� ��������� �� ������.
go

create trigger on_ins_outcomes on outcomes
after insert
as
if exists (select *
			from inserted i left join ships s on i.ship = s.name
					left join battles b on i.battle = b.name
			where s.launched is NULL or b.date is NULL
				or s.launched >= year(b.date))
	begin print 'Error!'
			rollback
	end

go

