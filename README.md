# Healthcare Analysis SQL Portfolio Project

## Project Overview

**Project Title**: Healthcare Analytics-OCD Diagnosis Analysis  
**Database**: `healthcare_database`
**Tables**: `ocd_patient_data` and `ocd_patient_healthcare`

This project analyzes the relationship between OCD diagnoses and depression/anxiety based on various factors like family history of OCD, ethnicity, gender, and more. It includes calculations such as the total number of diagnosed individuals, percentage breakdowns, and averages of key scores related to OCD and depression, along with exploratory data analysis (EDA). After the analysis, data visualization and dashboard development was using Power BI. The dataset used in this analysis was collected from a YouTube channel of Stacey Samoe. 

## Objectives

1. **Set up healthcare database**: Ensure your database is configured correctly and the `ocd_patient_data` table is populated with relevant data (patient IDs, diagnosis information, etc.).
2. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
3. **Healthcare Analysis**: Utilize SQL to address key questions and extract insights from the healthcare data.

## Features

- Calculate the total number of people diagnosed with OCD and depression.
- Compute the percentage of individuals diagnosed with depression and anxiety, categorized by family history of OCD.
- Identify the most common type of obsession and calculate the average obsession score.
- Calculate the gender ratio and gender percentage for OCD diagnoses.
- Calculate the average obsession and compulsion score by gender.
- Track OCD diagnoses and other related metrics on a month-over-month (MoM) basis.

## Project Structure

### 1. Database setup and table creation

- **Database Creation**: Create database named `healthcare_database`.
- **Table Creation**: Table `ocd_patient_healthcare` is created by importing the csv file. The `ocd_patient_healthcare` table structure includes Patient ID, Patient Age, Gender, Patient Ethnicity, Marital Status, Education Level, OCD Diagnosis Date, Duration of Symptoms (months), Previous Diagnoses, Family History of OCD, Obsession Type, Compulsion Type, Y-BOCS Score (Obsessions), Y-BOCS Score (Compulsions), Depression Diagnosis, Anxiety Diagnosis, Medications.
Later, create stage table `ocd_patient_data` and use for further analysis.

```sql
CREATE DATABASE healthcare_database
USE healthcare_database;

SELECT COUNT(*)
FROM ocd_patient_healthcare;

CREATE TABLE ocd_patient_data LIKE ocd_patient_healthcare; 
INSERT INTO ocd_patient_data SELECT * FROM ocd_patient_healthcare;
```

### 2. Exploratory Data Analysis (EDA)
```sql
SELECT *
FROM ocd_patient_data;

SELECT COUNT(*)
FROM ocd_patient_data;

-- Total Number of People Diagnosed with Depression

SELECT COUNT(`Patient ID`) AS depression_patient_count
FROM ocd_patient_data
WHERE `Depression Diagnosis` = 'Yes'
;

-- Total Number of People Diagnosed with Anxiety

SELECT COUNT(`Patient ID`) AS anxiety_patient_count
FROM ocd_patient_data
WHERE `Anxiety Diagnosis` = 'Yes'
;
```

### 3. Healthcare Analysis using SQL to address key questions and extract insights from the healthcare data.

1. **Calculate the total number of OCD cases and determine the gender ratio and gender percentages.**:
```sql
SELECT COUNT(`Patient ID`) as total_ocd
     , COUNT(CASE gender WHEN 'Male' THEN 1 END) AS male_count
     , COUNT(CASE gender WHEN 'Female' THEN 1 END) AS female_count
  -- Calculate percentage of male patients with OCD diagnosis
     , ROUND((SUM(CASE gender WHEN 'Male' THEN 1 END)/COUNT(*)*100),2) AS male_percent
  -- Calculate percentage of female patients with OCD diagnosis
     , ROUND((SUM(CASE gender WHEN 'Female' THEN 1 END)/COUNT(*)*100),2) AS female_percent
FROM ocd_patient_healthcare
;
```

2. **Compute the average obsession score by gender.**:
```sql
SELECT gender
     , COUNT(`Patient ID`) total_ocd
     , ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) avg_obsession_score
FROM ocd_patient_healthcare
GROUP BY 1
;
```

3. **Calculate the average scores for obsession and compulsion by ethnicity.**:
```sql
SELECT ethnicity
     , COUNT(`Patient ID`) ethnicity_count
     , ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) avg_obsession_score
     , ROUND(AVG(`Y-BOCS Score (Compulsions)`),2) avg_compulsion_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 1
;
```

4. **Calculate the total number of people diagnosed with OCD month-over-month (MoM).**:
```sql
-- To proceed with the calculation, let's convert the 'OCD Diagnosis Date' column from text to a date format.

ALTER TABLE ocd_patient_dataset
MODIFY `OCD Diagnosis Date` DATE
;

-- Query:

SELECT date_format(`OCD Diagnosis Date`, '%Y-%m') AS OCD_diagnosis_date
     , COUNT(`Patient ID`) patient_count
FROM ocd_patient_data
GROUP BY 1
ORDER BY 1
;
```

5. **Identify the most common type of obsession and its corresponding average obsession score.**:
```sql
SELECT `Obsession Type`
     , ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) avg_obsession_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;
```

6. **Identify the most common type of compulsion and its corresponding average compulsion score.**:
```sql
SELECT `Compulsion Type`
     , ROUND(AVG(`Y-BOCS Score (Compulsions)`), 2) avg_complusion_score
FROM ocd_patient_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;
```

7. **Calculate the total number of people diagnosed with depression and the depression percentage, categorized by family history of OCD.**:
```sql
SELECT `Family History of OCD`
     , COUNT(CASE WHEN `Depression Diagnosis` = 'Yes' THEN `Patient ID` END) AS depression_patient_count_yes
     , COUNT(CASE WHEN `Depression Diagnosis` = 'No' THEN `Patient ID` END) AS depression_patient_count_no
  -- Calculate total patients in each group
     , COUNT(`Patient ID`) AS total_patient_count
  -- Calculate percentage of patients with depression diagnosis
     , ROUND(100 * COUNT(CASE WHEN `Depression Diagnosis` = 'Yes' THEN `Patient ID` END) / COUNT(`Patient ID`), 2) AS depression_percentage
FROM ocd_patient_data
GROUP BY 1
;
```

8. **Calculate the total number of people diagnosed with anxiety and the anxiety percentage, categorized by family history of OCD.**:
```sql
SELECT `Family History of OCD`
     , COUNT(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN `Patient ID` END) AS anxiety_patient_count_yes
     , COUNT(CASE WHEN `Anxiety Diagnosis` = 'No' THEN `Patient ID` END) AS anxiety_patient_count_no
    -- Calculate total patients in each group
     , COUNT(`Patient ID`) AS total_patient_count,
    -- Calculate percentage of patients with anxiety diagnosis
     , ROUND(100 * COUNT(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN `Patient ID` END) / COUNT(`Patient ID`), 2) AS anxiety_percentage
FROM ocd_patient_data
GROUP BY 1
;
```

## Findings

- **Gender Distribution of OCD Diagnoses** The gender ratio suggests that males are more likely to be diagnosed with OCD.
- **Common Obsession Type** The most common obsession among patients is Harm-Related, which appears most frequently in the data. On average, patients with Hoarding have a higher obsession score, indicating this type may be associated with more intense symptoms.
- **Common Compulsion Type** The most common compulsion among patients is Washing, which appears most frequently in the data. On average, patients with Praying have a higher compulsion score, indicating this type may be associated with more intense symptoms.

## Summary

The analysis reveals some key trends, including:

- A strong link between having a family history of OCD and higher rates of anxiety and depression.
- Gender and family history play important roles in how common OCD and related conditions are.
- Anxiety often appears alongside OCD, showing a common overlap.

These insights point to areas where further research could be valuable, like focusing on higher-risk groups, such as people with a family history of OCD, or understanding specific obsession types that are more common in certain populations.

## Data Visualization and dashboard creation with Power BI

The CSV file containing the insights was then imported into Power BI. Power BI's functionalities were used to created clear and informative visualizations that effectively communicated the OCD patient data insights. I concluded the project with the creation of comprehensive Power BI dashboard. This interactive dashboard serves as a centralized platform for exploring and analyzing the key OCD patient metrics.

## Conclusion

The analysis shows some key patterns in the data. Both gender and family history play a big role in how common OCD and related conditions are. These findings highlight the need to focus on high-risk groups, like those with a family history of OCD, to better personalize treatment and improve outcomes for patients.

## Author - Neelam Chaudhari

This project is part of my SQL portfolio.

### Links

- **LinkedIn**: (https://www.linkedin.com/in/neelamrc)
- **Tableau**: (https://public.tableau.com/app/profile/neelamrc)

Thank you!

