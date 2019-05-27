--Да се създаде база с име library. Трябва да може да съхранява информация за:
create database library

--	Книги
--          - ISBN - символен низ с фиксирана дължина от 17 символа
--          - Име - символен низ от максимум 128 символа
--          - Брой страници - цяло число 
--          - Цена - число с фиксирана запетая (5 цифри преди запетаята и 2 след)
--          - Автори (могат да бъдат повече от един)
--          - Брой налични книги в библиотеката от това заглавие

create table book(
	ISBN char(17) constraint pk_book primary key 
					constraint book_isbn check(ISBN like '___-___-____-__-_'),
	name varchar(128) not null,
	pages int not null check(pages > 0),
	price decimal(7,2) check(price > 0),
	copies int not null check(copies >= 0)
)

--  Автори
--          - Име - символен низ от максимум 64 символа
--          - Адрес - символен низ от максимум 64 символа
--          - Телефон - символен низ от максимум 32 символа
--          - Рожденна дата - дата
--          - Email адрес (неможе 2 различни автора да имат еднакви email адреси)
--          - Книги, които е написал (могат да са повече от една)

create table author(
	id int IDENTITY constraint pk_author primary key,
	name varchar(64) not null,
	address varchar(64) not null,
	phone varchar(32) not null,
	birthdate date not null,
	email varchar(64) constraint unique_author_email unique not null
)

create table writerof(
	book_isbn char(17) constraint fk_writerof_book references book(ISBN),
	author_id int constraint fk_writerof_author references author(id)
	constraint pk_writerof primary key(book_isbn, author_id)
)

--  Читател
--			- Име - символен низ от максимум 64 символа
--          - Email - електронна поща - символен низ от максимум 64 символа
--          - Заета книга (може да бъде само една)

create table reader(
	id int identity constraint pk_reader primary key,
	name varchar(64) not null,
	email varchar(64) not null,
	book_isbn char(17) constraint fk_reader references book(ISBN)
)

-- Цената на някоя книга може да не е известна (трябва да допуска NULL стойности)
-- Всички останали атрибути не допускат NULL стойности
-- ISBN трябва да има следната структура XXX-XXX-XXXX-XX-X

-- Изберете подходящи ключове за различните релации (може да се въведат
-- синтетични такива - цели числа, които да се генерират с IDENTITY). 
-- Дефинирайте адекватни PRIMARY KEY, UNIQUE, CHECK и FOREIGN KEY ограничения.

insert into book values('124-537-7509-32-1', 'Hunger Games', 342, 15432.54, 14)
insert into book values('924-837-7009-82-3', 'Murder on the Orient Express', 512, 35472.12, 108)
insert into book values('026-534-3081-37-8', 'Ten Little Niggers', 401, 97421.81, 56)
insert into book values('546-574-8981-21-7', 'Apocalypse Link', 1002, 3421.81, 116)
insert into book values('095-521-3521-69-5', 'The Supreme Girls', 101, 7876.81, 606)

insert into author values('Agatha Christie', '667 Point Street', '617-771-5949', '1979-07-05', 'agatha@gmail.com')
insert into author values('Suzanne Collins', '1988 Sherman Street', '785-816-6452', '1959-11-28', 'suzanne@gmail.com')
insert into author values('John Smith', '2704 Romano Street', '323-919-2018', '1921-02-10', 'jsmith@authors.io')

insert into writerof values('124-537-7509-32-1', 3)
insert into writerof values('924-837-7009-82-3', 1)
insert into writerof values('026-534-3081-37-8', 1)
insert into writerof values('546-574-8981-21-7', 5)
insert into writerof values('095-521-3521-69-5', 5)

insert into reader values('Daisey Johnes', 'daisey@yahoo.com', '924-837-7009-82-3')

select * from book
select * from author
select * from writerof
select * from reader

-- Увеличете цената на всички книги, които са написани от автори 
-- с име 'John Smith' с 10.

update book
	set price = price + 10
where isbn in (select distinct b.isbn
				from book b join writerof w on b.ISBN = w.book_isbn
					join author a on w.author_id = a.id
				where a.name = 'John Smith')

-- Изтрийте книгите написани от автора с email адрес 
-- 'jsmith@authors.io'

-- Първо трябва да се оправим с foreign key constraint-ите в
-- таблиците writerof и reader, за да можем като изтрием книгите
-- от book, те да се изтрият и от тези двете

alter table reader
drop constraint fk_reader

alter table reader
add constraint fk_reader foreign key(book_isbn) references book(isbn)
						on delete cascade

alter table writerof
drop constraint fk_writerof_book

alter table writerof
add constraint fk_writerof_book foreign key(book_isbn) references book(isbn)
						on delete cascade

delete from book
where isbn in (select isbn
				from book b join writerof w on b.ISBN = w.book_isbn
							join author a on w.author_id = a.id
				where a.email = 'jsmith@authors.io')

-- Направете така, че заявка, която трябва да намери автор с определен
-- email адрес да работи бързо, когато в таблицата с автори 
-- има милиони записи.

create unique nonclustered index index_email
on author(email)

-- Направете така, че автори, чиито email адрес завършва на 
-- 'smartauthors.com', да са само единствени автори на книги (да
-- не може да са съавтори с други автори).
go

create trigger tr_smart_authors_on_writerof on writerof
after insert, update
as
if exists(select w.book_isbn
			from writerof w join author a on w.author_id = a.id
			where w.book_isbn in (select distinct i.book_isbn
									from inserted i join author a 
										on i.author_id = a.id
									where a.email like '%smartauthors.com')
			group by w.book_isbn
			having count(*) > 1)
begin
	raiserror('Error!', 11, 1)
	rollback
end

go

go

create trigger tr_smart_authors_on_author on author
after update
as
if (update(email) or update(id)) and exists(select w.book_isbn
			from writerof w join author a on w.author_id = a.id
			group by w.book_isbn
			having count(*) > 1
				and w.book_isbn in (select distinct w2.book_isbn
									from writerof w2 join inserted i
										on w2.author_id = i.id
									where i.email like '%smartauthors.com'))
begin
	raiserror('Error!', 11, 1)
	rollback
end

go

-- Направете така, че да не може една книга да бъде заета от брой
-- читатели, надхвърлящ броя налични книги в библиотеката от съответното
-- заглавие

go

create trigger tr_copies1 on reader
after insert
as
if exists(select *
		from book b join reader r on b.ISBN = r.book_isbn
		where b.ISBN in (select ISBN
							from inserted)
		group by b.ISBN
		having b.copies < count(*))
begin
	raiserror('Error!', 11, 1)
	rollback
end

go

create trigger tr_copies2 on book
after update
as
if (update(copies) or update(ISBN)) and exists(select *
		from book b join reader r on b.ISBN = r.book_isbn
		where b.ISBN in (select ISBN
							from inserted)
		group by b.ISBN
		having b.copies < count(*))
begin
	raiserror('Error!', 11, 1)
	rollback
end

go


