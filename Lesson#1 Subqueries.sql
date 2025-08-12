-- Select the first 10 rows from each of the tables to get a feel for the data.
select * from GF_COMMERCIAL_DOMAIN.BROKER.GF_SHIPMENTS limit 10;

-- Subqueries
SELECT first_name, last_name
FROM band_students
WHERE id IN (SELECT id from drama_students);

--Query that will remove 9th grade students enrolled in both band and drama from the drama_students table.
delete from drama_students
where id in (
  select id from band_students
  where grade=9
);


