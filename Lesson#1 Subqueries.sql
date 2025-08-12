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

-- Write a query that gives the first and last names of students enrolled in band but not in drama.
SELECT first_name, last_name
FROM band_students
WHERE id NOT IN (
   SELECT id
   FROM drama_students);

--If we compare this functionality in terms of efficiency, EXISTS/NOT EXISTS are usually more efficient than IN/NOT IN clauses; this is because the IN/NOT IN clause has to return all rows meeting the specific criteria whereas the EXISTS/NOT EXISTS
-- only needs to find the presence of one row to determine if a true or false value needs to be returned.
--In the previous exercise, we used an example query that pulled students who are enrolled in both statistics and history using IN — the following query pulls the same information using EXISTS instead:
SELECT * 
FROM statistics_students
WHERE EXISTS (
  SELECT * 
  FROM history_students
  WHERE id = statistics_students.id
);

---Write a query that produces the first and last names of all the students who are enrolled in both band AND drama.
select first_name,last_name from band_students 
where exists (
  select first_name,last_name from drama_students
  where id=band_students.id
);