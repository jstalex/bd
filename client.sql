UPDATE car_service AS cs
SET name=cs1.name
FROM (
  SELECT
  	DISTINCT name, phone
  FROM car_service
  WHERE
  	name IS NOT NULL AND
  	phone IS NOT NULL
  	) AS cs1
WHERE cs.phone=cs1.phone;

UPDATE car_service AS cs
SET email=cs1.email
FROM (
  SELECT
  	DISTINCT email, phone
  FROM car_service
  WHERE
  	email IS NOT NULL AND
  	phone IS NOT NULL
  	) AS cs1
WHERE cs.phone=cs1.phone;

UPDATE car_service AS cs
SET password=cs1.password
FROM (
  SELECT
  	DISTINCT password, phone
  FROM car_service
  WHERE
  	password IS NOT NULL AND
  	phone IS NOT NULL
  	) AS cs1
WHERE cs.phone=cs1.phone;

UPDATE car_service AS cs
SET phone=cs1.phone
FROM (
  SELECT
  	DISTINCT email, phone
  FROM car_service
  WHERE
  	email IS NOT NULL AND
  	phone IS NOT NULL
  	) AS cs1
WHERE cs.email=cs1.email;


CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    phone TEXT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    password TEXT
);

INSERT INTO clients(
    phone, 
    first_name, 
    last_name, 
    email, 
    password
)
SELECT DISTINCT 
    phone, 
    SPLIT_PART(name, ' ', 1) AS first_name,
    SPLIT_PART(name, ' ', 2) AS last_name,
    email, 
    password
FROM car_service;


