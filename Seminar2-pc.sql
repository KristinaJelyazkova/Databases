use pc

-- Напишете заявка, която извежда производителя и честотата на 
-- процесора на тези лаптопи с размер на диска поне 9 GB
select p.maker, l.speed
from product p
	join laptop l on p.model = l.model
where l.hd >= 9

-- Напишете заявка, която извежда номер на модел и цена на всички
-- продукти, произведени от производител с име ‘B’. Сортирайте 
-- резултата така, че първо дасе изведат най-скъпите продукти
select u.model, u.price
from product p
	join (select model, price from laptop
		union
		select model, price from pc
		union
		select model, price from printer) u
			on p.model = u.model
where p.maker = 'B'
order by u.price desc

-- Напишете заявка, която извежда размерите на тези дискове, които
-- се предлагат в поне два компютъра
select distinct p1.hd
from pc p1
	join pc p2 on p1.code != p2.code
where p1.hd = p2.hd

-- Напишете заявка, която извежда всички двойки модели на компютри,
-- които имат еднаква честота и памет. Двойките трябва да се показват 
-- само по веднъж, например само (i, j), но не и (j, i)
select p1.model, p2.model
from pc p1
	join pc p2 on p1.model < p2.model
where p1.speed = p2.speed and p1.ram = p2.ram

-- Напишете заявка, която извежда производителите на поне два
-- различни компютъра с честота на процесора поне 650 MHz.
select distinct p.maker
from pc p1
	join pc p2 on p1.code != p2.code
	join product p on p1.model = p.model
where p2.model = p.model and p1.speed >= 650 and p2.speed >= 650
