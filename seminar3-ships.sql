select distinct country
from CLASSES
where numguns >= all (select NUMGUNS
					from CLASSES)

select distinct class
from ships
where name in (select ship
				from outcomes
				where result = 'sunk')

select name
from ships
where class in (select CLASS
				from CLASSES
				where bore = 16)

select battle
from outcomes
where ship in (select name
				from ships
				where class = 'Kongo')

select name
from ships s join CLASSES c
		on s.CLASS = c.CLASS
where c.NUMGUNS >= all (select NUMGUNS
						from CLASSES c1
						where c1.bore = c.bore)
