select * from pc
select * from product

insert into product(model, maker, type) values
	('1100', 'C', 'PC')

insert into PC(model, speed, ram, HD, CD, price, code) values
	('1100', 2400, 2048, 500, '52x', 299, 12)

delete from pc
where model = '1100'

delete from product
where model = '1100'

select * from laptop

insert into laptop(code, model, speed, ram, hd, price, screen)
	select code + 100, model, speed, ram, hd, price + 500, 15
	from pc

delete from laptop
where code in
(select code
from laptop l
where (select p.maker
		from product p
		where p.model = l.model and p.type = 'Laptop') not in
		(select distinct p1.maker
		from product p1
		where p1.type = 'Printer'))

select * from product

update product
set maker = 'A'
where maker = 'B'

select * from pc

update pc
set price = price / 2, hd = hd + 20

select *
from laptop l join product p 
	on l.model = p.model
where p.maker = 'A' and p.type = 'Laptop'

select * from product

update laptop
set screen = screen + 1
where code in
(select code
from laptop l join product p 
	on l.model = p.model
where p.maker = 'A' and p.type = 'Laptop')