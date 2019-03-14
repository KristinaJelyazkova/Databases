select name
from moviestar
where GENDER = 'F' and name in (select name
										from movieexec
										where networth > 10000000)

select name
from moviestar
where name not in (select name
					from MOVIEEXEC)

select title
from movie
where length > (select length
				from movie
				where title = 'Gone With the Wind'
					and year = 1938)

-- Имената на продуцентите и продукциите, правени от продуценти 
-- с NETWORTH по-голям от NETWORTH-a на 'Merv Griffin'
select m.NAME, n.TITLE
from MOVIEEXEC m join MOVIE n on m.NAME = n.PRODUCERC#
where m.NETWORTH > (select NETWORTH
					from MOVIEEXEC
					where name = 'Merv Griffin')