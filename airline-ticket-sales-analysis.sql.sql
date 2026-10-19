-- ============================================================
-- AIRLINE TICKET SALES & REVENUE ANALYSIS
-- Exploratory Analysis
-- ============================================================


-------- 1. Check whether all tickets are linked to a booking
-- Purpose: Verify data relationships between tickets and bookings.

SELECT
    t.id AS ticket_id,
    t.booking_id
FROM tickets t
LEFT JOIN bookings b
    ON t.booking_id = b.id
WHERE b.id IS NULL;
  
--This query checks whether any ticket is missing a corresponding booking. 
--An empty result indicates that all tickets are successfully linked to bookings.


--------- 2. Initial monthly ticket sales analysis
-- Purpose: Explore how ticket sales changed over time.

SELECT
    DATE_TRUNC('month', b.booking_date)::date AS reservation_month,
    COUNT(DISTINCT t.ticket_number) AS tickets_sold,
    SUM(t.total_price) AS ticket_sales_value
FROM bookings b
JOIN tickets t
    ON b.id = t.booking_id
GROUP BY DATE_TRUNC('month', b.booking_date)::date
ORDER BY reservation_month;
 
--This query shows the number of tickets sold and total ticket sales value by month. 
--It was used to identify sales patterns and periods with higher or lower sales activity.


---------- 3. Number of bookings by year
-- Purpose: Compare the number of reservations across years.

SELECT
    EXTRACT(YEAR FROM b.booking_date) AS reservation_year,
    COUNT(DISTINCT b.booking_reference) AS reservations_sold
FROM bookings b
GROUP BY reservation_year
ORDER BY reservation_year;


--This query calculates the number of unique bookings for each year and provides an initial view of annual booking activity.

---------- 4. Annual bookings, tickets and sales value
-- Purpose: Compare bookings, tickets sold and sales value by year.

SELECT
    EXTRACT(YEAR FROM b.booking_date) AS reservation_year,
    COUNT(DISTINCT b.booking_reference) AS reservations_sold,
    COUNT(DISTINCT t.ticket_number) AS tickets_sold,
    SUM(t.total_price) AS ticket_sales_value
FROM bookings b
JOIN tickets t
    ON b.id = t.booking_id
GROUP BY reservation_year
ORDER BY reservation_year;

--This query combines three key sales measures: number of bookings, number of tickets sold and total ticket sales value. 
--It helps provide a broader view of annual sales performance.


----------- 5. Check data coverage by year
-- Purpose: Understand which months are actually available in the dataset.

SELECT
    EXTRACT(YEAR FROM b.booking_date) AS reservation_year,
    MIN(b.booking_date) AS first_booking,
    MAX(b.booking_date) AS last_booking,
    COUNT(DISTINCT DATE_TRUNC('month', b.booking_date)) AS months_with_bookings
FROM bookings b
GROUP BY reservation_year
ORDER BY reservation_year;

--This query checks the time coverage of the dataset. 
--The results show that some years contain only part of the year, so annual comparisons should be interpreted with caution.

------------ 6. Number of bookings by month
-- Purpose: Identify months with the highest and lowest booking activity.

SELECT
    DATE_TRUNC('month', b.booking_date) AS reservation_month,
    COUNT(DISTINCT b.booking_reference) AS booking_count
FROM bookings b
GROUP BY reservation_month
ORDER BY reservation_month;

--This query shows monthly booking volume and helps identify periods with higher or lower reservation activity.


------------ 7. Monthly payment analysis
-- Purpose: Explore payment volume and payment value over time.

SELECT
    DATE_TRUNC('month', p.payment_date)::date AS payment_month,
    COUNT(p.id) AS payment_count,
    SUM(p.amount) AS total_payment_amount
FROM payments p
GROUP BY DATE_TRUNC('month', p.payment_date)::date
ORDER BY payment_month;

--This query shows the number and total value of payments made each month.
--It provides a supporting view of payment activity over time.


------------ 8. Calculate total ticket value per booking
-- Purpose: Calculate the total value of tickets associated with each booking.

SELECT
    booking_id,
    SUM(total_price) AS ticket_total
FROM tickets
GROUP BY booking_id
ORDER BY booking_id;

--This query calculates the total ticket value for each booking. 
--It is needed because one booking can contain multiple tickets.


------------ 9. Calculate total payment value per booking
-- Purpose: Calculate the total amount paid for each booking.

SELECT
    booking_id,
    SUM(amount) AS payment_total
FROM payments
GROUP BY booking_id
ORDER BY booking_id;

--This query calculates the total payment amount associated with each booking.

------------ 10. Compare ticket value with payment value per booking
-- Purpose: Compare the total ticket value with the total amount paid.

WITH ticket_totals AS (
    SELECT
        booking_id,
        SUM(total_price) AS ticket_total
    FROM tickets
    GROUP BY booking_id
),
payment_totals AS (
    SELECT
        booking_id,
        SUM(amount) AS payment_total
    FROM payments
    GROUP BY booking_id
)
SELECT
    tt.booking_id,
    tt.ticket_total,
    pt.payment_total
FROM ticket_totals tt
JOIN payment_totals pt
    ON tt.booking_id = pt.booking_id
ORDER BY tt.booking_id;


--This query compares ticket value with payment value for each booking. 
--Separate aggregations are used before joining the tables to avoid duplicated values caused by multiple tickets and multiple payments within the same booking.


------------- 11. Descriptive statistics for fares
-- Purpose: Understand the overall distribution of ticket fares.

SELECT
    MIN(fare) AS min_fare,
    MAX(fare) AS max_fare,
    COUNT(*) AS fare_records,
    AVG(fare) AS avg_fare,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY fare) AS median_fare
FROM ticket_flights;

--This query provides basic descriptive statistics for fares. 
--The difference between the average and median fare helps identify whether the fare distribution is influenced by higher-priced tickets.


-- ============================================================
-- FINAL BUSINESS ANALYSIS
-- ============================================================


------------- 12. Monthly ticket sales
-- Business question:
-- How did ticket sales change over time?

SELECT
    DATE_TRUNC('month', b.booking_date)::date AS reservation_month,
    COUNT(DISTINCT t.ticket_number) AS tickets_sold,
    SUM(t.total_price) AS ticket_sales_value
FROM bookings b
JOIN tickets t
    ON b.id = t.booking_id
GROUP BY DATE_TRUNC('month', b.booking_date)::date
ORDER BY reservation_month;

--This analysis shows monthly ticket sales volume and sales value. 
--It helps identify periods with higher or lower sales activity over the available dataset period.

-- 13. Ticket and fare analysis by cabin class
-- Business questions:
-- How many unique tickets are associated with each cabin class?
-- How does the average fare and total fare value differ by cabin class?

SELECT
    c.name AS cabin_class,
    COUNT(DISTINCT t.id) AS unique_tickets,
    COUNT(tf.id) AS ticket_flight_records,
    AVG(tf.fare) AS avg_fare,
    SUM(tf.fare) AS total_fare_value
FROM cabins c
JOIN ticket_flights tf
    ON c.id = tf.cabin_id
JOIN tickets t
    ON tf.ticket_id = t.id
GROUP BY c.id, c.name
ORDER BY total_fare_value DESC;

--This analysis combines cabin, ticket-flight and ticket data to compare ticket volume and fare performance across cabin classes. 
--It calculates the number of unique tickets, the number of ticket-flight records, the average fare and the total fare value for each cabin class.


-- ------------ 14. Booking payment and promotion analysis
-- Business question:
-- How do promotional discounts affect the amount paid compared with the total ticket value?

WITH ticket_totals AS (
SELECT
booking_id,
SUM(total_price) AS ticket_total
FROM tickets
GROUP BY booking_id
),
payment_totals AS (
SELECT
booking_id,
SUM(amount) AS payment_total
FROM payments
GROUP BY booking_id
)
SELECT
tt.booking_id,
tt.ticket_total,
pt.payment_total,
p.id AS promotion_id,
p.code AS promotion_code,
p.discount_percentage
FROM ticket_totals tt
JOIN payment_totals pt
ON tt.booking_id = pt.booking_id
JOIN bookings b
ON b.id = tt.booking_id
JOIN promotions p
ON p.id = b.promotion_id
ORDER BY tt.booking_id;

-- This analysis combines booking payment information with promotion data.
-- It shows the total ticket value, amount paid, promotion code,
-- and discount percentage for each booking.

