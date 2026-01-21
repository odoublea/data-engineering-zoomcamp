-- For the trips in November 2025, how many trips had a trip_distance of less than or equal to 1 mile?

SELECT COUNT(1)
FROM green_taxi_data
WHERE trip_distance < 1.00;

SELECT *
FROM green_taxi_data
LIMIt 10;

-- Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles?
SELECT lpep_pickup_datetime, trip_distance
FROM green_taxi_data
WHERE trip_distance < 100
ORDER BY trip_distance DESC
LIMIT 10;

-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

SELECT z."Zone", SUM(g.trip_distance) AS total_trips
FROM green_taxi_data g
LEFT JOIN taxi_zone_lookup z 
ON z."LocationID" = g."PULocationID" 
WHERE DATE_TRUNC('DAY', lpep_pickup_datetime) = '2025-11-18' AND z."LocationID" = g."PULocationID" 
GROUP bY 1
ORDER BY total_trips DESC
LIMIT 1;

-- For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

SELECT g."DOLocationID", z."Zone", SUM(g.trip_distance) AS total_trips
FROM green_taxi_data g
LEFT JOIN taxi_zone_lookup z 
ON z."LocationID" = g."DOLocationID"
WHERE z."LocationID" = g."DOLocationID" and z."Zone" = 'East Harlem North'
GROUP BY g."DOLocationID", z."Zone"
ORDER BY total_trips DESC;


SELECT * FROM taxi_zone_lookup;

