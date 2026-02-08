CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.hw3_taxi.yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://de_zoomcamp_hw3_v1/yellow_tripdata_2024-*.parquet']
);

LOAD DATA INTO `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular`
FROM FILES (
  format = 'PARQUET',
  uris = ['gs://de_zoomcamp_hw3_v1/yellow_tripdata_2024-*.parquet']
);


-- check the total number of rows
SELECT count(1) FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata`;

-- preview the first 10 rows
SELECT * FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata` LIMIT 10;

-- Count the distinct number of PULocationIDs for the entire dataset on both the tables.
SELECT count(DISTINCT PULocationID) FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata`;

SELECT count(DISTINCT PULocationID) FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular`;

-- Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.
SELECT PULocationID FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular`;
SELECT PULocationID, DOLocationID FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular`;

-- How many records have a fare_amount of 0?
SELECT count(1) FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata` WHERE fare_amount = 0;

-- How many records have a fare_amount of 0?
SELECT count(1) FROM `instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_materialized` WHERE fare_amount = 0;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_non_partitioned AS
SELECT * FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned 
PARTITION BY DATE(tpep_pickup_datetime) AS
SELECT * FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata;

-- Measuring impact of partition
-- Non partitioned
SELECT DISTINCT(VendorID)
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' and '2024-04-30'; -- 310MB

-- Partitioned
SELECT DISTINCT(VendorID)
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' and '2024-04-30'; -- 211MB

-- Checking partition distribution
SELECT table_name, partition_id, total_rows
FROM data_warehouse_hw3.INFORMATION_SCHEMA.PARTITIONS
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Create a partition and cluster table from external table
CREATE OR REPLACE TABLE instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned_clustered 
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata;

-- Partitioned vs Partitioned_Clustered

-- Partitioned
SELECT count(*) AS trips
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' and '2024-04-30'
AND VendorID = 1; -- Query scans 199MB

-- Partitioned_Clustered
SELECT count(*) AS trips
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' and '2024-04-30'
AND VendorID = 1; -- Query scans 169MB


-- Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? 

-- Regular
SELECT DISTINCT(VendorID)
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' and '2024-03-15'; -- Query scans 310MB

-- Partitioned_Clustered
SELECT DISTINCT(VendorID)
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' and '2024-03-15'; -- Query scans 27MB

-- Regular Count
SELECT count(*) AS trips
FROM instant-maxim-461311-p6.data_warehouse_hw3.yellow_tripdata_regular;




