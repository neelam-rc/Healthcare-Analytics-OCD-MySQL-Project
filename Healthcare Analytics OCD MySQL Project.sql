
-- Project Title: Healthcare Analytics-OCD Diagnosis Analysis 

USE healthcare;

SELECT COUNT(*)
FROM ocd_patient_healthcare;

CREATE TABLE ocd_patient_data LIKE ocd_patient_healthcare; 
INSERT INTO ocd_patient_data SELECT * FROM ocd_patient_healthcare;

SELECT *
FROM ocd_patient_data;

-- Calculate the total number of OCD cases and determine the gender ratio and gender percentages.

SELECT COUNT(`Patient ID`) as total_ocd
     , COUNT(CASE gender WHEN 'Male' THEN 1 END) AS male_count
     , COUNT(CASE gender WHEN 'Female' THEN 1 END) AS female_count
	-- Calculate percentage of male patients with OCD diagnosis
     , ROUND((SUM(CASE gender WHEN 'Male' THEN 1 END)/COUNT(*)*100),2) AS male_percent
     -- Calculate percentage of female patients with OCD diagnosis
     , ROUND((SUM(CASE gender WHEN 'Female' THEN 1 END)/COUNT(*)*100),2) AS female_percent
FROM ocd_patient_healthcare
;

-- Compute the average obsession score by gender.

SELECT gender
  , COUNT(`Patient ID`) total_ocd
  , ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) avg_obsession_score
FROM ocd_patient_healthcare
GROUP BY 1
;

-- Calculate the average scores for obsession and compulsion by ethnicity.

SELECT ethnicity
     , COUNT(`Patient ID`) ethnicity_count
     , ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) avg_obsession_score
     , ROUND(AVG(`Y-BOCS Score (Compulsions)`),2) avg_compulsion_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 1
;

-- To proceed with the calculation, let's convert the 'OCD Diagnosis Date' column from text to a date format.

ALTER TABLE ocd_patient_dataset
MODIFY `OCD Diagnosis Date` DATE
;

-- Calculate the total number of people diagnosed with OCD month-over-month (MoM).

SELECT date_format(`OCD Diagnosis Date`, '%Y-%m') AS OCD_diagnosis_date
	 , COUNT(`Patient ID`) patient_count
FROM ocd_patient_data
GROUP BY 1
ORDER BY 1
;

-- Identify the most common type of obsession and its corresponding average obsession score.

SELECT `Obsession Type`
	 , ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) avg_obsession_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;

-- Identify the most common type of compulsion and its corresponding average compulsion score.

SELECT `Compulsion Type`
      , ROUND(AVG(`Y-BOCS Score (Compulsions)`), 2) avg_complusion_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;

-- Calculate the total number of people diagnosed with depression and the depression percentage, categorized by family history of OCD.

SELECT `Family History of OCD`
     , COUNT(CASE WHEN `Depression Diagnosis` = 'Yes' THEN `Patient ID` END) AS depression_patient_count_yes,
       COUNT(CASE WHEN `Depression Diagnosis` = 'No' THEN `Patient ID` END) AS depression_patient_count_no,
    -- Calculate total patients in each group
    COUNT(`Patient ID`) AS total_patient_count,
    -- Calculate percentage of patients with depression diagnosis
    ROUND(100 * COUNT(CASE WHEN `Depression Diagnosis` = 'Yes' THEN `Patient ID` END) / COUNT(`Patient ID`), 2) AS depression_percentage
FROM ocd_patient_data
GROUP BY 1
;

-- Calculate the total number of people diagnosed with anxiety and the anxiety percentage, categorized by family history of OCD.

SELECT `Family History of OCD`
     , COUNT(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN `Patient ID` END) AS anxiety_patient_count_yes
     , COUNT(CASE WHEN `Anxiety Diagnosis` = 'No' THEN `Patient ID` END) AS anxiety_patient_count_no,
    -- Calculate total patients in each group
    COUNT(`Patient ID`) AS total_patient_count,
    -- Calculate percentage of patients with anxiety diagnosis
    ROUND(100 * COUNT(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN `Patient ID` END) / COUNT(`Patient ID`), 2) AS anxiety_percentage
FROM ocd_patient_data
GROUP BY 1
;

-- The End
-- Thank You!
