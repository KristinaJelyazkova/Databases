--1. ��� ���������� ���������� � �������� �� ������ �����, �������
-- ����� 1982, � ����� � ����� ���� ���� ������ (�������), ����� 
-- ��� �� ������� ���� ������� 'k', ���� 'b'. ����� �� �� �������
-- ���-������� �����.
use movies

select distinct title, year
from movie m join starsin s 
	on m.TITLE = s.MOVIETITLE and m.YEAR = s.MOVIEYEAR
where year < 1982 and s.STARNAME NOT LIKE '%k%' and
	s.STARNAME NOT LIKE '%b%'
order by year asc

--2. ���������� � ��������� � ������ (length � � ������) �� 
-- ������ �����, ����� �� �� ������ ������, �� ����� � � ������ 
-- Terms of Endearment, �� ��������� �� � ��-����� ��� ����������.
use movies

select title, cast(length as float)/60 as hours
from movie
where year = (select year
				from movie
				where title = 'Terms of Endearment')
		and (length < (select length
				from movie
				where title = 'Terms of Endearment')
		or length is NULL)

-- 3. ������� �� ������ ����������, ����� �� � ������� ������ � 
-- �� ������ � ���� ���� ���� ����� 1980 �. � ���� ���� ���� 
-- 1985 �.
use movies

select name
from MOVIEEXEC m join starsin s on m.NAME = s.STARNAME
group by name
having min(s.MOVIEYEAR) < 1980 and max(s.MOVIEYEAR) > 1985

-- 19. (*) �� ����� ����� �������� ���� �� �������, � ����� � 
-- ��� �������. ��� ������� �� � �������� � ����� ��� ��� ������ 
-- �� � ��� ��������, � ��������� �� �� ������ 0.
use ships

select name, sum(case o.result
					when 'damaged' then 1
					else 0
				end) as count_damaged
from ships s left join outcomes o
		on s.NAME = o.SHIP
group by name


-- 20. (*) �������� �� ����� ���� � ���� 3 ������ ���� �� 
-- �������� �� ���� ����, ����� �� �������� � �����.
use ships

select class, (select count(distinct name)
				from ships a join outcomes w on a.name = w.SHIP
				where a.class = s.class and w.RESULT = 'ok')
from ships s left join outcomes o on s.NAME = o.SHIP
group by class
having count(distinct name) >= 3

-- 5. ������� � �������� �� ��������, ����� �� �������� � ��-�����
-- �� 5 �������� ������� ������1. ������, �� ����� ���� �������� 
-- ����� ��� ���, �� �� �� ���� ��� ������� �� ������ � ���, ����
-- �� ����� ��������. ����� �� �� ������� ��������, �������� � 
-- ���-����� ������.
use movies

select name, address, count(distinct i.STARNAME)
from studio s left join movie m on s.NAME = m.STUDIONAME
				left join STARSIN i on m.TITLE = i.MOVIETITLE
								and m.YEAR = i.MOVIEYEAR
group by name, address
having count(distinct i.STARNAME) < 5
order by count(distinct i.STARNAME) desc

-- 10. �� ����� ����� �� �� ������ �������� ���� ������ �� 
-- ���� � ���� ������� (�������� � ������� ��� Guadalcanal �� 
--��������� 3 ����������� � ���� ������� �����, �.�.
-- �������� ���� � 2).
use ships

select battle, avg(count) as avg
from (select o.battle, count(*) as count
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
group by o.battle, c.COUNTRY) t
group by battle

-- 15. �� �� ������� ���������� ������ ��������, ��������� �� 
-- ���� �� ���-������ ��������� �������� �� ����� �����.
use pc

select model
from pc
group by model
order by max(price) asc




