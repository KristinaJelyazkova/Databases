use ships

-- Напишете заявка, която извежда името на корабите, по-тежки
-- (displacement) от 35000
select distinct s.name
from ships s
	join classes c on s.CLASS = c.CLASS
where c.DISPLACEMENT > 35000

-- Напишете заявка, която извежда имената, водоизместимостта
-- и броя оръдия на всички кораби, участвали в битката при 
-- 'Guadalcanal'
select distinct s.NAME, c.BORE, c.NUMGUNS
from outcomes o
	 join ships s on o.ship = s.NAME
	 join CLASSES c on s.CLASS = c.CLASS
where o.BATTLE = 'Guadalcanal'

-- Напишете заявка, която извежда имената на тези държави, които
-- имат класове кораби от тип ‘bb’ и ‘bc’ едновременно
select distinct c1.COUNTRY
from CLASSES c1
	join CLASSES c2 on c1.COUNTRY = c2.COUNTRY
where c1.TYPE = 'bb' and c2.TYPE = 'bc'

-- Напишете заявка, която извежда имената на тези кораби, които
-- са били повредени в една битка, но по-късно са участвали в 
-- друга битка.
select distinct o1.SHIP
from OUTCOMES o1
	join OUTCOMES o2 on o1.SHIP = o2.SHIP
	join BATTLES b1 on o1.BATTLE = b1.NAME
	join BATTLES b2 on o2.BATTLE = b2.NAME
where o1.RESULT = 'damaged' and b1.DATE < b2.DATE
