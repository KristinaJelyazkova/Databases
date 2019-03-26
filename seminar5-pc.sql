-- 1.1. Напишете заявка, която извежда средната честота на компютрите
select avg(speed)
from pc

-- 1.2. Напишете заявка, която извежда средния размер на екраните на 
--      лаптопите  за всеки производител
select maker, avg(screen)
from product p join laptop l on p.model = l.model
group by maker


-- 1.3. Напишете заявка, която извежда средната честота на лаптопите 
--      с цена над 1000
select avg(speed)
from laptop
where price > 1000

-- 1.4. Напишете заявка, която извежда средната цена на компютрите 
--      произведени от производител ‘A’
select avg(price) as avg_price
from pc c join product p on c.model = p.model
where maker = 'A'

-- 1.5. Напишете заявка, която извежда средната цена на компютрите 
--      и лаптопите за производител ‘B’
select avg(price) as avg_price
from product p join (select price, model from laptop
		union all
		select price, model from pc) t
		on p.model = t.model
where maker = 'B'


SELECT AVG(price) AveragePrice
FROM (SELECT price
      FROM product p 
          JOIN pc ON p.model = pc.model
      WHERE maker = 'B'
      UNION ALL
      SELECT price
      FROM product p 
          JOIN laptop ON p.model = laptop.model
      WHERE maker = 'B') u

-- 1.6. Напишете заявка, която извежда средната цена на компютрите 
--      според различните им честоти
select speed, avg(price)
from pc
group by speed

-- 1.7. Напишете заявка, която извежда производителите, които са 
--      произвели поне по 3 различни модела компютъра
select distinct maker
from product
where type = 'PC'
group by maker
having count(*) >= 3

-- 1.8. Напишете заявка, която извежда производителите на компютрите с 
--      най-висока цена
select distinct maker
from product p join pc c on p.model = c.model
where price >= all(select price from pc)

select distinct maker
from product p join pc c on p.model = c.model
where price = (select max(price) from pc)

-- 1.9. Напишете заявка, която извежда средната цена на компютрите 
--      за всяка честота по-голяма от 800
select speed, avg(price) as avg_price
from pc
where speed > 800
group by speed

-- 1.10. Напишете заявка, която извежда средния размер на диска на 
--       тези компютри произведени от производители, които произвеждат 
--       и принтери
select avg(hd) as avg_hd
from pc c join product p on c.model = p.model
where maker in (select distinct maker
				from product 
				where type = 'Printer')

-- 1.11. Напишете заявка, която за всеки размер на лаптоп намира разликата 
--       в цената на най-скъпия и най-евтиния лаптоп със същия размер
select screen, max(price) - min(price) as diff_price
from laptop
group by screen
