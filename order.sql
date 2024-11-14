-- Есть немого пропусков

-- card count = 62 080 
-- payment count = 62 126 
-- pin count = 62 214

-- Обновление поля payment в таблице car_service
UPDATE car_service AS cs
SET payment = cs1.payment
FROM (
    SELECT DISTINCT card, payment
    FROM car_service
    WHERE card IS NOT NULL AND payment IS NOT NULL
) AS cs1
WHERE cs.card = cs1.card;

-- Обновление поля pin в таблице car_service
UPDATE car_service AS cs
SET pin = cs1.pin
FROM (
    SELECT DISTINCT card, pin
    FROM car_service
    WHERE card IS NOT NULL AND pin IS NOT NULL
) AS cs1
WHERE cs.card = cs1.card;

-- Обновление поля card в таблице car_service
UPDATE car_service AS cs
SET card = cs1.card
FROM (
    SELECT DISTINCT card, pin
    FROM car_service
    WHERE card IS NOT NULL AND pin IS NOT NULL
) AS cs1
WHERE cs.pin = cs1.pin;

-- Получение количества уникальных карт с заполненными данными о платежах и пинах

-- SELECT DISTINCT count(card)
-- FROM car_service
-- WHERE card IS NOT NULL AND payment IS NOT NULL AND pin IS NOT NULL;

-- Таким образом получилось только 29 321 строку получить с заполненными данными о платежах
-- То есть таблица car_service сейчас имеет пропуски в платежах и немного в mileage

-- Создание таблицы orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    date DATE,
    service_id INTEGER,
    worker_id INTEGER,
    card TEXT,
    payment TEXT,
    pin TEXT,
    client_id INTEGER,
    car_id INTEGER,
    mileage TEXT
);

-- Вставка данных в таблицу orders
INSERT INTO orders (
    date,
    service_id,
    worker_id,
    card,
    payment,
    pin,
    client_id,
    car_id,
    mileage
)
SELECT
    date,
    s.service_id,
    w.worker_id,
    card,
    payment,
    pin,
    cl.client_id,
    c.car_id,
    mileage
FROM car_service cs
JOIN cars c USING (vin)
JOIN clients cl USING (phone)
JOIN services s USING (service, service_addr)
JOIN workers w ON cs.w_phone = w.phone;

-- Связи таблиц
ALTER TABLE orders
ADD CONSTRAINT fk_service
FOREIGN KEY (service_id) REFERENCES services(service_id),
ADD CONSTRAINT fk_worker
FOREIGN KEY (worker_id) REFERENCES workers(worker_id),
ADD CONSTRAINT fk_client
FOREIGN KEY (client_id) REFERENCES clients(client_id),
ADD CONSTRAINT fk_car
FOREIGN KEY (car_id) REFERENCES cars(car_id);

-- Создание индекса на поле date в таблице orders
CREATE INDEX orders_date_idx ON orders(date);

-- Изменение типа данных поля payment в таблице orders на INTEGER
ALTER TABLE orders
ALTER COLUMN payment TYPE INTEGER USING payment::INTEGER;
