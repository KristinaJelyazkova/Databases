-- 1. За всяка филмова звезда да се изведе името, рождената дата и с кое
--    студио е записвала най-много филми. (Ако има две студиа с еднакъв 
--    брой филми, да се изведе кое да е от тях)

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

-- 2. Да се изведат всички производители, за които средната цена на 
--    произведените компютри е по-ниска от средната цена на техните лаптопи.
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

-- 3. Един модел компютри може да се предлага в няколко конфигурации 
--    с евентуално различна цена. Да се изведат тези модели компютри,
--    чиято средна цена (на различните му конфигурации) е по-ниска
--    от най-евтиния лаптоп, произвеждан от същия производител.
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

-- 4. Битките, в които са участвали поне 3 кораба на една и съща страна.
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


-- 5. За всеки кораб да се изведе броят на битките, в които е бил увреден.
--    Ако корабът не е участвал в битки или пък никога не е бил
--    увреждан, в резултата да се вписва 0.
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

-- 6. За всеки клас да се изведе името, държавата и първата година, в която 
--    е пуснат кораб от този клас
use ships

select c.class, c.country, (select min(t.launched)
						from (select launched
								from ships
								where class = c.class) t)  as first_launched
from classes c

select *
from classes c join ships s on c.class = s.class
order by c.class, s.LAUNCHED

-- 7. За всяка държава да се изведе броят на корабите и броят на потъналите 
--    кораби. Всяка от бройките може да бъде и нула.
use ships

select country, count(distinct s.name) as count_ships, sum(case o.result
													when 'sunk' then 1
													else 0
											end) as count_sunk_ships
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.NAME = o.SHIP
group by country


-- 8. Намерете за всеки клас с поне 3 кораба броя на корабите от 
--    този клас, които са с резултат ok.
use ships

select c.class, sum(case o.result
							when 'ok' then 1
							else 0
					end) as count_ok_ships
from classes c left join ships s on c.class = s.class
				left join outcomes o on s.NAME = o.SHIP
group by c.class
having count(distinct s.name) >= 3

-- 9. За всяка битка да се изведе името на битката, годината на 
--    битката и броят на потъналите кораби, броят на повредените
--    кораби и броят на корабите без промяна.
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

-- 10. Да се изведат имената на корабите, които са участвали в битки
-- в продължение поне на 2 години
use ships

select ship
from outcomes o join battles b on o.BATTLE = b.NAME
group by ship
having max(year(b.DATE)) - min(year(b.DATE)) >= 2

select *
from outcomes o join battles b on o.BATTLE = b.NAME
order by ship

-- 11. За всеки потънал кораб колко години са минали от пускането му на вода 
--     до потъването.
use ships

select o.ship, year(b.date) - s.LAUNCHED as years_sailing
from outcomes o join ships s on o.SHIP = s.NAME
				join battles b on o.BATTLE = b.NAME
where o.result = 'sunk'

select *
from ships s join outcomes o on s.NAME = o.SHIP
join battles b on o.BATTLE = b.NAME

-- 12. Имената на класовете, за които няма кораб, пуснат след 1921г., 
-- но има пуснат поне един кораб.

use ships

select class
from ships
group by class
having max(launched) <= 1921

select *
from ships
order by class