-- Можно воспользоваться https://livesql.oracle.com Если нет БД под рукой Но придёться у них на сайте зарегаться


DROP TABLE sales;
DROP TABLE dep;
DROP TABLE prod;

-- есть три очень условные таблицы: отделы

CREATE TABLE dep
(
   id     NUMBER (10) NOT NULL,
   city   VARCHAR2 (100) NOT NULL,
   name   VARCHAR2 (100) NOT NULL,
   CONSTRAINT dep_pk PRIMARY KEY (id)
);

-- продукты

CREATE TABLE prod
(
   id      NUMBER (10) NOT NULL,
   price   NUMBER (10) NOT NULL,
   name    VARCHAR2 (100) NOT NULL,
   CONSTRAINT prod_pk PRIMARY KEY (id)
);

-- продажи

CREATE TABLE sales
(
   time      DATE NOT NULL,
   dep_id    NUMBER (10) NOT NULL,
   prod_id   NUMBER (10) NOT NULL,
   cost      NUMBER (10, 2) NOT NULL,
   CONSTRAINT sales_fk1 FOREIGN KEY (dep_id) REFERENCES dep (id),
   CONSTRAINT sales_fk2 FOREIGN KEY (prod_id) REFERENCES prod (id)
);

-- для тестирования можно так заполнить

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

-- Внимательно прочитать задание - все условия, указанные в задании оцениваются.
--
-- Написать запросы (должно работать в DB Oracle):
-- Запросы должны быть максимально оптимизированными (на случай партиционирования по полю даты, соответствующим индексам, ...)

-- 1. получить все продажи произведенные в городе 'town1' за 2015 год

-- 2. показать все отделы, где в марте 2014 года были продажи товаров с ценой меньше 500.

-- 3. увеличить цену в два раза у всех товаров, которые продавались в прошлом году в отделе 'dep10'

-- 4. составить сводный отчет по суммарной стоимости товаров проданных в городе 'town1'
-- в период с позапрошлого года по текущий включительно в следующем виде (года могут поменяться, в зависимости от даты заполнения)
-- Это должен быть просто запрос к текущим таблицам, делать промежуточные таблицы, заполненные pl/sql кодом не нужно
-- (при очень большом желании это можно сделать дополнительно).
-- (Должно быть 13 столбцов и 3 строки) :
----------------------------------------
--год \ месяц 1 2 3 4 5 6 7 8 9 10 11 12
----------------------------------------
--2013        x x x x x x x x x x  x  x
--2014        x x x x x x x x x x  x  x
--2015        x x x x x x x x x x  x  x