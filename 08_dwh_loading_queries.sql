------------------------------------DWH-------------------------------------
USE DATABASE UDACITY;
USE SCHEMA DWH;

-- create tables
CREATE OR REPLACE TABLE dim_precipitation (
    target_date DATE PRIMARY KEY,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

CREATE OR REPLACE TABLE dim_temperature (
    target_date DATE PRIMARY KEY,
    temp_min FLOAT,
    temp_max FLOAT,
    temp_normal_min FLOAT,
    temp_normal_max FLOAT
); 

CREATE OR REPLACE TABLE dim_business (
    business_id STRING PRIMARY KEY,
    business_name STRING,
    address STRING,
    categories STRING,
    review_count INT
); 

CREATE OR REPLACE TABLE dim_checkin (
    checkin_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    checkin_date STRING
); 

CREATE OR REPLACE TABLE dim_covid (
    business_id STRING PRIMARY KEY,
    highlights STRING,
    delivery_or_takeout STRING,
    grubhub_enabled STRING,
    call_to_action_enabled STRING,
    request_a_quote_enabled STRING,
    covid_banner STRING,
    temporary_closed_until STRING,
    virtual_services_offered STRING
); 

CREATE OR REPLACE TABLE fact_review (
    review_id STRING PRIMARY KEY,
    business_id STRING,
    user_id STRING,
    review_date DATE,
    stars INT,
    cool INT,
    funny INT,
    useful INT
); 

CREATE OR REPLACE TABLE dim_tip (
    tip_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    compliment_count INT,
    tip_date DATE,
    tip_text STRING,
    user_id STRING
); 

CREATE OR REPLACE TABLE dim_user (
    user_id STRING PRIMARY KEY,
    user_name STRING,
    review_count INT
);

-- Foreign key
ALTER TABLE fact_review ADD CONSTRAINT fk_bu_id FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id);
ALTER TABLE fact_review ADD CONSTRAINT fk_co_id FOREIGN KEY(business_id)    REFERENCES  dim_covid(business_id);
ALTER TABLE fact_review ADD CONSTRAINT fk_us_id FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id);
ALTER TABLE fact_review ADD CONSTRAINT fk_te_id FOREIGN KEY(review_date)    REFERENCES  dim_temperature(target_date);
ALTER TABLE fact_review ADD CONSTRAINT fk_pr_id FOREIGN KEY(review_date)    REFERENCES  dim_precipitation(target_date);

-- INSERT DATA FROM ODS TO DWH
USE DATABASE UDACITY;
USE SCHEMA DWH;

TRUNCATE dim_business;
TRUNCATE dim_user;
TRUNCATE dim_tip;
TRUNCATE dim_covid;
TRUNCATE dim_checkin;
TRUNCATE dim_temperature;
TRUNCATE dim_precipitation;
TRUNCATE fact_review;

INSERT INTO dim_business(business_id, business_name, address, categories, review_count) 
SELECT business_id,
    business_name,
    address,
    categories,
    review_count
FROM "UDACITY"."ODS".business;

INSERT INTO dim_user(user_id, user_name, review_count) 
SELECT user_id,
    user_name,
    review_count
FROM "UDACITY"."ODS".user;

INSERT INTO dim_tip(business_id, compliment_count, tip_date, tip_text, user_id) 
SELECT business_id,
    compliment_count,
    tip_date,
    tip_text,
    user_id
FROM "UDACITY"."ODS".tip;

INSERT INTO dim_covid(business_id , highlights , delivery_or_takeout , grubhub_enabled , call_to_action_enabled ,
                  request_a_quote_enabled , covid_banner , temporary_closed_until , virtual_services_offered) 
SELECT 
    business_id,
    highlights,
    delivery_or_takeout ,
    grubhub_enabled ,
    call_to_action_enabled ,
    request_a_quote_enabled ,
    covid_banner ,
    temporary_closed_until ,
    virtual_services_offered
FROM "UDACITY"."ODS".covid;

INSERT INTO dim_checkin(business_id , checkin_date) 
SELECT 
    business_id,
    checkin_date
FROM "UDACITY"."ODS".checkin;

INSERT INTO dim_precipitation(target_date , precipitation , precipitation_normal) 
SELECT target_date,precipitation,precipitation_normal
FROM "UDACITY"."ODS".precipitation;

INSERT INTO dim_temperature(target_date , temp_min , temp_max , temp_normal_min , temp_normal_max) 
SELECT target_date , temp_min , temp_max , temp_normal_min , temp_normal_max 
FROM "UDACITY"."ODS".temperature;

INSERT INTO fact_review(review_id , business_id , user_id , review_date , stars , cool , funny , useful) 
SELECT review_id,
    business_id,
    user_id,
    review_date,
    stars,
    cool,
    funny,
    useful
FROM "UDACITY"."ODS".review;
