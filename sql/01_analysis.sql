-- NEM price and demand analysis
-- Data: raw.price_demand (AEMO 5-minute price and demand, October 2026)

-- 1. Average, lowest and highest price by state
SELECT region,
       ROUND(AVG(rrp)::numeric, 2) AS avg_price,
       MIN(rrp) AS min_price,
       MAX(rrp) AS max_price
FROM raw.price_demand
GROUP BY region
ORDER BY avg_price DESC;


-- 2. The 10 most expensive 5-minute intervals
SELECT region,
       settlementdate,
       rrp
FROM raw.price_demand
ORDER BY rrp DESC
LIMIT 10;


-- 3. Average NSW demand by hour of the day
SELECT EXTRACT(HOUR FROM settlementdate) AS hour_of_day,
       ROUND(AVG(totaldemand)::numeric, 0) AS avg_demand_mw
FROM raw.price_demand
WHERE region = 'NSW1'
GROUP BY hour_of_day
ORDER BY avg_demand_mw DESC;


-- 4. Negative-price intervals by state (count and percentage)
SELECT region,
       COUNT(*) FILTER (WHERE rrp < 0) AS negative_intervals,
       COUNT(*) AS total_intervals,
       ROUND(100.0 * COUNT(*) FILTER (WHERE rrp < 0) / COUNT(*), 1) AS pct_negative
FROM raw.price_demand
GROUP BY region
ORDER BY pct_negative DESC;


-- 5. Region lookup table (first dimension table), then join to show state names
CREATE TABLE IF NOT EXISTS raw.region (
    region     TEXT PRIMARY KEY,
    state_name TEXT NOT NULL
);

INSERT INTO raw.region (region, state_name) VALUES
    ('NSW1', 'New South Wales'),
    ('QLD1', 'Queensland'),
    ('VIC1', 'Victoria'),
    ('SA1',  'South Australia'),
    ('TAS1', 'Tasmania')
ON CONFLICT (region) DO NOTHING;

SELECT r.state_name,
       ROUND(AVG(p.rrp)::numeric, 2) AS avg_price,
       ROUND(AVG(p.totaldemand)::numeric, 0) AS avg_demand_mw
FROM raw.price_demand p
JOIN raw.region r ON p.region = r.region
GROUP BY r.state_name
ORDER BY avg_price DESC;