-- 2.1. Ќапишете за€вка, ко€то извежда производител, модел и тип на продукт
--      за тези производители, за които съответни€ продукт не се продава
--      (н€ма го в таблиците PC, лаптоп или принтер).
select *
from product p
where model not in (select model from laptop
					union
					select model from pc
					union
					select model from printer)

select maker, p.model, p.type
from product p left join (select model from laptop
					union
					select model from pc
					union
					select model from printer) t
					on p.model = t.model
where t.model is NULL