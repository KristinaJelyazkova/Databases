-- При добавянето на нов клас в таблицата Classes добавете и кораб 
-- със същото име в таблицата Ships, който да има дата на пускане 
-- NULL
go

create trigger tr_class on classes
after insert
as
insert into ships(name, class)
	select class, class
	from inserted

go

-- Ако бъде добавен нов клас с водоизместимост по-голяма от 35000, 
-- добавете класа в таблицата, но му задайте водоизместимост 35000
go

create trigger tr_disp on classes
instead of insert
as
insert into classes(class, type, country, numguns, bore, displacement)
	select class, type, country, numguns, bore, displacement
	from inserted
	where displacement <= 35000
	union
	select class, type, country, numguns, bore, 35000
	from inserted
	where displacement > 35000

go


-- Никой клас не може да има повече от два кораба
go

create trigger tr_ships_cl on ships
instead of insert 
as
if not exists(select *
			from inserted
			where class in (select class
							from ships
							group by class
							having count(*) >= 2))
begin insert into ships
			select *
			from inserted
end

go

drop trigger tr_ships_cl

select *
from ships

insert into ships(name) values ('hey')


-- Кораб с повече от 9 оръдия не може да участва в битка с кораб, 
-- който е с по-малко от 9 оръдия
go

create trigger tr_numguns on outcomes
after insert
as
if exists(select *
			from inserted i join ships s on i.ship = s.name
				join classes c on s.class = c.class
			where (c.numguns > 9 and i.battle in (select distinct battle 
												from outcomes o join ships s1 on o.ship = s1.name
																join classes c1 on s1.class = c1.class
												where c1.numguns < 9))
			or
			(c.numguns < 9 and i.battle in (select distinct battle 
												from outcomes o join ships s1 on o.ship = s1.name
																join classes c1 on s1.class = c1.class
												where c1.numguns > 9)))
begin rollback
end

go

-- При добавянето на нов запис в таблицата Outcomes се уверете, че
-- корабът и битката съществуват в таблиците Ships и Battles. Ако 
-- не съществуват добавете информацията за тях в съответната 
-- таблицата като добавите NULL стойности, където е необходимо
go

create trigger tr_out on outcomes
after insert
as
insert into battles(name)
		select battle
		from inserted
		where battle not in (select name
							from battles)
insert into ships(name)
		select ship
		from inserted
		where ship not in (select name
							from ships)

go

-- При добавянето на нов кораб или при промяна на класа на някой 
-- кораб се уверете, че никоя държава няма повече от 20 кораба;
go

create trigger tr_20ships on ships
after insert, update
as
if exists(select country
		from classes c join ships s on c.class = s.class
		group by country
		having count(distinct s.name) > 20)
begin rollback
end

go

-- Кораб, който вече е потънал не може да участва в битка, чиято 
-- дата е след датата на потъването му
go

create trigger tr_sunk on outcomes
after insert, update
as
if exists(select *
			from outcomes o1 join outcomes o2 on o1.ship = o2.ship
				join battles b1 on o1.battle = b1.name
				join battles b2 on o2.battle = b2.name
			where o1.result = 'sunk' and b1.date < b2.date)
begin rollback
end

go