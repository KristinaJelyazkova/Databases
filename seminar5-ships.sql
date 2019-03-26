-- 2.1. Напишете заявка, която извежда броя на класовете кораби
select count(*) as class_count
from classes

-- 2.2. Напишете заявка, която извежда средния брой на оръжия за 
--      всички кораби, пуснати на вода
select avg(numguns) as avg_numguns
from classes c join ships s on c.class = s.CLASS

-- 2.3. Напишете заявка, която извежда за всеки клас първата и 
--      последната година, в която кораб от съответния клас е пуснат на вода
select class, min(launched) as first_launched, max(launched) as last_launched
from ships
group by class

-- 2.4. Напишете заявка, която извежда броя на корабите потънали в битка 
--      според класа
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

-- 2.5. Напишете заявка, която извежда броя на корабите потънали в битка 
--      според класа, за тези класове с повече от 4 пуснати на вода кораба
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

-- 2.6. Напишете заявка, която извежда средното тегло на корабите, за всяка страна. 
select country, avg(displacement) as avg_weight
from classes
group by country
