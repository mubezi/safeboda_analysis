
-- DATA CLEANING
SET sql_safe_updates = 0;

 SELECT * FROM ride;
describe ride;
-- change trip id to primary key

ALTER TABLE ride
MODIFY COLUMN trip_id INT PRIMARY KEY;

-- change column (current_state to either droppedoff or cancelled
SELECT DISTINCT current_state FROM ride;
SELECT * FROM ride 
WHERE current_state = 'manualdispatch' OR current_state = 'manualdispatchacknowledged';

UPDATE ride
SET current_state = 'droppedoff'
WHERE current_state = 'manualdispatch' OR current_state = 'manualdispatchacknowledged';

-- convert trip date from varchar to date formate
SELECT trip_date from ride;

ALTER TABLE ride
MODIFY COLUMN trip_date DATE;

SELECT * FROM ride;

UPDATE ride
SET trip_date = date_format(str_to_date(trip_date,'%m/%d/%Y'),'%Y-%m-%d');

-- change the city_id with the location it

ALTER TABLE ride
MODIFY COLUMN city_id VARCHAR(225);

UPDATE ride
SET city_id = 'Nairobi'
WHERE city_id =2;

select distinct city_id from ride;

UPDATE ride
SET city_id = 'Mombasa'
WHERE city_id =3;

-- QNS
-- 1. How many rides were completed and not completed in each of the cities

SELECT 
city_id, 
current_state,
count(*) as count
FROM ride
GROUP BY city_id,current_state
ORDER BY city_id;

-- 2. How many rides where completed and not completed for each of the three days

SELECT
trip_date,
count(*) as count
FROM ride
GROUP BY trip_date;

-- 3. How many rides where paid using cash, credit or business
SELECT payment_type, count(*) as count
FROM ride
group by payment_type;


-- 4. how many of the rides where pair requested(completed and not completed)
SELECT * FROM ride;

SELECT 
COUNT(CASE WHEN pair_requested_at IS NULL THEN 1 END) as pair_requested,
COUNT(CASE WHEN pair_requested_at IS NOT NULL THEN 1 END) as non_pair_requested
FROM ride;

-- 5. How many riders are there in the different hours of the day

SELECT 
date_format(requested_at, '%H') as hour_of_the_day,
count(*) as count
FROM ride
GROUP BY hour_of_the_day;

-- 6. Which cities have the highest pickup  locations
select 
pickup_location,
count(*) as count
FROM ride
GROUP BY pickup_location
ORDER BY count DESC;


-- 7. What the chances that a passengers orders for more than one ride a day

-- 8. What is the wait time before cancellation
SELECT * FROM ride;
SELECT 
current_state,
timestampdiff(minute, requested_at, passengercancelled_at) as time_before_cancellation,
count(*) as count
FROM ride
WHERE current_state = 'passengercancelled'
GROUP BY current_state, time_before_cancellation;

SELECT 
current_state,
timestampdiff(minute, pair_requested_at, passengercancelled_at) as time_before_cancellation,
count(*) as count
FROM ride
WHERE current_state = 'passengercancelled'
GROUP BY current_state, time_before_cancellation;

-- 9. Duration of completed trips

SELECT 
current_state,
timestampdiff(minute, started_trip_at, ended_trip_at) as trip_duration,
count(*) as count
FROM ride
WHERE current_state = 'droppedoff'
GROUP BY current_state, trip_duration;
