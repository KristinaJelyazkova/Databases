-- 3.1. �������� ������, ����� �� ����� ����� ������� ����� ��, ���������,
--      ���� ������ � �������� �� ������� (launched).
select name, country, numguns, launched
from ships s join classes c on s.CLASS = c.CLASS



-- 3.2. �������� ������, ����� ������� ������� �� ��������, ��������� � �����
--      �� 1942�.
select distinct ship
from outcomes o join BATTLES b on o.BATTLE = b.NAME
where year(date) = 1942

-- 3.3. �� ����� ������ �������� ������� �� ��������, ����� ������ �� ��
--      ��������� � �����.
select country, name
from classes c join ships s on c.CLASS = s.CLASS
				left join outcomes o on s.NAME = o.SHIP
where o.SHIP is NULL

-- ������������ ������

-- ������� �� ���������, �� ����� ���� �����, ������ �� ����
-- (launched) ���� 1921 �. ��� �� ����� ���� ������ ������� �����,
-- ��� ���� ������ �� ������ � ���������.
select distinct c.class
from classes c left join ships s on c.CLASS = s.CLASS and s.launched > 1921 
where s.name is NULL

select distinct class
from classes
where class not in (select class
					from ships
					where LAUNCHED > 1921)
