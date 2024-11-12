--  В бурятии два сервиса получается 

UPDATE car_service AS cs
SET service=cs1.service
FROM (
  SELECT
  	DISTINCT service, w_phone
  FROM car_service
  WHERE
  	service IS NOT NULL AND
  	w_phone IS NOT NULL
  	) AS cs1
WHERE cs.w_phone=cs1.w_phone;

UPDATE car_service AS cs
SET service_addr=cs1.service_addr
FROM (
  SELECT
  	DISTINCT service_addr, w_phone
  FROM car_service
  WHERE
  	service_addr IS NOT NULL AND
  	w_phone IS NOT NULL
  	) AS cs1
WHERE cs.w_phone=cs1.w_phone;


CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service TEXT,
    service_addr TEXT
);

INSERT INTO services(service, service_addr)
SELECT DISTINCT 
    service, 
    service_addr
FROM car_service;
