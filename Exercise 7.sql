/*
AUTHOR: PLAMEN NACHEV
SUBJECT: DATABASES
Exercise on Obshti zadachi vyrhu SQL
*/

-- Za bazata ot danni Movies
/* Zad 1 */
select m.TITLE, m.YEAR
from MOVIE as m join STARSIN as si
on m.TITLE = si.MOVIETITLE and m.YEAR = si.MOVIEYEAR
where si.STARNAME not like '%k%' and si.STARNAME not like '%b%' and
	  m.YEAR < 1982
group by m.TITLE, m.YEAR
having count(si.STARNAME) >= 1
order by m.YEAR asc

/* Zad 2 */
select m.TITLE, cast(m.LENGTH/60 as float)
from MOVIE as m
where m.TITLE != 'Terms of Endearment'
	  and
	  m.YEAR = (select m1.YEAR
				from MOVIE as m1
				where m1.TITLE = 'Terms of Endearment')
	  and
	  (m.LENGTH is NULL
	   or
  	   m.LENGTH < (select m2.LENGTH
		 		   from MOVIE as m2
				   where m2.TITLE = 'Terms of Endearment'))

/* Zad 3 */
select me.NAME
from MOVIEEXEC as me
where me.NAME in (select ms.NAME
				  from MOVIESTAR as ms)
	  and
	  me.NAME in (select si.STARNAME
				  from STARSIN as si
				  where si.MOVIEYEAR < 1980)
	  and
	  me.NAME in (select si.STARNAME
				  from STARSIN as si
				  where si.MOVIEYEAR > 1985)

/* Zad 4 */
select m.TITLE, m.YEAR
from STUDIO as s join MOVIE as m
on s.NAME = m.STUDIONAME
where m.INCOLOR = 'N' and 
      m.YEAR < (select min(m1.YEAR)
		        from STUDIO as s1 join MOVIE as m1
				on s1.NAME = m1.STUDIONAME
				where m.STUDIONAME = m1.STUDIONAME and 
					  m1.INCOLOR = 'Y')

/* Zad 5 */
select s.NAME, s.ADDRESS
from STUDIO as s left join MOVIE as m
on s.NAME = m.STUDIONAME left join STARSIN as si
on m.TITLE = si.MOVIETITLE and m.YEAR = si.MOVIEYEAR
group by s.NAME, s.ADDRESS
having count(distinct si.STARNAME) < 5
order by count(distinct si.STARNAME) desc

select * from MOVIE
select * from STARSIN
select * from MOVIEEXEC
select * from MOVIESTAR


-- Za bazata ot danni SHIPS
/* Zad 6 */
select s.NAME, s.LAUNCHED
from SHIPS as s
where s.CLASS not like '%i%' and s.CLASS not like '%k%'
order by s.LAUNCHED desc

/* Zad 7 */
select distinct o1.BATTLE
from CLASSES as c1 join SHIPS as s1
on c1.CLASS = s1.CLASS join OUTCOMES as o1
on s1.NAME = o1.SHIP
where c1.COUNTRY = 'Japan' and o1.RESULT = 'damaged'

/* Zad 8 */
select s.NAME, s.CLASS
from CLASSES as c join SHIPS as s
on c.CLASS = s.CLASS
where s.LAUNCHED-1 = (select s1.LAUNCHED
					  from SHIPS as s1
					  where s1.NAME= 'Rodney')
	  and
	  c.NUMGUNS > (select avg(c1.NUMGUNS)
				   from CLASSES as c1
				   where c1.COUNTRY = c.COUNTRY)

/* Zad 9 */
select c.CLASS
from CLASSES as c join SHIPS as s
on c.CLASS = s.CLASS
where c.COUNTRY = 'USA'
group by c.CLASS
having max(s.LAUNCHED) - min(s.LAUNCHED) >= 10

/* Zad 10 */
select o.BATTLE, count(s.NAME) / count(distinct c.COUNTRY)
from CLASSES as c join SHIPS as s 
on c.CLASS = s.CLASS join OUTCOMES as o
on s.NAME = o.SHIP
group by o.BATTLE

use SHIPS

/* Zad 11 */
select c.COUNTRY, count(s.NAME), count(o.BATTLE), (select count(*) 
												   from CLASSES as c1 left join SHIPS as s1
												   on c1.CLASS = s1.CLASS left join OUTCOMES as o1
												   on s1.NAME = o1.SHIP
												   where  c.COUNTRY = c1.COUNTRY and
														  o1.RESULT = 'sunk')

from CLASSES as c left join SHIPS as s
on c.CLASS = s.CLASS left join OUTCOMES as o
on s.NAME = o.SHIP
group by c.COUNTRY

select *
from CLASSES as c1 left join SHIPS as s1
on c1.CLASS = s1.CLASS left join OUTCOMES as o1
on s1.NAME = o1.SHIP
order by c1.COUNTRY asc


-- Za bazata ot danni Movies
/* Zad 12 */
select ms.NAME, count(distinct m.STUDIONAME)
from MOVIE as m join STARSIN as si
on m.TITLE = si.MOVIETITLE and m.YEAR = si.MOVIEYEAR 
join MOVIESTAR as ms
on ms.NAME = si.STARNAME
group by ms.NAME

/* Zad 13 */
select ms.NAME, count(distinct m.STUDIONAME)
from MOVIE as m right join STARSIN as si
on m.TITLE = si.MOVIETITLE and m.YEAR = si.MOVIEYEAR 
right join MOVIESTAR as ms
on ms.NAME = si.STARNAME
group by ms.NAME

/* Zad 14 */
select ms.NAME
from MOVIESTAR as ms join STARSIN as si
on ms.NAME = si.STARNAME
where ms.GENDER = 'M' and si.MOVIEYEAR > 1990
group by ms.NAME
having count(si.MOVIETITLE) >= 3

-- Za bazata ot danni PC
/* Zad 15 */
select pc.model
from pc
group by pc.model
order by max(pc.price) asc

-- Za bazata ot danni SHIPS
/* Zad 16 */
select o.BATTLE, count(s.NAME)
from CLASSES as c join SHIPS as s
on c.CLASS = s.CLASS join OUTCOMES as o
on s.NAME = o.SHIP
where c.COUNTRY = 'USA' and o.RESULT = 'sunk'
group by o.BATTLE
having count(s.NAME) >= 1

/* Zad 17 */
select distinct o.BATTLE
from CLASSES as c join SHIPS as s
on c.CLASS = s.CLASS join OUTCOMES as o
on s.NAME = o.SHIP
group by o.BATTLE, c.COUNTRY
having count(s.NAME) >= 3

/* Zad 18 */
select s.CLASS
from SHIPS as s
where s.LAUNCHED is not NULL
group by s.CLASS
having max(s.LAUNCHED) <= 1921

/* Zad 19 */
select s.NAME, (select count(*)
				from SHIPS as s1 left join OUTCOMES as o1
				on s1.NAME = o1.SHIP
				where s1.NAME = s.NAME and o1.RESULT = 'damaged')
from SHIPS as s left join OUTCOMES as o
on s.NAME = o.SHIP
group by s.NAME

select *
from SHIPS as s left join OUTCOMES as o
on s.NAME = o.SHIP
order by s.NAME asc

select *
from CLASSES as c left join SHIPS as s
on c.CLASS = s.CLASS left join OUTCOMES as o
on s.NAME = o.SHIP
order by c.COUNTRY asc

select * from SHIPS order by SHIPS.LAUNCHED


/* Zad 20 */
select s.CLASS, (select count(*)
				 from SHIPS as s1 join OUTCOMES as o1
				 on s1.NAME = o1.SHIP
				 where s1.CLASS = s.CLASS and o1.RESULT != 'sunk')
from SHIPS as s join OUTCOMES as o
on s.NAME = o.SHIP
group by s.CLASS
having count(s.NAME) >= 3

