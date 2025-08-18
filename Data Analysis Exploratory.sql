# exploratory data analysis project
# creating a copy from the cleaned/cleansed data

CREATE SCHEMA hospital_exploring;

# data exploration

# Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender 
FROM patients
where gender = 'M';

# Show first name and last name of patients who does not have allergies. (null)
SELECT first_name, last_name
FROM patients
where allergies IS NULL;

# Show first name of patients that start with the letter 'C'
SELECT 
	first_name
FROM patients
where first_name like ('c%');

# Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT 
	first_name,
    last_name
FROM patients
where weight between 100 AND 120;


# Update the patients table for the allergies column. If the patient's allergies is null 
# then replace it with 'NKA'
update patients
set allergies = 'NKA'
where allergies IS NULL;

# Show first name and last name concatinated into one column to show their full name.
select
    concat(first_name, ' ', last_name) AS full_name
from patients;

# Show first name, last name, and the full province name of each patient.
# Example: 'Ontario' instead of 'ON'
select 
	p.first_name,
    p.last_name,
    pn.province_name
from patients AS p
join province_names AS pn
	ON p.province_id = pn.province_id;

# Show how many patients have a birth_date with 2010 as the birth year.
select count(*)
from patients
where year(birth_date) = 2010;

# Show the first_name, last_name, and height of the patient with the greatest height.
select
	first_name,
    last_name,
    MAX(height)
from patients;

# Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select
	*
from patients
WHERE patient_id IN (1,45,534,879,1000);

# Show the total number of admissions
select
	count(*)
from admissions;

# Show all the columns from admissions where the patient was admitted and discharged 
# on the same day.
select
	*
from admissions
where admission_date = discharge_date;

# Show the patient id and the total number of admissions for patient_id 579.
select
	patient_id,
    count(*) AS total_admissions
from admissions
where patient_id = 579;

# Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
select distinct
	city
from patients
where province_id = 'NS';

# Write a query to find the first_name, last name and birth date of patients who has 
# height greater than 160 and weight greater than 70
select
	first_name,
    last_name,
    birth_date
from patients
where (height > 160) AND (weight > 70);

# Write a query to find list of patients first_name, last_name, and allergies 
# where allergies are not null and are from the city of 'Hamilton'
select
	first_name,
    last_name,
    allergies
from patients
where (allergies IS NOT NULL) AND (city = 'Hamilton');

# Show unique birth years from patients and order them by ascending.
select distinct YEAR(birth_date)
FROM patients
order by YEAR(birth_date) ASC;


# Show unique first names from the patients table which only occurs once in the list.
# For example, if two or more people are named 'John' in the first_name column 
# then don't include their name in the output list. If only 1 person is named 'Leo' 
# then include them in the output.
SELECT first_name
FROM patients
group by first_name
having COUNT(*) = 1;

# Show patient_id and first_name from patients where their first_name start and ends with 's' 
# and is at least 6 characters long.
SELECT patient_id,first_name
FROM patients
where first_name like 's%____%s';

# Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
# Primary diagnosis is stored in the admissions table.
select 
	p.patient_id,
	p.first_name, 
    p.last_name
from patients AS p
join admissions AS a
	ON p.patient_id = a.patient_id
where a.diagnosis = 'Dementia';


# Display every patient's first_name. Order the list by the length of each name and 
# then by alphabetically.
select first_name
from patients
order by len(first_name), first_name;


# Show the total amount of male patients and the total amount of female patients 
# in the patients table. Display the two results in the same row.
select
	(select count(*) FROM patients where gender = 'M') AS male_count,
	(select count(*) FROM patients where gender = 'F') AS female_count;
    
    
# Show first and last name, allergies from patients which have allergies to either 
#'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then 
# by first_name then by last_name.
select 
	first_name,
    last_name,
    allergies
from patients
where allergies IN ('Penicillin', 'Morphine')
order by allergies, first_name, last_name;

# Show patient_id, diagnosis from admissions. Find patients admitted multiple times 
# for the same diagnosis.
with counting_window AS(
select 
	patient_id,
    diagnosis,
    count(*) OVER(PARTITION BY patient_id, diagnosis) AS counting
from admissions
)
select distinct
	patient_id,
    diagnosis
FROM counting_window
WHERE counting > 1;

# Show the city and the total number of patients in the city.Order from most to least patients 
# and then by city name ascending.
select
	city,
    count(*) AS num_patients
FROM patients
group by city
order by num_patients desc, city;

# Show first name, last name and role of every person that is either patient or doctor.
# The roles are either "Patient" or "Doctor"
select
	first_name,
    last_name,
    'Patient' AS role
FROM patients
union ALL
select
	first_name,
    last_name,
    'Doctor' AS role
FROM doctors;

# Show all allergies ordered by popularity. Remove NULL values from query.
select
	allergies,
    count(*) AS total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
group by allergies
order by total_diagnosis desc;

# Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
# Sort the list starting from the earliest birth_date.
select
	first_name,
    last_name,
    birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
order by birth_date;


# We want to display each patient's full name in a single column. 
# Their last_name in all upper letters must appear first, then first_name in all lower case letters.
# Separate the last_name and first_name with a comma. 
# Order the list by the first_name in decending orderEX: SMITH,jane
select
	concat(upper(last_name), ',', lower(first_name)) AS new_name_format
FROM patients
order by first_name desc;


# Show the province_id(s), sum of height; where the total sum of its patient's 
# height is greater than or equal to 7,000.
select
	province_id, sum(height) AS sum_height
FROM patients
group by province_id
having sum_height > 7000;

# Show the difference between the largest weight and smallest weight for patients 
# with the last name 'Maroni'
select
	(max(weight) - min(weight)) AS  weight_delta
FROM patients
where last_name = 'Maroni';

# Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
# Sort by the day with most admissions to least admissions.
select
	DAY(admission_date) AS day_number, 
    count(*) AS number_of_admissions
FROM admissions
group by day_number
order by number_of_admissions desc;

# Show all columns for patient_id 542's most recent admission_date.
select
	*
FROM admissions
where patient_id = 542
order by admission_date desc
LIMIT 1;


# Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
# 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
# 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
select
	patient_id,
    attending_doctor_id,
    diagnosis
FROM admissions
WHERE (
  		((patient_id % 2 != 0) AND attending_doctor_id IN (1,5,19))
      OR 
  		((attending_doctor_id LIKE '%2%') AND (patient_id LIKE '___'))
      );
      

# Show first_name, last_name, and the total number of admissions attended for each doctor.
# Every admission has been attended by a doctor.
select
	d.first_name,
    d.last_name,
    count(*)
FROM doctors d
JOIN admissions a
	ON d.doctor_id = a.attending_doctor_id
group by d.doctor_id;


# For each doctor, display their id, full name, and the first and last admission date they attended.
select
	d.doctor_id,
	concat(first_name, ' ', last_name) AS full_name,
    MIN(admission_date) AS first_admission_date,
    MAX(admission_date) AS last_admission_date
FROM doctors d
JOIN admissions a
	ON d.doctor_id = a.attending_doctor_id
group by d.doctor_id;

# Display the total amount of patients for each province. Order by descending.
select
	pn.province_name,
    count(*) AS patient_count
FROM patients p
JOIN province_names pn
	ON p.province_id = pn.province_id
group by p.province_id
order by patient_count desc;


# For every admission, display the patient's full name, their admission diagnosis, 
# and their doctor's full name who diagnosed their problem.
select
    concat(p.first_name, ' ', p.last_name) AS patient_name,
    a.diagnosis,
    concat(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients AS p
JOIN admissions AS a
	ON p.patient_id = a.patient_id
JOIN doctors AS d
	ON a.attending_doctor_id = d.doctor_id;
    

# display the first name, last name and number of duplicate patients based on their first name and last name.
# Ex: A patient with an identical name can be considered a duplicate.
SELECT 
	first_name,
    last_name,
    count(*) AS num_of_duplicates
FROM patients
group by first_name, last_name
having num_of_duplicates > 1
order by num_of_duplicates desc;


# Display patient's full name, height in the units feet rounded to 1 decimal,
# weight in the unit pounds rounded to 0 decimals,birth_date,gender non abbreviated.
# Convert CM to feet by dividing by 30.48.
# Convert KG to pounds by multiplying by 2.205.
SELECT 
	CONCAT(first_name, ' ', last_name) AS patient_name,
    round((height / 30.48), 1) AS 'height"feet"',
    round(weight * 2.205) AS 'weight"pounds"',
    birth_date,
    CASE
    	WHEN gender = 'M' THEN 'MALE'
        WHEN gender = 'F' THEN 'FEMALE'
    END AS gender_type
FROM patients;

# Show patient_id, first_name, last_name from patients whose does not have any records 
# in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT 
	p.patient_id,
    p.first_name,
    p.last_name
FROM patients AS P
LEFT JOIN admissions AS a
	ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

# Display a single row with max_visits, min_visits, average_visits where the maximum, 
# minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
WITH aggrag AS (
SELECT *, count(*) AS counting
FROM admissions
group by admission_date
)
select 
	MAX(counting) AS max_visits,
    MIN(counting) AS min_visits,
    ROUND(avg(counting),2) AS average_visits
FROM aggrag;


# Show all of the patients grouped into weight groups. Show the total amount of patients 
# in each weight group. Order the list by the weight group decending.
# For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
select 
	(weight / 10) * 10 AS weight_group,
    count(*) AS patients_in_group
FROM patients
group by weight_group
order by weight_group desc;

# Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1.
# Obese is defined as weight(kg)/(height(m)2) >= 30.
# weight is in units kg. & height is in units cm.
select 
	patient_id,
    weight,
    height,
    case
    	WHEN (weight / power((height / 10.0),2) * 100) >= 30 THEN 1
        ELSE  0
    END AS isObese
FROM patients;


# Show patient_id, first_name, last_name, and attending doctor's specialty.
# Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa' 
# Check patients, admissions, and doctors tables for required information.
select 
	p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM patients AS p
join admissions AS a
	ON p.patient_id = a.patient_id
JOIN doctors AS d
	ON a.attending_doctor_id = d.doctor_id
WHERE (a.diagnosis = 'Epilepsy') AND (d.first_name = 'Lisa');


# All patients who have gone through admissions, can see their medical documents on our site. 
# Those patients are given a temporary password after their first admission. 
# Show the patient_id and temp_password. The password must be the following, in order:
# 1. patient_id
# 2. the numerical length of patient's last_name
# 3. year of patient's birth_date
select distinct
	a.patient_id,
    concat(a.patient_id, len(p.last_name), year(p.birth_date))
FROM patients AS p
join admissions AS a
	ON p.patient_id = a.patient_id;
    

# Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
# All patients with an even patient_id have insurance.
# Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
# Add up the admission_total cost for each has_insurance group.
WITH patient_insurance AS (
select
    case
    	WHEN (patient_id % 2 = 0) THEN 'Yes'
        ELSE 'No'
    END AS has_insurance,
    count(*) AS counting
FROM admissions
group by has_insurance
)
select
	has_insurance,
	CASE
    	WHEN (has_insurance = 'Yes') THEN (counting * 10)
        ELSE (counting * 50)
	END AS cost_after_insurance
FROM patient_insurance;


# Show the provinces that has more patients identified as 'M' than 'F'. 
# Must only show full province_name
WITH male_province_count AS(
select
	gender,
	pn.province_name,
    count(*) AS counting
from patients AS p
JOIN province_names AS pn
	ON p.province_id = pn.province_id
WHERE gender = 'M'
group by pn.province_name, gender
),
female_province_count AS (
select
	gender,
	pn.province_name,
    count(*) AS counting
from patients AS p
JOIN province_names AS pn
	ON p.province_id = pn.province_id
WHERE gender = 'F'
group by pn.province_name, gender
)
select m.province_name
from male_province_count AS m
JOIN female_province_count AS f
	ON m.province_name = f.province_name
WHERE m.counting > f.counting;

# We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
# - First_name contains an 'r' after the first two letters.
# - Identifies their gender as 'F'
# - Born in February, May, or December
# - Their weight would be between 60kg and 80kg
# - Their patient_id is an odd number
# - They are from the city 'Kingston'
select *
FROM patients
WHERE
	first_name LIKE '__r%'
    AND gender = 'F'
    AND month(birth_date) IN (2,5,12)
    AND weight BETWEEN 60 AND 80
    AND patient_id % 2 != 0
    AND city = 'Kingston';
    

# Show the percent of patients that have 'M' as their gender. Round the answer 
# to the nearest hundreth number and in percent form.
select distinct
	CONCAT(round((
      (((select count(*) FROM patients WHERE gender = 'M')/0.1)*10) 
      / count(*)
    ), 2), '%')
    AS percent_of_male_patients 
FROM patients;


# For each day display the total amount of admissions on that day. Display the amount 
# changed from the previous date.
WITH counting_cte AS (
select
	admission_date,
    count(*) AS admission_day
FROM admissions
group by admission_date
),
counting_cte_2 AS (
select *,
	LAG(admission_day, 1, NULL) OVER() AS lagged_admission_day
FROM counting_cte
)
select
	admission_date,
	admission_day,
    (admission_day - lagged_admission_day) AS admission_count_change
FROM counting_cte_2;


# Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
WITH province_cte AS (
select
	province_name,
	CASE 
    	WHEN province_name = 'Ontario' THEN 1
        ELSE 0
    END AS counting
FROm province_names
order by counting desc
)
select
	province_name
FROM province_cte;


# We need a breakdown for the total amount of admissions each doctor has started each year. 
# Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
select 
	d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialty,
    year(admission_date) AS selected_year,
    Count(*) AS counting
FROM admissions AS a
JOIN doctors AS d
	ON a.attending_doctor_id = d.doctor_id
group by d.doctor_id, selected_year;

















