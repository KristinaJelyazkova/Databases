-- 3.1. Напишете заявка, която за всеки кораб извежда името му, държавата,
--      броя оръдия и годината на пускане (launched).
select name, country, numguns, launched
from ships s join classes c on s.CLASS = c.CLASS



-- 3.2. Напишете заявка, която извежда имената на корабите, участвали в битка
--      от 1942г.
select distinct ship
from outcomes o join BATTLES b on o.BATTLE = b.NAME
where year(date) = 1942

-- 3.3. За всяка страна изведете имената на корабите, които никога не са
--      участвали в битка.
select country, name
from classes c join ships s on c.CLASS = s.CLASS
				left join outcomes o on s.NAME = o.SHIP
where o.SHIP is NULL

-- Допълнителна задача

-- Имената на класовете, за които няма кораб, пуснат на вода
-- (launched) след 1921 г. Ако за класа няма пуснат никакъв кораб,
-- той също трябва да излезе в резултата.
select distinct c.class
from classes c left join ships s on c.CLASS = s.CLASS and s.launched > 1921 
where s.name is NULL

select distinct class
from classes
where class not in (select class
					from ships
					where LAUNCHED > 1921)
