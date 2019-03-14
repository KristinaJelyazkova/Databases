select distinct maker
from product
where model in (select model
				from pc
				where speed >= 500)

select *
from printer
where price >= All (select price
					from printer)

select *
from laptop
where speed < any (select price
					from pc)

select distinct t.model
from (select model, price from laptop
	union
	select model, price from pc
	union
	select model, price from printer) t
where t.price >= all (select price from laptop
						union
						select price from pc
						union
						select price from printer)

select distinct maker
from product p join printer u on p.model = u.model
where u.color = 'y' and u.price <= all (select price
									from printer
									where color = 'y')

select distinct maker
from product p join (select model, ram, speed
					from pc
					where ram <= all(select ram
									from pc)) t
				on p.model = t.model
where t.speed >= all (select speed
					from pc
					where ram = t.ram)