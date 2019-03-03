use ships

-- �������� ������, ����� ������� ����� �� ��������, ��-�����
-- (displacement) �� 35000
select distinct s.name
from ships s
	join classes c on s.CLASS = c.CLASS
where c.DISPLACEMENT > 35000

-- �������� ������, ����� ������� �������, �����������������
-- � ���� ������ �� ������ ������, ��������� � ������� ��� 
-- 'Guadalcanal'
select distinct s.NAME, c.BORE, c.NUMGUNS
from outcomes o
	 join ships s on o.ship = s.NAME
	 join CLASSES c on s.CLASS = c.CLASS
where o.BATTLE = 'Guadalcanal'

-- �������� ������, ����� ������� ������� �� ���� �������, ����� 
-- ���� ������� ������ �� ��� �bb� � �bc� ������������
select distinct c1.COUNTRY
from CLASSES c1
	join CLASSES c2 on c1.COUNTRY = c2.COUNTRY
where c1.TYPE = 'bb' and c2.TYPE = 'bc'

-- �������� ������, ����� ������� ������� �� ���� ������, ����� 