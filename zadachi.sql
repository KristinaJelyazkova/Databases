-- 1. За всяка филмова звезда да се изведе
--името, рождената дата и с кое студио е записвала най-много филми. 
--Ако има две студиа с еднакъв брой филми, да се изведе кое да е от тях
use movies
select s.NAME, s.ADDRESS, (select top 1 m.STUDIONAME
							from STARSIN i
								join MOVIE m on i.MOVIETITLE = m.TITLE and i.MOVIEYEAR = m.YEAR
							where i.STARNAME = s.NAME
							group by m.STUDIONAME
							order by count(*) desc)
from MOVIESTAR s


--2. Да се изведат всички производители, за които средната цена на 
--произведените компютри е по-ниска от средната цена на техните лаптопи.
use pc
select p1.maker, avg(pc.price), avg(l.price)
from product p1
	left join pc on p1.model = pc.model 
	left join laptop l on p1.model = l.model
group by p1.maker
having isnull(avg(pc.price),0) < isnull(avg(l.price), 0)


-- 3. Един модел компютри може да се предлага в няколко конфигурации 
--    с евентуално различна цена. Да се изведат тези модели компютри,
--    чиято средна цена (на различните му конфигурации) е по-ниска
--    от най-евтиния лаптоп, произвеждан от същия производител.
use pc
select p1.maker, p1.model, avg(pc.price)
from product p1
	join pc on p1.model = pc.model
group by p1.maker, p1.model
having avg(pc.price) < (select min(l.price)
						from laptop l
							join product p2 on l.model = p2.model
						where p1.maker = p2.maker)


-- 4. Битките, в които са участвали поне 3 кораба на една и съща страна.
use ships
select distinct o.BATTLE
from OUTCOMES o
	join ships s on o.SHIP = s.NAME
	join CLASSES c on s.CLASS = c.CLASS
group by o.BATTLE, c.COUNTRY
having count(*) >= 3


-- 5. За всеки кораб да се изведе броят на битките, в които е бил увреден.
--    Ако корабът не е участвал в битки или пък никога не е бил
--    увреждан, в резултата да се вписва 0.
use ships
select s.NAME, sum(case o.RESULT when 'sunk' then 1 else 0 end)
from ships s
	left join OUTCOMES o on s.NAME = o.SHIP 
group by s.NAME


-- 6. За всеки клас да се изведе името, държавата и първата година, в която 
--    е пуснат кораб от този клас
use ships
select c.CLASS, min(s.LAUNCHED)
from CLASSES c
	left join ships s on c.CLASS = s.CLASS
group by c.CLASS


-- 7. За всяка държава да се изведе броят на корабите и броят на потъналите 
--    кораби. Всяка от бройките може да бъде и нула.
use ships
select c.COUNTRY, 
		count(s.name) 'total ships',
		sum(case o.result when 'sunk' then 1 else 0 end) 'sunk ships'
from CLASSES c
	left join ships s on c.CLASS = s.CLASS
	left join OUTCOMES o on s.NAME = o.SHIP
group by c.COUNTRY


-- 8. Намерете за всеки клас с поне 3 кораба броя на корабите от 
--    този клас, които са с резултат ok.
use ships
select *
from CLASSES c
	left join ships s on c.CLASS = s.CLASS
	left join OUTCOMES o on s.NAME = o.SHIP
group by c.CLASS
having sum(case o.result when 'ok' then 1 else 0 end) >= 3
--В базата няма такива класове


-- 9. За всяка битка да се изведе името на битката, годината на 
--    битката и броят на потъналите кораби, броят на повредените
--    кораби и броят на корабите без промяна.
use ships
select o.BATTLE, sum(case o.result when 'ok' then 1 else 0 end) 'ok ships',
		sum(case o.result when 'damaged' then 1 else 0 end) 'damaged ships',
		sum(case o.result when 'sunk' then 1 else 0 end) 'sunk ships'
from OUTCOMES o
group by o.BATTLE


-- 10. Да се изведат имената на корабите, които са участвали в битки в
--     продължение поне на две години.
use ships
select o1.SHIP
from BATTLES b1
	join OUTCOMES o1 on b1.NAME = o1.BATTLE
	cross join BATTLES b2
	join OUTCOMES o2 on b2.NAME = o2.BATTLE
where year(b2.date) - year(b1.date) >= 2 and o1.SHIP = o2.SHIP


-- 11. За всеки потънал кораб колко години са минали от пускането му на вода 
--     до потъването.
use ships
select s.NAME, year(b.DATE) - s.LAUNCHED
from ships s
	join OUTCOMES o on s.NAME = o.SHIP
	join BATTLES b on o.BATTLE = b.NAME
where o.RESULT = 'sunk'
--Базата е счупена и има грешни дати за битките или за launched


-- 12. Имената на класовете, за които няма кораб, пуснат на вода след 1921 г., 
--     но имат пуснат поне един кораб. 
use ships
select c.CLASS
from CLASSES c
	join ships s on c.CLASS = s.CLASS
group by c.CLASS
having max(s.LAUNCHED) <= 1921