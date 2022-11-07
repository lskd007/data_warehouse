-------------------------STAGING-------------------------------
USE DATABASE UDACITY;
USE SCHEMA STAGING;

-- create tables
CREATE OR REPLACE TABLE precipitation (
    date STRING,
    precipitation STRING,
    precipitation_normal STRING
);

CREATE OR REPLACE TABLE temperature (
    date STRING,
    min STRING,
    max STRING,
    normal_min STRING,
    normal_max STRING
); 

CREATE OR REPLACE TABLE business (
	business_info VARIANT
); 

CREATE OR REPLACE TABLE checkin (
	checkin_info VARIANT
); 

CREATE OR REPLACE TABLE covid (
	covid_info VARIANT
); 

CREATE OR REPLACE TABLE review (
	review_info VARIANT
); 

CREATE OR REPLACE TABLE tip (
	tip_info VARIANT
); 

CREATE OR REPLACE TABLE user (
	user_info VARIANT
); 



-- put file
PUT file://c:\workspace\udacity_data_architect\dwh_project\usw00023169-las_vegas_mccarran_intl_ap-precipitation-inch.csv @%precipitation;
PUT file://c:\workspace\udacity_data_architect\dwh_project\usw00023169-temperature-degreef.csv @%temperature;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_business.json @%business;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_checkin.json @%checkin;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_covid.json @%covid;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_review.json @%review;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_tip.json @%tip;
PUT file://c:\workspace\udacity_data_architect\dwh_project\yelp_academic_dataset_user.json @%user;

-- copy file
COPY INTO precipitation FROM @%precipitation/usw00023169-las_vegas_mccarran_intl_ap-precipitation-inch.csv file_format=(type=csv field_delimiter=',' skip_header=1); 
COPY INTO temperature FROM @%temperature/usw00023169-temperature-degreef.csv file_format=(type=csv field_delimiter=',' skip_header=1); 
COPY INTO business FROM @%business/yelp_academic_dataset_business.json file_format=(type=json); 
COPY INTO checkin FROM @%checkin/yelp_academic_dataset_checkin.json file_format=(type=json); 
COPY INTO covid FROM @%covid/yelp_academic_dataset_covid.json file_format=(type=json); 
COPY INTO review FROM @%review/yelp_academic_dataset_review.json file_format=(type=json); 
COPY INTO tip FROM @%tip/yelp_academic_dataset_tip.json file_format=(type=json); 
COPY INTO user FROM @%user/yelp_academic_dataset_user.json file_format=(type=json); 

-- handle value
UPDATE precipitation SET precipitation = 9999 WHERE precipitation = 't';

