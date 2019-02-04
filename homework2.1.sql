
use labor_sql;
-- -- 4.
-- 1 
SELECT DISTINCT maker FROM product p WHERE p.maker 
in (SELECT p1.maker FROM product p1 WHERE p1.type='pc' ) and p.maker not in (SELECT p1.maker FROM product p1 WHERE p1.type='laptop');

-- 2
 SELECT DISTINCT maker, type FROM product WHERE maker  != ALL(SELECT maker from product where type='laptop') AND type  LIKE 'pc';

-- 3
 SELECT distinct p.maker FROM labor_sql.product as p where p.maker NOT IN (
 SELECT distinct p.maker FROM labor_sql.product as p where p.maker = any   
 (SELECT distinct pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop'))  and p.type like 'PC';
-- 4
 SELECT distinct p.maker FROM labor_sql.product as p where p.maker in  
 (SELECT pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop' and p.type like 'PC');

-- 5
	SELECT * FROM product pr WHERE 
	NOT pr.model != ALL(SELECT pc.model FROM pc)
	AND
	NOT pr.maker !=ALL(SELECT pr2.maker FROM laptop JOIN product as pr2 ON laptop.model = pr2.model WHERE pr2.maker = pr.maker);
-- 6
	SELECT * FROM product pr WHERE 
	pr.model = ANY(SELECT pc.model FROM pc )
	AND
	pr.maker = ANY(SELECT pr2.maker FROM laptop JOIN product as pr2 ON laptop.model = pr2.model WHERE pr2.maker = pr.maker); 
-- 7
	SELECT * FROM product pr WHERE (SELECT COUNT(*) FROM product where pr.maker);

	SELECT distinct maker FROM product where model = any(SELECT model FROM pc);
-- -- 5.
-- 1
SELECT P.maker FROM Product P WHERE EXISTS (SELECT * FROM PC WHERE PC.model = P.model);
-- 2
SELECT  P.maker FROM Product P WHERE EXISTS (SELECT model  FROM PC WHERE PC.model = P.model and PC.speed >=750);
-- 3
SELECT DISTINCT P.maker FROM Product P WHERE EXISTS (SELECT *  FROM PC WHERE PC.model = P.model and PC.speed >=750
AND EXISTS (SELECT *  FROM Laptop  l WHERE l.speed >= 750 and EXISTS(SELECT * FROM Product P2 WHERE P2.model = l.model ))); 
-- 4 
SELECT  DISTINCT maker FROM PC JOIN Product p3 ON p3.model=PC.model WHERE EXISTS(SELECT * FROM Product  p 
WHERE p.model=PC.model and EXISTS(SELECT * FROM Product p2 WHERE p2.maker = p.maker AND p2.type = 'Printer')) 
AND speed = (SELECT MAX(speed) FROM PC );
-- 5
SELECT name, launched, displacement  FROM ships s  JOIN classes c ON c.class = s.class WHERE EXISTS(SELECT * FROM classes c WHERE s.class = c.class 
AND c.displacement>35000 ) AND launched > 1922;
-- 6 TODO

-- 7



-- --6.
-- 1
-- SELECT CONCAT('Average price = ',FORMAT(AVG(price),'E')) as AVG_PRICE  FROM laptop
-- 2
-- SELECT CONCAT('code',code), CONCAT('model ',model),CONCAT('speed',speed),CONCAT('ram',ram),CONCAT('hd',hd),CONCAT('cd',cd), CONCAT('price ',price) FROM PC
-- 3
-- SELECT  * FROM income
-- SELECT DATE_FORMAT(date, '%Y.%m.%d') AS DATE FROM income
-- 4
-- SELECT ship, battle, replace(replace(replace(result,'sunk','potonuv'),'damaged','poshkodjenyi'),'OK','zhyvyi') AS Translate FROM outcomes;
-- 5
-- SELECT CONCAT('Row:', SUBSTRING(place, 1, 1)) AS row1, CONCAT('Place:', SUBSTRING(place, 2, 1)) AS place  FROM pass_in_trip;
-- 6
-- SELECT CONCAT("From ",town_from, " to ",town_to) AS direction  FROM trip;
-- --7.
-- 1
-- SELECT model, MAX(price) as price FROM printer;	
-- 2
-- SELECT type, p.model, speed FROM laptop l JOIN Product p ON  p.model = l.model WHERE speed < ANY(SELECT pc.speed FROM pc)
-- 3
-- 	SELECT p.maker, printer.price FROM product p JOIN printer  ON p.model=printer.model AND printer.price=(SELECT min(price) from printer) ;
-- 4
-- 	SELECT maker, COUNT(pr.model) as count FROM Product pr JOIN pc ON pr.model = pc.model  GROUP BY maker  HAVING count>2
-- 5
-- SELECT AVG(hd) as avg_hd FROM product  p JOIN pc ON p.model = pc.model WHERE EXISTS(SELECT * FROM product WHERE type = 'printer' and maker = p.maker)

-- -- 8.
-- 1.
SELECT maker,
	   			(SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = product.maker) as pc,
 	 			(SELECT COUNT(*) FROM  laptop JOIN product pr ON laptop.model = pr.model WHERE pr.maker = product.maker) as laptop,
 				(SELECT COUNT(*) FROM  printer JOIN product pr ON printer.model = pr.model WHERE pr.maker = product.maker) as printer
  FROM product  GROUP  BY  maker;

-- 2
-- SELECT maker, avg(screen) FROM product p JOIN laptop l ON p.model = l.model group by maker;
-- 3
-- SELECT maker, max(price) FROM product p JOIN pc ON p.model = pc.model group by maker;
-- 4
-- SELECT maker, min(price) FROM product p JOIN pc ON p.model = pc.model group by maker;
-- 5
-- SELECT  speed, (SELECT AVG(price) FROM PC p2 WHERE p2.speed = p1.speed) as average_price FROM PC p1 WHERE p1.speed> 600  


-- -- 9.
-- 1
 -- SELECT p.maker, case When (SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = p.maker)>0 
 -- THEN CONCAT('YES(',FORMAT((SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = p.maker),'E'),')') 
 -- ELSE 'NO' END  as pc FROM product p group by maker;

-- TODO
-- SELECT -- CASE
-- 	WHEN (COUNT(*))>0   THEN CONCAT('YES(',count(*),')')
 --    ELSE 'NO'
-- 	END AS pc_count
-- FROM product  pr left join pc on pr.model = pc.model GROUP BY maker;
-- 2
SELECT point, date, 
				CASE  
				WHEN  subquery.inc IS NULL THEN 0
                ELSE subquery.inc
                END as 'inc', 
                CASE  
				WHEN  subquery.out IS NULL THEN 0
                ELSE subquery.out
                END as 'out' 
FROM (SELECT i.point, i.date, inc, o.out FROM income_o i left join outcome_o   o on i.date = o.date 
	UNION
SELECT o.point, o.date, inc, o.out FROM income_o i right join outcome_o  o on i.date = o.date) as subquery;
-- 3
	SELECT * FROM ships s JOIN classes c ON s.class= c.class 
    WHERE    case WHEN numGuns = 8 OR bore = 15 OR displacement= 32000 OR type= 'bb'THEN true
    ELSE false 
    end;
-- 4


-- -- 10.
-- 1
SELECT maker, product.model, product.type, price FROM product 	JOIN pc ON pc.model = product.model WHERE maker = 'B'
UNION ALL
SELECT maker, product.model, product.type, price FROM product 	JOIN laptop ON laptop.model = product.model WHERE maker = 'B'
UNION ALL
SELECT maker, product.model, product.type, price FROM product 	JOIN printer ON printer.model = product.model WHERE maker = 'B';
-- 2
SELECT  product.model, product.type, MAX(price) FROM product 	JOIN pc ON pc.model = product.model 
UNION 
SELECT product.model, product.type, MAX(price) FROM product 	JOIN laptop ON laptop.model = product.model 
UNION 
SELECT product.model, product.type, MAX(price) FROM product 	JOIN printer ON printer.model = product.model;
-- 3
SELECT AVG(price) FROM(
		SELECT  price FROM product 	JOIN pc ON pc.model = product.model WHERE maker = 'A'
			UNION 
		SELECT  price FROM product 	JOIN laptop ON laptop.model = product.model WHERE maker = 'A') as s;
-- 4
SELECT name, class FROM ships WHERE class=name 
	UNION 
SELECT ship, ship FROM outcomes WHERE EXISTS(SELECT * FROM ships WHERE outcomes.ship = ships.class); 
-- 5
 SELECT * FROM(SELECT name FROM ships WHERE class=name 
	UNION ALL 
SELECT ship FROM outcomes WHERE EXISTS(SELECT * FROM ships WHERE outcomes.ship = ships.class)) as s  GROUP BY name HAVING  COUNT(*)=1; 
-- 6
