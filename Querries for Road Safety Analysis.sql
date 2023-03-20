SET search_path TO accidents;
CREATE TABLE accident(
	accident_index VARCHAR(130),
    accident_severity INT
);

CREATE TABLE vehicles(
	accident_index VARCHAR(130),
    vehicle_type VARCHAR(50)
);

/* First: for vehicle types, create new csv by extracting data 
from Vehicle Type sheet from Road-Accident-Safety-Data-Guide.xls */
CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(100)
);
--------------------------------------------------------------
COPY accident FROM 'C:\\Accidents_2015.csv' DELIMITER ',' CSV HEADER;
COPY vehicle_types FROM 'C:/vehicle_types.csv'
DELIMITER ',' CSV HEADER;
COPY vehicles FROM 'C:/Vehicles_2015.csv'
DELIMITER ',' CSV HEADER;

---- Using indexes will perform faster 
CREATE INDEX accident_index
ON accident(accident_index);

CREATE INDEX accident_index
ON vehicles(accident_index);
--------------------------------------------------------------
SET search_path = accidents

SELECT * FROM accident;
SELECT * FROM vehicle_types;
SELECT * FROM vehicles;

/* 
Dataset: 

The dataset has three tables:

Accident: It contains information related to the location 
of each accident, the number of casualties that occurred, 
temporal data, and weather conditions on the day of the accident.

Vehicle: It has all the necessary information about the vehicle and its driver.

Vehicle_Type: It contains more information about the 
vehicle involved in an accident.

SQL Project Idea: Use aggregate functions in SQL and Python 
to answer the following sample questions:
*/

/*
1/Evaluate the median severity value of accidents caused by various Motorcycles.
*/
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY accident_severity) AS median_value
FROM accident;

/*
Evaluate Accident Severity and Total Accidents per Vehicle Type
*/

-- Alter column vehicle.vehicle_type from varchar to int
ALTER TABLE vehicles
ALTER COLUMN vehicle_type TYPE integer
USING vehicle_type::integer;

SELECT 
	vehicle_types.vehicle_type as vehicle_type, 
	accident.accident_severity AS severity,
	COUNT(vehicle_types.vehicle_type) AS total_accidents
FROM
	accident
JOIN
	vehicles USING (accident_index)
JOIN 	
	vehicle_types ON vehicles.vehicle_type = vehicle_types.vehicle_code
GROUP BY 
	vehicle_types.vehicle_type,
	accident.accident_severity
ORDER BY
 	accident.accident_severity;
	
/*
Calculate the Average Severity by vehicle type.
*/
SELECT 
	vehicle_types.vehicle_type as vehicle_type, 
	ROUND(AVG(accident.accident_severity),2) || '%' AS average_severity
FROM
	accident
JOIN
	vehicles USING (accident_index)
JOIN 	
	vehicle_types ON vehicles.vehicle_type = vehicle_types.vehicle_code
GROUP BY
	vehicle_types.vehicle_type
ORDER BY
	AVG(accident.accident_severity);
	
/*
Calculate the Average Severity and Total Accidents by Motorcycle.
*/
SELECT 
	vehicle_types.vehicle_type as vehicle_type, 
	ROUND(AVG(accident.accident_severity),2) || '%' AS average_severity,
	COUNT(vehicle_types.vehicle_type) AS total_accidents
FROM
	accident
JOIN
	vehicles USING (accident_index)
JOIN 	
	vehicle_types ON vehicles.vehicle_type = vehicle_types.vehicle_code
GROUP BY 
	vehicle_types.vehicle_type
HAVING 
	vehicle_types.vehicle_type ILIKE '%motorcycle%'
ORDER BY
 	COUNT(vehicle_types.vehicle_type) DESC


