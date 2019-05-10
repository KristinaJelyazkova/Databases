insert into classes(class, bore, DISPLACEMENT, NUMGUNS)
	values ('Nelson', 16, 34000, 9)


insert into ships(name, class, LAUNCHED)
values ('Nelson', 'Nelson', 1927), ('Rodney', 'Nelson', 1927)

select * from classes
select * from ships

delete from ships
where name in
	(select ship
	from outcomes
	where result = 'sunk')