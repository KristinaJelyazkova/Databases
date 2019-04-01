-- 1. �� ����� ������/������� �������� ���� �� ���������� ������, 
-- � ����� �� ��������� �����, ����������� � �� ����, �� ����� 
-- ������ ���������� � ��� ����� �� ������.

use movies;

select NAME, count(distinct v.STUDIONAME) as count_studios		
from MOVIESTAR m left join starsin s on m.NAME = s.STARNAME
				left join movie v on s.MOVIEYEAR = v.YEAR
								and s.MOVIETITLE = v.TITLE
group by NAME


-- 2. �� ��������������� �� ���� 2 ������� ��������, �������� ���� ��  
-- �������������� �� ��� PC-�� (������������ � ��������� printer � pc). 
-- ��� ������ ������������� ����� pc-��, � ��������� �� ��� 0.

use pc

select p1.maker, count(p2.code) as count_pc
from product p1 left join pc p2 on p1.model = p2.model
where p1.maker in (select r.maker
				from printer p join product r on p.model = r.model
				where p.type = 'Laser'
				group by r.maker
				having count(*) >= 2) 
group by p1.maker

-- 3. �� ����� ������, � ����� � ��������� �����, �� �� ������ ����� ��
-- ��������, ������� �� ���� ���� ���� ������
use ships 

select year(b.date) as year, count(distinct s.name) as count_ships
from battles b left join ships s on year(b.date) = s.launched
group by year(b.date)

-- 4. �������� ���� �� ���������� ����������� ������ �� ����� ��������� 
--    ����� � ���� ���� ������� ����������� �����.
use ships

select battle, count(*) as count_usa_sunk_ships
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
where c.COUNTRY = 'USA' and o.RESULT = 'sunk'
group by battle

-- 5. �� ����� ������� �� �� ������ ����� �� ����������� ������ � ����� 
--    �� ���������� ������. ����� �� �������� ���� �� ���� � ����.
use ships

select c.country, sum(case o.result
						when 'damaged' then 1
						else 0
					end) as count_damaged,
				sum(case o.result
						when 'sunk' then 1
						else 0
					end) as count_sunk
from classes c left join ships s on c.CLASS = s.CLASS
				left join outcomes o on s.NAME = o.SHIP
group by c.country

-- 6. �������� ������� �� �������, � ����� �� ��������� ���� 3 ������ � 
--    ��� 10 ������ � �� ��� ���� ��� �� � �������� �ok�
use ships

select o.battle
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
where c.numguns < 10
group by o.battle
having count(*) >= 3 and sum(case o.result
									when 'ok' then 1
									else 0
							end) >=2