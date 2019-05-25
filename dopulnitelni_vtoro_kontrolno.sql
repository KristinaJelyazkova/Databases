--�� �� ������� ���� � ��� library. ������ �� ���� �� ��������� ���������� ��:
create database library

--	�����
--          - ISBN - �������� ��� � ��������� ������� �� 17 �������
--          - ��� - �������� ��� �� �������� 128 �������
--          - ���� �������� - ���� ����� 
--          - ���� - ����� � ��������� ������� (5 ����� ����� ��������� � 2 ����)
--          - ������ (����� �� ����� ������ �� ����)
--          - ���� ������� ����� � ������������ �� ���� ��������

create table book(
	ISBN char(17) constraint pk_book primary key 
					constraint book_isbn check(ISBN like '___-___-____-__-_'),
	name varchar(128) not null,
	pages int not null check(pages > 0),
	price decimal(7,2) check(price > 0),
	copies int not null check(copies >= 0)
)

--  ������
--          - ��� - �������� ��� �� �������� 64 �������
--          - ����� - �������� ��� �� �������� 64 �������
--          - ������� - �������� ��� �� �������� 32 �������
--          - �������� ���� - ����
--          - Email ����� (������ 2 �������� ������ �� ���� ������� email ������)
--          - �����, ����� � ������� (����� �� �� ������ �� ����)

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

--  �������
--			- ��� - �������� ��� �� �������� 64 �������
--          - Email - ���������� ���� - �������� ��� �� �������� 64 �������
--          - ����� ����� (���� �� ���� ���� ����)

create table reader(
	id int identity constraint pk_reader primary key,
	name varchar(64) not null,
	email varchar(64) not null,
	book_isbn char(17) constraint fk_reader references book(ISBN)
)

-- ������ �� ����� ����� ���� �� �� � �������� (������ �� ������� NULL ���������)
-- ������ �������� �������� �� �������� NULL ���������
-- ISBN ������ �� ��� �������� ��������� XXX-XXX-XXXX-XX-X

-- �������� ��������� ������� �� ���������� ������� (���� �� �� �������
-- ���������� ������ - ���� �����, ����� �� �� ��������� � IDENTITY). 
-- ����������� ��������� PRIMARY KEY, UNIQUE, CHECK � FOREIGN KEY �����������.

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

-- ��������� ������ �� ������ �����, ����� �� �������� �� ������ 
-- � ��� 'John Smith' � 10.

update book
	set price = price + 10
where isbn in (select distinct b.isbn
				from book b join writerof w on b.ISBN = w.book_isbn
					join author a on w.author_id = a.id
				where a.name = 'John Smith')

-- �������� ������� �������� �� ������ � email ����� 
-- 'jsmith@authors.io'

-- ����� ������ �� �� ������� � foreign key constraint-��� �
-- ��������� writerof � reader, �� �� ����� ���� ������� �������
-- �� book, �� �� �� ������� � �� ���� �����

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

-- ��������� ����, �� ������, ����� ������ �� ������ ����� � ���������
-- email ����� �� ������ �����, ������ � ��������� � ������ 
-- ��� ������� ������.

create unique nonclustered index index_email
on author(email)

-- ��������� ����, �� ������, ����� email ����� �������� �� 
-- 'smartauthors.com', �� �� ���� ���������� ������ �� ����� (��
-- �� ���� �� �� �������� � ����� ������).
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

-- ��������� ����, �� �� �� ���� ���� ����� �� ���� ����� �� ����
-- ��������, ���������� ���� ������� ����� � ������������ �� �����������
-- ��������

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


