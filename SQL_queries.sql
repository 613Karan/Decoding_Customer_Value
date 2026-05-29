CREATE DATABASE customer_analysis;
USE customer_analysis;
CREATE TABLE customers (
    `Customer ID` INT,
    `Age` INT,
    `Gender` VARCHAR(20),
    `Item Purchased` VARCHAR(50),
    `Category` VARCHAR(20),
    `Purchase Amount (USD)` INT,
    `Location` VARCHAR(50),
    `Size` VARCHAR(5),
    `Color` VARCHAR(20),
    `Season` VARCHAR(10),
    `Review Rating` FLOAT,
    `Subscription Status` INT,
    `Shipping Type` VARCHAR(20),
    `Discount Applied` INT,
    `Promo Code Used` INT,
    `Previous Purchases` INT,
    `Payment Method` VARCHAR(20),
    `Frequency of Purchases` VARCHAR(20),
    `freq_score` INT,
    `loyalty_A` INT,
    `value_tier` INT,
    `satisfaction_flag` INT,
    `sub_conversion_opportunity` INT,
    `discount_dependency` INT
);

USE customer_analysis;
SELECT COUNT(*) FROM customers;

-- ================================================================
-- DECODING CUSTOMER VALUE: SQL SEGMENTATION QUERIES (MySQL)
-- Dataset: shopping_cleaned_engineered.csv (loaded as `customers`)
-- Features used: loyalty_A, value_tier, satisfaction_flag,
--                sub_conversion_opportunity, discount_dependency,
--                freq_score
-- ================================================================


-- ================================================================
-- Q1: WHO ARE THE GENUINELY LOYAL CUSTOMERS VS DISCOUNT-ONLY?
--     What separates high-value from low-value customers, and
--     which profiles show the strongest repeat purchase behavior?
-- ================================================================

-- Q1a: High-value vs Low-value customer profile comparison
SELECT
    value_tier,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating,
    ROUND(AVG(loyalty_A) * 100, 1)                      AS loyalty_A_rate_pct,
    ROUND(AVG(discount_dependency) * 100, 1)            AS discount_dep_rate_pct
FROM customers
GROUP BY value_tier
ORDER BY value_tier DESC;


-- Q1b: Four-quadrant profile — loyalty x value
--      Identifies which combination shows strongest repeat behavior
SELECT
    CASE
        WHEN loyalty_A = 1 AND value_tier = 1 THEN 'Loyal + High Value'
        WHEN loyalty_A = 1 AND value_tier = 0 THEN 'Loyal + Low Value'
        WHEN loyalty_A = 0 AND value_tier = 1 THEN 'Not Loyal + High Value'
        ELSE                                        'Not Loyal + Low Value'
    END                                                 AS profile,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(discount_dependency) * 100, 1)            AS discount_dep_pct
FROM customers
GROUP BY profile
ORDER BY avg_prev_purchases DESC;


-- ================================================================
-- Q2: WHAT BEHAVIORAL PATTERNS TODAY PREDICT HIGH VALUE OVER TIME?
--     Which seasons and categories are associated with lower-tenure
--     customers vs those with high previous purchase counts?
-- ================================================================

-- Q2a: Season x Tenure band
SELECT
    Season,
    CASE
        WHEN `Previous Purchases` <= 10 THEN 'Low Tenure  (<=10)'
        WHEN `Previous Purchases` <= 25 THEN 'Mid Tenure  (11-25)'
        ELSE                                  'High Tenure (>25)'
    END                                                 AS tenure_band,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating
FROM customers
GROUP BY Season, tenure_band
ORDER BY Season, tenure_band;


-- Q2b: Category x Tenure band
SELECT
    Category,
    CASE
        WHEN `Previous Purchases` <= 10 THEN 'Low Tenure  (<=10)'
        WHEN `Previous Purchases` <= 25 THEN 'Mid Tenure  (11-25)'
        ELSE                                  'High Tenure (>25)'
    END                                                 AS tenure_band,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(discount_dependency) * 100, 1)            AS discount_dep_pct
FROM customers
GROUP BY Category, tenure_band
ORDER BY Category, tenure_band;


-- ================================================================
-- Q3: WHICH GEOGRAPHIES AND DEMOGRAPHICS ARE UNDERLEVERED?
--     Which geographies signal organic demand vs discount-driven?
-- ================================================================

-- Q3a: Geography — classified as Organic / Discount-Driven / Mixed
SELECT
    Location,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(discount_dependency) * 100, 1)            AS discount_dep_pct,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    CASE
        WHEN AVG(`Purchase Amount (USD)`) >= 61.0
         AND AVG(`Promo Code Used`) <= 0.40             THEN 'Organic'
        WHEN AVG(`Purchase Amount (USD)`) <  58.0
         AND AVG(`Promo Code Used`) >  0.43             THEN 'Discount-Driven'
        ELSE                                                 'Mixed'
    END                                                 AS demand_type
FROM customers
GROUP BY Location
ORDER BY demand_type, avg_spend DESC;


-- Q3b: Underlevered demographic —
--      Age 36-45, no subscription, high tenure, low promo
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE                             '56-70'
    END                                                 AS age_group,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct,
    ROUND(AVG(sub_conversion_opportunity) * 100, 1)     AS sub_opportunity_rate_pct
FROM customers
GROUP BY age_group
ORDER BY age_group;


-- ================================================================
-- Q4: HOW SHOULD THE BRAND RESTRUCTURE ITS PROMOTIONAL STRATEGY?
-- ================================================================

-- Q4a: Sunset candidates — high tenure + discount dependent
--      Priority order: Clothing > Accessories > Footwear > Outerwear
SELECT
    Category,
    `Frequency of Purchases`,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct
FROM customers
WHERE discount_dependency = 1
  AND `Previous Purchases` >= 25
GROUP BY Category, `Frequency of Purchases`
ORDER BY customer_count DESC;


-- Q4b: Promo firewall segment — high frequency new customers
--      These must NOT be targeted with discounts
SELECT
    Category,
    Season,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating
FROM customers
WHERE freq_score >= 5
  AND `Previous Purchases` <= 10
GROUP BY Category, Season
ORDER BY customer_count DESC;


-- Q4c: Three-way segment comparison for promotional strategy
SELECT
    CASE
        WHEN loyalty_A = 1                          THEN 'Organic Loyal'
        WHEN `Previous Purchases` >= 25
         AND discount_dependency = 1               THEN 'Discount Loyal (Sunset)'
        WHEN freq_score >= 5
         AND `Previous Purchases` <= 10            THEN 'High Freq New (Firewall)'
        ELSE                                            'Other'
    END                                                 AS segment,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct,
    ROUND(SUM(`Purchase Amount (USD)`), 0)              AS total_revenue
FROM customers
GROUP BY segment
ORDER BY avg_spend DESC;


-- ================================================================
-- Q5: WHAT DOES THE BRAND'S IDEAL CUSTOMER PROFILE LOOK LIKE?
-- ================================================================

-- Q5a: Ideal customer — intersection of all positive features
--      loyalty_A=1, value_tier=1, satisfaction_flag=1,
--      discount_dependency=0
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE                             '56-70'
    END                                                 AS age_group,
    Gender,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating,
    ROUND(AVG(`Subscription Status`) * 100, 1)          AS subscription_rate_pct
FROM customers
WHERE loyalty_A = 1
  AND value_tier = 1
  AND satisfaction_flag = 1
  AND discount_dependency = 0
GROUP BY age_group, Gender
ORDER BY customer_count DESC;


-- Q5b: Subscription conversion opportunity — ideal profile to acquire
--      These are the next ideal customers the brand should convert
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE                             '56-70'
    END                                                 AS age_group,
    Gender,
    Category,
    COUNT(*)                                            AS customer_count,
    ROUND(AVG(`Purchase Amount (USD)`), 2)              AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2)                 AS avg_prev_purchases,
    ROUND(AVG(`Promo Code Used`) * 100, 1)              AS promo_rate_pct,
    ROUND(AVG(`Review Rating`), 3)                      AS avg_rating
FROM customers
WHERE sub_conversion_opportunity = 1
GROUP BY age_group, Gender, Category
ORDER BY customer_count DESC
LIMIT 12;

