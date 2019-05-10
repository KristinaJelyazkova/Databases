use movies

select * from movie
order by length

-- there are movies with the same length - let's correct that:

update movie set length = 
		(select length + 1
		from movie
		where title = 'Star Trek: Nemesis' and year = 2002)
where title = 'Star Trek: Nemesis' and year = 2002

update movie set length = 
		(select length + 1
		from movie
		where title = 'Star Trek' and year = 1979)
where title = 'Star Trek' and year = 1979

alter table movie add constraint unique_length unique(length)

alter table movie add constraint uniqueLS unique(studioname, length)

alter table movie drop constraint unique_length

alter table movie drop constraint uniqueLS


----------------------------------------
use fmi

create table student(
	FN int check(FN between 0 and 99999) primary key,
	name varchar(100) not null,
	egn char(10) unique not null,
	email varchar(100) unique not null,
	birthdate date not null,
	acceptance_date date not null,
	constraint acceptance check(datediff(year, birthdate, acceptance_date) >= 18)
)

alter table student add constraint valid_email check(email like '%_@%_.%_')

create table course(
	id int identity primary key,
	name varchar(100)
)

create table take_courses(
	student_fn int references student(fn),
	course_id int references course(id) on delete cascade,
	constraint pk primary key(student_fn, course_id)
)