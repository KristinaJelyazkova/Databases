-- 1. �� ����� ������� ������ �� �� ������ �����, ��������� ���� � � ���
--    ������ � ��������� ���-����� �����. (��� ��� ��� ������ � ������� 
--    ���� �����, �� �� ������ ��� �� � �� ���)

use movies

select *
from MOVIESTAR

select *
from starsin

select * from movie

use movies

select distinct m.NAME, m.BIRTHDATE, v.STUDIONAME
from MOVIESTAR m join starsin s on m.NAME = s.STARNAME
				join movie v on s.MOVIETITLE = v.TITLE and s.MOVIEYEAR = v.YEAR
where v.STUDIONAME = (select min(studioname)
					from (select l.studioname
					from (select studioname, count(*) as count
								from movie m1 join starsin s1 on m1.TITLE = s1.MOVIETITLE and m1.YEAR = s1.MOVIEYEAR
								where s1.STARNAME = m.NAME
								group by STUDIONAME) l
					where l.count = (select max(t.count)
									from (select studioname, count(*) as count
											from movie m1 join starsin s1 on m1.TITLE = s1.MOVIETITLE and m1.YEAR = s1.MOVIEYEAR
											where s1.STARNAME = m.NAME
											group by STUDIONAME) t)) h)

-- 2. �� �� ������� ������ �������������, �� ����� �������� ���� �� 
--    ������������� �������� � ��-����� �� �������� ���� �� ������� �������.
use pc

select distinct t.maker
from product t
where (select avg(l.price)
		from (select price
				from pc c join product p on c.model = p.model
				where p.maker = t.maker) l) < 
	(select avg(l.price)
		from (select price
				from laptop c join product p on c.model = p.model
				where p.maker = t.maker) l)

-- 3. ���� ����� �������� ���� �� �� �������� � ������� ������������ 
--    � ���������� �������� ����. �� �� ������� ���� ������ ��������,
--    ����� ������ ���� (�� ���������� �� ������������) � ��-�����
--    �� ���-������� ������, ����������� �� ����� ������������.
use pc

select p.model
from pc p
group by p.model
having avg(price) < (select min(price) as min_price
						from (select price
								from laptop l join product d on l.model = d.model
								where d.maker = (select maker
													from product
													where model = p.model)) t)

-- 4. �������, � ����� �� ��������� ���� 3 ������ �� ���� � ���� ������.
use ships

select o.battle
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
group by o.battle, c.COUNTRY
having count(distinct o.SHIP) >= 3

use ships

select *
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
order by o.BATTLE, c.COUNTRY


-- 5. �� ����� ����� �� �� ������ ����� �� �������, � ����� � ��� �������.
--    ��� ������� �� � �������� � ����� ��� ��� ������ �� � ���
--    ��������, � ��������� �� �� ������ 0.
use ships

select s.name, sum(case o.result
							when 'damaged' then 1
							else 0
					end) as count_battles_damaged
from ships s left join outcomes o on s.NAME = o.SHIP
group by s.name

use ships
select *
from outcomes

-- 6. �� ����� ���� �� �� ������ �����, ��������� � ������� ������, � ����� 
--    � ������ ����� �� ���� ����
use ships

select c.class, c.country, (select min(t.launched)
						from (select launched
								from ships
								where class = c.class) t)  as first_launched
from classes c

select *
from classes c join ships s on c.class = s.class
order by c.class, s.LAUNCHED

-- 7. �� ����� ������� �� �� ������ ����� �� �������� � ����� �� ���������� 
--    ������. ����� �� �������� ���� �� ���� � ����.
use ships

select country, count(distinct s.name) as count_ships, sum(case o.result
													when 'sunk' then 1
													else 0
											end) as count_sunk_ships
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.NAME = o.SHIP
group by country


-- 8. �������� �� ����� ���� � ���� 3 ������ ���� �� �������� �� 
--    ���� ����, ����� �� � �������� ok.
use ships

select c.class, sum(case o.result
							when 'ok' then 1
							else 0
					end) as count_ok_ships
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.NAME = o.SHIP
group by c.class
having count(distinct s.name) >= 3

-- 9. �� ����� ����� �� �� ������ ����� �� �������, �������� �� 
--    ������� � ����� �� ���������� ������, ����� �� �����������
--    ������ � ����� �� �������� ��� �������.
use ships

select name, year(b.date) as year, sum(case o.result
									when 'sunk' then 1
									else 0
							end) as count_sunk_ships,
						sum(case o.result
									when 'damaged' then 1
									else 0
							end) as count_damaged_ships,
						sum(case o.result
									when 'ok' then 1
									else 0
							end) as count_ok_ships
from battles b left join outcomes o on b.NAME = o.BATTLE
group by name, date

-- 10. �� �� ������� ������� �� ��������, ����� �� ��������� � �����
-- � ����������� ���� �� 2 ������
use ships

select ship
from outcomes o join battles b on o.BATTLE = b.NAME
group by ship
having max(year(b.DATE)) - min(year(b.DATE)) >= 2

select *
from outcomes o join battles b on o.BATTLE = b.NAME
order by ship

-- 11. �� ����� ������� ����� ����� ������ �� ������ �� ��������� �� �� ���� 
--     �� ����������.
use ships

select o.ship, year(b.date) - s.LAUNCHED as years_sailing
from outcomes o join ships s on o.SHIP = s.NAME
				join battles b on o.BATTLE = b.NAME
where o.result = 'sunk'

select *
from ships s join outcomes o on s.NAME = o.SHIP
join battles b on o.BATTLE = b.NAME

-- 12. ������� �� ���������, �� ����� ���� �����, ������ ���� 1921�., 
-- �� ��� ������ ���� ���� �����.

use ships

select class
from ships
group by class
having max(launched) <= 1921

select *
from ships
order by class