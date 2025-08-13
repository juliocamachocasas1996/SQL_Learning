-- Manipulate table data quickly and efficiently using set operations in SQL.

-- Skills you'll gain
-- Use SQL UNION, UNION ALL, INTERSECT, and EXCEPT commands
-- Understand the difference between INTERSECT and EXCEPT

-- Sometimes, in order to answer certain questions based on data, we need to merge two tables together and then query the merged result. 
-- Perhaps we have two tables that contain information about products in an ecommerce store that we would like to combine.

-- There are two ways of doing this:

-- Merge the rows, called a join.
-- Merge the columns, called a union.

-- Each SELECT statement within the UNION must have the same number of columns with similar data types. The columns in each SELECT statement must be in the same order. 
-- By default, the UNION operator selects only distinct values.

SELECT item_name FROM legacy_products
UNION 
SELECT item_name FROM new_products;
-- Select a complete list of brand names from the legacy_products and new_products tables.
select brand from legacy_products
union
select brand from new_products

;
-- What if we wanted to allow duplicate values? We can do this by using the ALL keyword with UNION, with the following syntax
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;

-- Using the same pattern, utilize a subquery to find the average sale price over both order_items and order_items_historic tables.
SELECT id,avg(a.sale_price) FROM (
  SELECT id, sale_price FROM order_items
  UNION ALL
  SELECT id, sale_price FROM order_items_historic) as a
group by id
;
-- INTERSECT is used to combine two SELECT statements, but returns rows only from the first SELECT statement that are identical
--  to a row in the second SELECT statement. This means that it returns only common rows returned by the two SELECT statements.
SELECT column_name(s) FROM table1
INTERSECT
SELECT column_name(s) FROM table2;
-- Select the items in the category column that are both in the newly acquired new_products table and the legacy_products table.
SELECT category FROM new_products
INTERSECT
SELECT category FROM legacy_products;
;
-- EXCEPT is constructed in the same way, but returns distinct rows from the first SELECT statement that aren’t output by the second SELECT statement.
SELECT column_name(s) FROM table1
EXCEPT
SELECT column_name(s) FROM table2;
-- Conversely, select the items in the category column that are in the legacy_products table and not in the new_products table.
SELECT category FROM legacy_products
EXCEPT
SELECT category FROM new_products
;
-- Congratulations! We just learned about Set Operations in SQL. What can we generalize so far?

-- The UNION clause allows us to utilize information from multiple tables in our queries.
-- The UNION ALL clause allows us to utilize information from multiple tables in our queries, including duplicate values.
-- INTERSECT is used to combine two SELECT statements, but returns rows only from the first SELECT statement that are identical to a row in the second SELECT statement.
-- EXCEPT returns distinct rows from the first SELECT statement that aren’t output by the second SELECT statement

