--1. Без повторение заглавията и годините на всички филми, заснети
-- преди 1982, в които е играл поне един актьор (актриса), чието 
-- име не съдържа нито буквата 'k', нито 'b'. Първо да се изведат
-- най-старите филми.
use movies

select distinct title, year
from movie m join starsin s 
	on m.TITLE = s.MOVIETITLE and m.YEAR = s.MOVIEYEAR
where year < 1982 and s.STARNAME NOT LIKE '%k%' and
	s.STARNAME NOT LIKE '%b%'
order by year asc

--2. Заглавията и дължините в часове (length е в минути) на 
-- всички филми, които са от същата година, от която е и филмът 
-- Terms of Endearment, но дължината им е по-малка или неизвестна.
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

-- 3. Имената на всички продуценти, които са и филмови звезди и 
-- са играли в поне един филм преди 1980 г. и поне един след 
-- 1985 г.
use movies

select name
from MOVIEEXEC m join starsin s on m.NAME = s.STARNAME
group by name
having min(s.MOVIEYEAR) < 1980 and max(s.MOVIEYEAR) > 1985

-- 19. (*) За всеки кораб намерете броя на битките, в които е 
-- бил увреден. Ако корабът не е участвал в битки или пък никога 
-- не е бил увреждан, в резултата да се вписва 0.
use ships

select name, sum(case o.result
					when 'damaged' then 1
					else 0
				end) as count_damaged
from ships s left join outcomes o
		on s.NAME = o.SHIP
group by name


-- 20. (*) Намерете за всеки клас с поне 3 кораба броя на 
-- корабите от този клас, които са победили в битка.
use ships

select class, (select count(distinct name)
				from ships a join outcomes w on a.name = w.SHIP
				where a.class = s.class and w.RESULT = 'ok')
from ships s left join outcomes o on s.NAME = o.SHIP
group by class
having count(distinct name) >= 3

-- 5. Имената и адресите на студиата, които са работили с по-малко
-- от 5 различни филмови звезди1. Студиа, за които няма посочени 
-- филми или има, но не се знае кои актьори са играли в тях, също
-- да бъдат изведени. Първо да се изведат студиата, работили с 
-- най-много звезди.
use movies

select name, address, count(distinct i.STARNAME)
from studio s left join movie m on s.NAME = m.STUDIONAME
				left join STARSIN i on m.TITLE = i.MOVIETITLE
								and m.YEAR = i.MOVIEYEAR
group by name, address
having count(distinct i.STARNAME) < 5
order by count(distinct i.STARNAME) desc

-- 10. За всяка битка да се изведе средният брой кораби от 
-- една и съща държава (например в битката при Guadalcanal са 
--участвали 3 американски и един японски кораб, т.е.
-- средният брой е 2).
use ships

select battle, avg(count) as avg
from (select o.battle, count(*) as count
from outcomes o join ships s on o.SHIP = s.NAME
				join classes c on s.CLASS = c.CLASS
group by o.battle, c.COUNTRY) t
group by battle

-- 15. Да се изведат различните модели компютри, подредени по 
-- цена на най-скъпия конкретен компютър от даден модел.
use pc

select model
from pc
group by model
order by max(price) asc




