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


--Emlynne Torritti (id 20), has decided to drop band and join drama. She wants to know all of the other students in her grade level who are already enrolled in drama.
--Use the tables drama_students and band_students to create a subquery that finds the students enrolled in drama that are in the same grade as Emlynne.
SELECT * FROM drama_students 
where grade =(
  select grade
  from band_students
  where id=20
)
;