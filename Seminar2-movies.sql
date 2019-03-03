use movies

-- �������� ������, ����� ������� ������� �� ��������� ����, ���������
-- � �Terms of Endearment�
select distinct s.STARNAME
from STARSIN s
	join MOVIESTAR m on s.STARNAME = m.NAME
where MOVIETITLE = 'Terms of Endearment' and m.GENDER = 'M'

-- �������� ������, ����� ������� ������� �� ���������, ��������� 
-- ��� �����, ����������� �� �MGM� ���� 1995 �.
select distinct s.STARNAME
from starsin s
	join movie m on s.MOVIETITLE = m.TITLE
where STUDIONAME = 'MGM' and YEAR = 1995

-- �������� ������, ����� ������� ������� �� ������ ����� � �������,
--  ��-������ �� ��������� �� ����� �Star Wars�
select distinct m1.TITLE
from movie m1
	join movie m2 on m2.TITLE = 'Star Wars' and m2.YEAR = 1977
where m1.LENGTH > m2.LENGTH