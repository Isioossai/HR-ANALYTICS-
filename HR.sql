SELECT * FROM Human_Resources

CREATE TABLE Human_Resoruces(id Text, 
							 first_name Varchar,
							last_name Varchar,
							birthdate Date,
							gender Varchar,
							race varchar,
							department Varchar,
							jobtitle Varchar,
							location varchar,
							hire_date Date,
							termdate Date,
							loaction_city Varchar,
							location_state Varchar);
							

SELECT * FROM Human_Resoruces

ALTER TABLE Human_Resoruces 
RENAME TO Human_Resources

SELECT * FROM Human_Resources
-- CLEAN DATASET
--add age column
ALTER TABLE Human_Resources
ADD COLUMN age Integer;

UPDATE Human_Resources
SET age = DATE_PART('YEAR', CURRENT_DATE) - DATE_PART('YEAR', birthdate);

-- min age and max age
SELECT min(age), max(age) FROM Human_Resources

-- what is the gender breakdown of employees in the company

SELECT * FROM Human_Resources

SELECT gender, COUNT(*) AS total_gender_count
FROM Human_Resources
WHERE termdate IS Null
GROUP BY gender;

-- what is the race breakdown of employees in the company
SELECT race, COUNT(*) AS total_race_count
FROM Human_Resources
WHERE termdate IS Null
GROUP BY race;

-- what is the age distribution of employees in the company
SELECT
CASE
WHEN age>=18 AND age<=24 THEN '18-24'
WHEN age>=25 AND age<=34 THEN '25-34'
WHEN age>=35 AND age<=44 THEN '35-44'
WHEN age>=45 AND age<=54 THEN '45-54'
WHEN age>=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group,
COUNT(*) AS age_group_count
FROM Human_Resources
WHERE termdate IS Null
GROUP BY age_group
ORDER BY age_group;

-- How many employees work at HQ vs Remote
SELECT * FROM Human_Resources
SELECT location,COUNT(*) AS location_count
FROM Human_Resources
WHERE termdate IS Null
GROUP BY location;

/*-- What is the average length of employment who have been terminated
SELECT ROUND(AVG(year(termdate)-year(hire_date)),0) AS length_of_emp
FROM Human_Resources
WHERE termdate IS NOT Null */

-- How does the gender distribution vary across dept. 
SELECT department, gender,COUNT(*) AS count
FROM Human_Resources
WHERE termdate IS NOT Null
GROUP BY department, gender
ORDER BY department, gender

-- What is the distribution of jobtitles accross the company
SELECT jobtitle,COUNT(*) AS jobtitle_count
FROM Human_Resources
WHERE termdate IS NULL
GROUP BY jobtitle

--which dept has the higher turnover/termination rate
SELECT department,
COUNT(*) AS total_count,
COUNT ( CASE
	  WHEN termdate IS NOT Null AND termdate <=CURRENT_DATE() THEN 1
	  END) AS terminated_count,
	  ROUND((COUNT ( CASE
				   WHEN termdate IS NOT Null AND termdate <= CURRENT_DATE() THEN 1
				   END)/COUNT(*))*100,2) AS termination_rate
FROM Human_Resources
GROUP BY department
ORDER BY terminate_rate DESC

--WHat is the distribution of employees across location state
SELECT * FROM Human_Resources

SELECT location_state, COUNT(*) AS count
FROM Human_Resources
WHERE termdate IS NUll
GROUP BY location_state

SELECT loaction_city, COUNT(*) AS count
FROM Human_Resources
WHERE termdate IS NUll
GROUP BY loaction_city

--How has the companys employee count changed over time based on hire and termination date

SELECT YEAR(hire_date) AS year,
COUNT(*) AS hires,
SUM(CASE
   WHEN termdate IS NOT NULL AND termdate <= current_date() THEN 1 END) AS terminations
FROM Human_Resources
GROUP BY YEAR(hire_date)) AS subquery
GROUP BY year
ORDER BY year;

SELECT hire_date AS hires, COUNT(DISTINCT id) AS Employee
FROM Human_Resources
GROUP BY hire_date

--what is the tenure distribution for each department
SELECT department, round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM Human_Resources
WHERE termdate IS NOT Null AND termdate<= current_date
GROUP BY department

SELECT * FROM Human_Resources
SELECT SUM(Male)