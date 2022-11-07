-------------------------ods-------------------------------
USE DATABASE UDACITY;
USE SCHEMA ODS;

-- create tables
CREATE OR REPLACE TABLE precipitation (
    target_date DATE PRIMARY KEY,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

CREATE OR REPLACE TABLE temperature (
    target_date DATE PRIMARY KEY,
    temp_min FLOAT,
    temp_max FLOAT,
    temp_normal_min FLOAT,
    temp_normal_max FLOAT
); 

CREATE OR REPLACE TABLE business (
    business_id STRING PRIMARY KEY,
    business_name STRING,
    address STRING,
    categories STRING,
    review_count INT
); 

CREATE OR REPLACE TABLE checkin (
    checkin_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    checkin_date STRING
); 

CREATE OR REPLACE TABLE covid (
    covid_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    highlights STRING,
    delivery_or_takeout STRING,
    grubhub_enabled STRING,
    call_to_action_enabled STRING,
    request_a_quote_enabled STRING,
    covid_banner STRING,
    temporary_closed_until STRING,
    virtual_services_offered STRING
); 

CREATE OR REPLACE TABLE review (
    review_id STRING PRIMARY KEY,
    business_id STRING,
    user_id STRING,
    review_date DATE,
    stars INT,
    cool INT,
    funny INT,
    useful INT
); 

CREATE OR REPLACE TABLE tip (
    tip_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    compliment_count INT,
    tip_date DATE,
    tip_text STRING,
    user_id STRING
); 

CREATE OR REPLACE TABLE user (
    user_id STRING PRIMARY KEY,
    user_name STRING,
    review_count INT
);

-- Foreign key
ALTER TABLE review ADD CONSTRAINT fk_bu_id FOREIGN KEY(business_id)    REFERENCES  business(business_id);
ALTER TABLE review ADD CONSTRAINT fk_us_id FOREIGN KEY(user_id)    REFERENCES  user(user_id);
ALTER TABLE review ADD CONSTRAINT fk_te_id FOREIGN KEY(review_date)    REFERENCES  temperature(target_date);
ALTER TABLE review ADD CONSTRAINT fk_pr_id FOREIGN KEY(review_date)    REFERENCES  precipitation(target_date);
ALTER TABLE checkin ADD CONSTRAINT fk_bu_id FOREIGN KEY(business_id)    REFERENCES  business(business_id);
ALTER TABLE tip ADD CONSTRAINT fk_bu_id FOREIGN KEY(business_id)    REFERENCES  business(business_id);
ALTER TABLE covid ADD CONSTRAINT fk_bu_id FOREIGN KEY(business_id)    REFERENCES  business(business_id);

-- INSERT DATA FROM STAGING TO ODS
USE DATABASE UDACITY;
USE SCHEMA ODS;

TRUNCATE business;
TRUNCATE user;
TRUNCATE tip;
TRUNCATE covid;
TRUNCATE checkin;
TRUNCATE temperature;
TRUNCATE precipitation;
TRUNCATE review;

INSERT INTO business(business_id, business_name, address, categories, review_count) 
SELECT parse_json($1):business_id,
    parse_json($1):name,
    parse_json($1):address,
    parse_json($1):categories,
    parse_json($1):review_count
FROM "UDACITY"."STAGING".business;

INSERT INTO user(user_id, user_name, review_count) 
SELECT parse_json($1):user_id,
    parse_json($1):name,
    parse_json($1):review_count
FROM "UDACITY"."STAGING".user;

INSERT INTO tip(business_id, compliment_count, tip_date, tip_text, user_id) 
SELECT parse_json($1):business_id,
    parse_json($1):compliment_count,
    parse_json($1):date,
    parse_json($1):text,
    parse_json($1):user_id
FROM "UDACITY"."STAGING".tip;

INSERT INTO covid(business_id , highlights , delivery_or_takeout , grubhub_enabled , call_to_action_enabled ,
                  request_a_quote_enabled , covid_banner , temporary_closed_until , virtual_services_offered) 
SELECT 
    parse_json($1):business_id,
    parse_json($1):highlights,
    parse_json($1):"delivery or takeout",
    parse_json($1):"Grubhub enabled",
    parse_json($1):"Call To Action enabled",
    parse_json($1):"Request a Quote Enabled",
    parse_json($1):"Covid Banner",
    parse_json($1):"Temporary Closed Until",
    parse_json($1):"Virtual Services Offered"
FROM "UDACITY"."STAGING".covid;

INSERT INTO checkin(business_id , checkin_date) 
SELECT 
    parse_json($1):business_id,
    parse_json($1):date
FROM "UDACITY"."STAGING".checkin;

INSERT INTO precipitation(target_date , precipitation , precipitation_normal) 
SELECT TO_DATE(date,'YYYYMMDD'),precipitation,precipitation_normal
FROM "UDACITY"."STAGING".precipitation;

INSERT INTO temperature(target_date , temp_min , temp_max , temp_normal_min , temp_normal_max) 
SELECT TO_DATE(date,'YYYYMMDD'), min , max , normal_min , normal_max 
FROM "UDACITY"."STAGING".temperature;

INSERT INTO review(review_id , business_id , user_id , review_date , stars , cool , funny , useful) 
SELECT parse_json($1):review_id,
    parse_json($1):business_id,
    parse_json($1):user_id,
    parse_json($1):date,
    parse_json($1):stars,
    parse_json($1):cool,
    parse_json($1):funny,
    parse_json($1):useful
FROM "UDACITY"."STAGING".review;
