-- ����� ��������������� https://livesql.oracle.com ���� ��� �� ��� ����� �� �������� � ��� �� ����� ����������


DROP TABLE sales;
DROP TABLE dep;
DROP TABLE prod;

-- ���� ��� ����� �������� �������: ������

CREATE TABLE dep
(
   id     NUMBER (10) NOT NULL,
   city   VARCHAR2 (100) NOT NULL,
   name   VARCHAR2 (100) NOT NULL,
   CONSTRAINT dep_pk PRIMARY KEY (id)
);

-- ��������

CREATE TABLE prod
(
   id      NUMBER (10) NOT NULL,
   price   NUMBER (10) NOT NULL,
   name    VARCHAR2 (100) NOT NULL,
   CONSTRAINT prod_pk PRIMARY KEY (id)
);

-- �������

CREATE TABLE sales
(
   time      DATE NOT NULL,
   dep_id    NUMBER (10) NOT NULL,
   prod_id   NUMBER (10) NOT NULL,
   cost      NUMBER (10, 2) NOT NULL,
   CONSTRAINT sales_fk1 FOREIGN KEY (dep_id) REFERENCES dep (id),
   CONSTRAINT sales_fk2 FOREIGN KEY (prod_id) REFERENCES prod (id)
);

-- ��� ������������ ����� ��� ���������

DECLARE
BEGIN
   FOR i IN 1 .. 100 LOOP
      INSERT INTO dep
           VALUES (i,
                   CASE
                      WHEN i <= 50 THEN 'town1'
                      ELSE 'town2'
                   END,
                      'dep'
                   || to_char (i));

      INSERT INTO prod
           VALUES (i,
                   i * 10,
                      'prod'
                   || to_char (i));
   END LOOP;

   FOR i IN 1 .. 1000 LOOP
      INSERT INTO sales
           VALUES (trunc (to_date ('01.01.2016', 'dd.mm.yyyy')) + sys.DBMS_RANDOM.value (0, 0.99) - i,
                   mod (i, 100) + 1,
                   mod (i, 100) + 1,
                   i);
   END LOOP;

   COMMIT;
END;
/

-- ����������� ��������� ������� - ��� �������, ��������� � ������� �����������.
--
-- �������� ������� (������ �������� � DB Oracle):
-- ������� ������ ���� ����������� ����������������� (�� ������ ����������������� �� ���� ����, ��������������� ��������, ...)

-- 1. �������� ��� ������� ������������� � ������ 'town1' �� 2015 ���

-- 2. �������� ��� ������, ��� � ����� 2014 ���� ���� ������� ������� � ����� ������ 500.

-- 3. ��������� ���� � ��� ���� � ���� �������, ������� ����������� � ������� ���� � ������ 'dep10'

-- 4. ��������� ������� ����� �� ��������� ��������� ������� ��������� � ������ 'town1'
-- � ������ � ������������ ���� �� ������� ������������ � ��������� ���� (���� ����� ����������, � ����������� �� ���� ����������)
-- ��� ������ ���� ������ ������ � ������� ��������, ������ ������������� �������, ����������� pl/sql ����� �� �����
-- (��� ����� ������� ������� ��� ����� ������� �������������).
-- (������ ���� 13 �������� � 3 ������) :
----------------------------------------
--��� \ ����� 1 2 3 4 5 6 7 8 9 10 11 12
----------------------------------------
--2013        x x x x x x x x x x  x  x
--2014        x x x x x x x x x x  x  x
--2015        x x x x x x x x x x  x  x