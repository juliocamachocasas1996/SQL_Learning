-- Skills you'll gain
-- Work effectively with NULL as a SQL field value
-- Use CASE to initiate conditional statements
-- Use aggregate functions like COUNT and SUM
-- Combine conditionals and aggregates to return useful measures of table data
-- Skills you'll gain
-- Work effectively with NULL as a SQL field value
-- Use CASE to initiate conditional statements
-- Use aggregate functions like COUNT and SUM
-- Combine conditionals and aggregates to return useful measures of table data

-- Count the number of rows in the flights table, representing the total number of flights contained in the table.
select count(*) from flights
;
--Count the number of rows from the flights table, where arr_time is not null and the destination is ATL.
select count(*) from flights
where arr_time is not null and destination='ATL'
;
--CASE WHEN
-- Almost every programming language has a way to represent “if, then, else”, or conditional logic. In SQL, we represent this logic with the CASE statement, as follows:
SELECT
    CASE
        WHEN elevation < 500 THEN 'Low'
        WHEN elevation BETWEEN 500 AND 1999 THEN 'Medium'
        WHEN elevation >= 2000 THEN 'High'
        ELSE 'Unknown'
    END AS elevation_tier
    , COUNT(*)
FROM airports
GROUP BY 1;
-- In the above statement, END is required to terminate the statement, but ELSE is optional. If ELSE is not included, the result will be NULL. 
-- Also notice the shorthand method of referencing columns to use in GROUP BY, so we don’t have to rewrite the entire Case Statement.
SELECT
    CASE
        WHEN elevation < 250 THEN 'Low'
        WHEN elevation BETWEEN 250 AND 1749 THEN 'Medium'
        WHEN elevation >= 1750 THEN 'High'
        ELSE 'Unknown'
    END AS elevation_tier
    , COUNT(*)
FROM airports
GROUP BY 1
;
-- COUNT(CASE WHEN )
-- Sometimes you want to look at an entire result set, but want to implement conditions on certain aggregates.
-- For instance, maybe you want to identify the total amount of airports as well as the total amount of airports 
-- with high elevation in the same result set. We can accomplish this by putting a CASE WHEN statement in the aggregate.
SELECT	state, 
    COUNT(CASE WHEN elevation >= 2000 THEN 1 ELSE NULL END) as count_high_elevation_aiports 
FROM airports 
GROUP BY state;
-- Using the same pattern, write a query to count the number of low elevation airports by state where low elevation is defined as less than 1000 ft.

-- Be sure to alias the counted airports as count_low_elevation_airports.
SELECT	state, 
    COUNT(CASE WHEN elevation < 1000 THEN 1 ELSE NULL END) as count_low_elevation_aiports 
FROM airports 
GROUP BY state;
--SUM(CASE WHEN )
-- We can do that same thing for other aggregates like SUM(). For instance, if we wanted to sum the total flight distance 
-- and compare that to the sum of flight distance from a particular airline (in this case, United Airlines) by origin airport, we could run the following query:
SELECT origin, sum(distance) as total_flight_distance, sum(CASE WHEN carrier = 'UA' THEN distance ELSE 0 END) as total_united_flight_distance 
FROM flights 
GROUP BY origin;

-- Using the same pattern, find both the total flight distance and the flight distance by origin for Delta (carrier = 'DL').
-- Alias the flight distance as total_flight_distance and the flight distance by origin as total_delta_flight_distance.
SELECT origin, sum(distance) as total_flight_distance, sum(CASE WHEN carrier = 'DL' THEN distance ELSE 0 END) as total_delta_flight_distance 
FROM flights 
GROUP BY origin;
-- Combining aggregates
-- Oftentimes we’d like to combine aggregates, to create percentages or ratios.

-- In the instance of the last query, we might want to find 
-- out the percent of flight distance that is from United by origin airport. We can do this simply by using the mathematical operators we need in SQL:
SELECT origin, 
    (100.0*(sum(CASE WHEN carrier = 'UN' THEN distance ELSE 0 END))/sum(distance)) as percentage_flight_distance_from_united FROM flights 
GROUP BY origin;
-- Using the same pattern, find the percentage of flights from Delta by origin (carrier = 'DL')
-- In the query, alias the column as
SELECT origin, 
    (100.0*(sum(CASE WHEN carrier = 'DL' THEN distance ELSE 0 END))/sum(distance)) as percentage_flight_distance_from_delta FROM flights 
GROUP BY origin;
-- Combining aggregates II
-- Modify the previous elevation example to find the percentage of high elevation airports (elevation >= 2000) by state.
-- Find the percentage of high elevation airports (elevation >= 2000) by state from the airports table.
-- In the query, alias the percentage column as percentage_high_elevation_airports.
SELECT state, 100.0 * sum(CASE WHEN elevation >= 2000 THEN 1 ELSE 0 END) / count(*)  as percentage_high_elevation_airports FROM airports GROUP BY state;