use ships
go

create view BritishShips
as
select s.name, c.class, c.type, c.NUMGUNS, c.BORE, c.DISPLACEMENT, s.LAUNCHED
from ships s join classes c on s.class = c.class
where c.COUNTRY = 'Gt.Britain'
go

select * from CLASSES

select NAME, NUMGUNS, DISPLACEMENT
from BritishShips
where LAUNCHED < 1919

select s.name, c.NUMGUNS, c.DISPLACEMENT
from ships s join classes c on s.class = c.class
where c.COUNTRY = 'Gt.Britain' and s.LAUNCHED < 1919

use ships
go

create view AverageMaxDisp
as
select avg(max_disp) as avg_disp
from classes c
	join (select country, max(displacement) as max_disp
			from CLASSES
			group by country) t 
	on c.COUNTRY = t.COUNTRY and c.DISPLACEMENT = t.max_disp
go

use ships
go

create view SunkShips
as
select battle, ship
from outcomes
where result = 'sunk'
go

alter table outcomes
	add constraint def_outcomes_res DEFAULT 'sunk' for result

insert into SunkShips(battle, ship)
	values ('Guadalcanal', 'California')

alter table outcomes
	drop constraint def_outcomes_res

use ships
go

create view ManyGunsClasses
as
select *
from CLASSES
where NUMGUNS >= 9
with check option
go

update ManyGunsClasses
	set NUMGUNS = 15
	where CLASS = 'Iowa'

update ManyGunsClasses
	set NUMGUNS = 5
	where CLASS = 'Iowa'

use ships
go

alter view ManyGunsClasses
as
select *
from CLASSES
where NUMGUNS >= 9
go

use ships
go

create view Battles39
as
select o.BATTLE
from OUTCOMES o join SHIPS s on o.SHIP = s.NAME
	join CLASSES c on s.CLASS = c.class
where c.NUMGUNS < 9
group by o.BATTLE
having count(*) >= 3 and sum(case o.result
								when 'damaged' then 1
								else 0
							end) >= 1
go
