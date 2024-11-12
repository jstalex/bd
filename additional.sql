-- 1
CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    client_id INTEGER,
    discount_percentage DECIMAL(4, 2),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

INSERT INTO discounts (client_id, discount_percentage)
SELECT
    client_id,
    22.00
FROM
    (
        SELECT client_id, COUNT(order_id) as order_count
        FROM orders
        GROUP BY client_id
        ORDER BY order_count DESC
        LIMIT 22 --  топ 22 клиентов
    );


-- 2
UPDATE workers
SET wages = wages * 1.10
WHERE 
    worker_id 
IN (
    SELECT worker_id
    FROM orders
    GROUP BY worker_id
    ORDER BY COUNT(order_id) DESC
    LIMIT 3
);


-- 3
CREATE VIEW monthly_service_report AS
SELECT 
    s.service,
    s.service_addr,
    COUNT(o.order_id) AS order_count,
    SUM(o.payment) AS income,
    SUM(o.payment) - SUM(w.wages) AS profit
FROM 
    orders o
JOIN 
    services s using(service_id)
JOIN 
    workers w using(worker_id)
WHERE 
    o.date >= (SELECT MAX(date) FROM orders) - INTERVAL '1 month'
    AND o.date < (SELECT MAX(date) FROM orders) and payment is not null 
GROUP BY 
 	s.service, s.service_addr;


-- 4.1
-- Финик оказался самым надежным, а ниссан самым ненадежным)
SELECT
    c.car,
    COUNT(o.car_id) AS repair_count,
    SUM(o.payment) AS total_repair_cost
FROM
    cars c
JOIN
    orders o using(car_id)
WHERE 
    payment IS NOT NULL
GROUP BY
    c.car
ORDER BY
    repair_count ASC, 
    total_repair_cost ASC; 

-- 4.2
SELECT
    c.car,
    COUNT(o.car_id) AS repair_count,
    SUM(o.payment) AS total_repair_cost
FROM
    cars c
JOIN
    orders o using(car_id)
WHERE 
    payment IS NOT NULL
GROUP BY
    c.car
ORDER BY
    repair_count DESC, 
    total_repair_cost DESC; 

-- 5
-- Для джипа и тайоты по 2 цвета самые удачные, не стал выбирать один из них 
WITH ColorOrderCounts AS (
    SELECT
        c.car, 
        c.color,
        COUNT(o.order_id) AS order_count
    FROM
        cars c
    LEFT JOIN
        orders o ON c.car_id = o.car_id
    GROUP BY
        c.car, c.color
),
MinOrderCounts AS (
    SELECT
        car,
        MIN(order_count) AS min_order_count
    FROM
        ColorOrderCounts
    GROUP BY
        car
)
SELECT
    coc.car,
    coc.color,
    coc.order_count
FROM
    ColorOrderCounts coc
JOIN
    MinOrderCounts moc ON coc.car = moc.car AND 
    coc.order_count = moc.min_order_count;
    order by car
