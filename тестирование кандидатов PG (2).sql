-- ��� ���������� ������� ����� ������������ ����� �� PostgreeSQL �������� ������ https://extendsclass.com/postgresql-online.html


-- DROP TABLE sales;
-- DROP TABLE dep;
-- DROP TABLE prod;


-- ���� ��� ����� �������� �������: ������
CREATE TABLE dep
(
    id   integer NOT NULL,
    city text    NOT NULL,
    name text    NOT NULL,
    CONSTRAINT dep_pk PRIMARY KEY (id)
);

-- ��������

CREATE TABLE prod
(
    id    integer NOT NULL,
    price integer NOT NULL,
    name  text    NOT NULL,
    CONSTRAINT prod_pk PRIMARY KEY (id)
);

-- �������

CREATE TABLE sales
(
    time    timestamp    NOT NULL,
    dep_id  integer        NOT NULL,
    prod_id integer        NOT NULL,
    cost    numeric(10, 2) NOT NULL,
    CONSTRAINT sales_fk1 FOREIGN KEY (dep_id) REFERENCES dep (id),
    CONSTRAINT sales_fk2 FOREIGN KEY (prod_id) REFERENCES prod (id)
);

commit;

-- ��� ������������ ����� ��� ���������

INSERT INTO dep
select i,
       CASE
           WHEN i <= 50 THEN 'town1'
           ELSE 'town2'
           END,
       'dep'
           || i::text
from generate_series(1, 100) as i;

INSERT INTO prod
select i,
       i * 10,
       'prod'
           || i::text
from generate_series(1, 100) as i;


INSERT INTO sales
select timestamp '2021-01-01 00:00' + interval '1 day' * random() - interval '1 day' * i,
       mod(i, 100) + 1,
       mod(i, 100) + 1,
       i
from generate_series(1, 1000) as i;
COMMIT;

-- ����������� ��������� ������� - ��� �������, ��������� � ������� �����������.
--
-- �������� ������� (������ �������� � DB PostgreeSQL):
-- ������� ������ ���� ����������� �����������������

-- 1. �������� ��� ������� ������������� � ������ 'town1' �� 2019 ���

-- 2. �������� ��� ������, ��� � ����� 2020 ���� ���� ������� ������� � ����� (sales.cost) ������ 500.

-- 3. ��������� �������� ���� (prod.price)  � ������� � ��� ���� � ���� �������, ������� ����������� � 2018 ���� � ������ 'dep10'

-- 4. ��������� ������� ����� �� ��������� ��������� ������� ��������� � ������ 'town1'
-- � ������ � 2018 ���� �� ������� ������������ � ��������� ����
-- ��� ������ ���� ������ ������ � ������� ��������, ������ ������������� �������, ����������� pl/pgsql ����� �� �����
-- (��� ����� ������� ������� ��� ����� ������� �������������).
-- (������ ���� 13 �������� � 3 ������) :
----------------------------------------
--��� \ ����� 1 2 3 4 5 6 7 8 9 10 11 12
----------------------------------------
--2018        x x x x x x x x x x  x  x
--2019        x x x x x x x x x x  x  x
--2020        x x x x x x x x x x  x  x


