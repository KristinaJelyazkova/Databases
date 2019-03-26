--�������� ������, ����� �� ����� ����, ��-����� �� 120 ������, �������
--��������, ������, ��� � ����� �� ������
select TITLE, YEAR, NAME, ADDRESS
from MOVIE m join STUDIO s
				on m.STUDIONAME = s.NAME
where m.LENGTH > 120

-- 1.2. �������� ������, ����� ������� ����� �� �������� � ������� ��
--      ���������, ��������� ��� �����, ����������� �� ���� ������,
--      ��������� �� ��� �� ������.
select distinct m.STUDIONAME, s.STARNAME
from movie m join STARSIN s on m.TITLE = s.MOVIETITLE and m.year = s.MOVIEYEAR
order by m.STUDIONAME

-- 1.3. �������� ������, ����� ������� ������� �� ������������ �� �������,
--      � ����� � ����� Harrison Ford.
select distinct name
from MOVIEEXEC m1 join MOVIE m2 on m1.CERT# = m2.PRODUCERC#
where m2.title in (select MOVIETITLE
					from STARSIN
					where STARNAME = 'Harrison Ford')

select distinct e.name
from movie m 
		join starsin s on m.TITLE = s.MOVIETITLE and m.YEAR = s.MOVIEYEAR
		join MOVIEEXEC e on m.PRODUCERC# = e.CERT#
where STARNAME = 'Harrison Ford'

-- 1.4. �������� ������, ����� ������� ������� �� ���������, ������ ���
--      ����� �� MGM.
select distinct ms.name
from MOVIESTAR ms join STARSIN s on ms.NAME = s.STARNAME
		join movie m on s.MOVIETITLE = m.TITLE and s.MOVIEYEAR = m.YEAR
where STUDIONAME = 'MGM' and GENDER = 'F'

-- 1.5. �������� ������, ����� ������� ����� �� ���������� � ������� ��
--      �������, ����������� �� ���������� �� 'Star Wars'.
select name, title
from MOVIEEXEC e join movie m on e.CERT# = m.PRODUCERC#
where m.PRODUCERC# = (select PRODUCERC#
				from MOVIE
				where title = 'Star Wars' and year = 1977)


-- 1.6. �������� ������, ����� ������� ������� �� ��������� �� ��������� �
--      ���� ���� ����.
select name
from moviestar m left join STARSIN s on m.NAME = s.STARNAME
where STARNAME is NULL