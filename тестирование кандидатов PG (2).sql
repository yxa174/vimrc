-- ƒл€ выполнени€ задани€ можно использовать любую Ѕƒ PostgreeSQL например онлайн https://extendsclass.com/postgresql-online.html


-- DROP TABLE sales;
-- DROP TABLE dep;
-- DROP TABLE prod;


-- есть три очень условные таблицы: отделы
CREATE TABLE dep
(
    id   integer NOT NULL,
    city text    NOT NULL,
    name text    NOT NULL,
    CONSTRAINT dep_pk PRIMARY KEY (id)
);

-- продукты

CREATE TABLE prod
(
    id    integer NOT NULL,
    price integer NOT NULL,
    name  text    NOT NULL,
    CONSTRAINT prod_pk PRIMARY KEY (id)
);

-- продажи

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

-- дл€ тестировани€ можно так заполнить

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

-- ¬нимательно прочитать задание - все услови€, указанные в задании оцениваютс€.
--
-- Ќаписать запросы (должно работать в DB PostgreeSQL):
-- «апросы должны быть максимально оптимизированными

-- 1. получить все продажи произведенные в городе 'town1' за 2019 год

-- 2. показать все отделы, где в марте 2020 года были продажи товаров с ценой (sales.cost) меньше 500.

-- 3. увеличить значение цены (prod.price)  в таблице в два раза у всех товаров, которые продавались в 2018 году в отделе 'dep10'

-- 4. составить сводный отчет по суммарной стоимости товаров проданных в городе 'town1'
-- в период с 2018 года по текущий включительно в следующем виде
-- Ёто должен быть просто запрос к текущим таблицам, делать промежуточные таблицы, заполненные pl/pgsql кодом не нужно
-- (при очень большом желании это можно сделать дополнительно).
-- (ƒолжно быть 13 столбцов и 3 строки) :
----------------------------------------
--год \ мес€ц 1 2 3 4 5 6 7 8 9 10 11 12
----------------------------------------
--2018        x x x x x x x x x x  x  x
--2019        x x x x x x x x x x  x  x
--2020        x x x x x x x x x x  x  x


