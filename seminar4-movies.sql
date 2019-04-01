--Напишете заявка, която за всеки филм, по-дълъг от 120 минути, извежда
--заглавие, година, име и адрес на студио
select TITLE, YEAR, NAME, ADDRESS
from MOVIE m join STUDIO s
				on m.STUDIONAME = s.NAME
where m.LENGTH > 120

-- 1.2. Напишете заявка, която извежда името на студиото и имената на
--      актьорите, участвали във филми, произведени от това студио,
--      подредени по име на студио.
select distinct m.STUDIONAME, s.STARNAME
from movie m join STARSIN s on m.TITLE = s.MOVIETITLE and m.year = s.MOVIEYEAR
order by m.STUDIONAME

-- 1.3. Напишете заявка, която извежда имената на продуцентите на филмите,
--      в които е играл Harrison Ford.
select distinct name
from MOVIEEXEC m1 join MOVIE m2 on m1.CERT# = m2.PRODUCERC#
where m2.title in (select MOVIETITLE
					from STARSIN
					where STARNAME = 'Harrison Ford')

select distinct e.name
from movie m 
		join starsin s on m.TITLE = s.MOVIETITLE and m.YEAR = s.MOVIEYEAR
		join MOVIEEXEC e on m.PRODUCERC# = e.CERT#
where STARNAME = 'Harrison Ford'

-- 1.4. Напишете заявка, която извежда имената на актрисите, играли във
--      филми на MGM.
select distinct ms.name
from MOVIESTAR ms join STARSIN s on ms.NAME = s.STARNAME
		join movie m on s.MOVIETITLE = m.TITLE and s.MOVIEYEAR = m.YEAR
where STUDIONAME = 'MGM' and GENDER = 'F'

-- 1.5. Напишете заявка, която извежда името на продуцента и имената на
--      филмите, продуцирани от продуцента на 'Star Wars'.
select name, title
from MOVIEEXEC e join movie m on e.CERT# = m.PRODUCERC#
where m.PRODUCERC# = (select PRODUCERC#
				from MOVIE
				where title = 'Star Wars' and year = 1977)


-- 1.6. Напишете заявка, която извежда имената на актьорите не участвали в
--      нито един филм.
select name
from moviestar m left join STARSIN s on m.NAME = s.STARNAME
where STARNAME is NULL