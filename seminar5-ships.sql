-- 2.1. �������� ������, ����� ������� ���� �� ��������� ������
select count(*) as class_count
from classes

-- 2.2. �������� ������, ����� ������� ������� ���� �� ������ �� 
--      ������ ������, ������� �� ����
select avg(numguns) as avg_numguns
from classes c join ships s on c.class = s.CLASS

-- 2.3. �������� ������, ����� ������� �� ����� ���� ������� � 
--      ���������� ������, � ����� ����� �� ���������� ���� � ������ �� ����
select class, min(launched) as first_launched, max(launched) as last_launched
from ships
group by class

-- 2.4. �������� ������, ����� ������� ���� �� �������� �������� � ����� 
--      ������ �����
select c.class, sum(case o.result
							when 'sunk' then 1
							else 0
					end ) as count
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.name = o.ship
group by c.class

select c.class, count(o.ship)
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.name = o.ship and o.result = 'sunk'
group by c.class

-- 2.5. �������� ������, ����� ������� ���� �� �������� �������� � ����� 
--      ������ �����, �� ���� ������� � ������ �� 4 ������� �� ���� ������
select s.class, count(o.ship)
from ships s left join outcomes o 
				on s.name = o.ship and o.result = 'sunk'
where s.class in (select class
					from ships
					group by class
					having count(*) > 4)
group by s.class

select class, sum(case result
						when 'sunk' then 1
						else 0
					end)
from ships s left join outcomes o on s.NAME = o.SHIP
group by class
having count(distinct name) > 4

-- 2.6. �������� ������, ����� ������� �������� ����� �� ��������, �� ����� ������. 
select country, avg(displacement) as avg_weight
from classes
group by country
