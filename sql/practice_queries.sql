
-- ============================================
-- SQL & Math Practice
-- Database: MySQL
-- ============================================


-- 1. Age of the youngest student

SELECT TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS year
FROM Student
WHERE birthday = (
    SELECT MAX(birthday)
    FROM Student
);


-- 2. Percentage of students born in 2000

SELECT FLOOR(
    SUM(YEAR(birthday) = 2000) * 100.0 / COUNT(*)
) AS percent
FROM Student;


-- 3. Flights departing between 10:00 and 14:00
-- on January 1, 1900

SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01 10:00:00'
                   AND '1900-01-01 14:00:00';


-- 4. Move all class times forward by 30 minutes
-- Check your actual table and column names first.
-- Run only once to avoid adding another 30 minutes.

-- UPDATE Timepair
-- SET start_pair = ADDTIME(start_pair, '00:30:00'),
--     end_pair = ADDTIME(end_pair, '00:30:00');


-- 5. Delete family members whose names end in Quincey

DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey';


-- 6. Average delivery time by city
-- Delivery time is measured in minutes.

SELECT
    c.city_name,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                o.order_placed,
                o.order_delivered
            )
        ),
        2
    ) AS avg_minutes
FROM orders AS o
JOIN restaurants AS r
    ON o.restaurant_id = r.restaurant_id
JOIN cities AS c
    ON c.city_id = r.city_id
GROUP BY c.city_name
ORDER BY avg_minutes ASC;


-- 7. Last tenant of each rented room

SELECT
    r.room_id AS room_id,
    u.name,
    r.end_date
FROM Reservations AS r
JOIN Users AS u
    ON u.id = r.user_id
JOIN (
    SELECT
        room_id,
        MAX(end_date) AS last_date
    FROM Reservations
    GROUP BY room_id
) AS latest
    ON r.room_id = latest.room_id
   AND r.end_date = latest.last_date;
