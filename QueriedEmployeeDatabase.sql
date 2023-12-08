SELECT * FROM employeeData.employee_education;

/* Total employee count*/
SELECT SUM(EmployeeCount) AS total_employees
FROM employeeData.employee_education;

/* Which roles make the most money */
SELECT JobRole , MAX(MonthlyIncome) AS HighestPaid
FROM employeeData.employee_education
GROUP BY 1
ORDER BY 2 DESC;

/* What are the different educational backgrounds*/
SELECT EducationField, COUNT(EducationField) AS EducationCount
FROM employeeData.employee_education
GROUP BY 1;

/*What are the different departments and their total staff counts*/
SELECT Department, COUNT(Department) AS staffCount
FROM employeeData.employee_education
GROUP BY 1;

/*What percentage of the staff work in each department*/
SELECT DISTINCT e.Department, (t1.populace/ SUM(e.EmployeeCount) * 100) AS percentage_population
FROM (SELECT Department, COUNT(Department) populace
FROM employeeData.employee_education
GROUP BY 1) t1
JOIN employeeData.employee_education e
ON e.Department = t1.Department
GROUP BY 1;

/* How many employees have each level of education (e.g., high school diploma, bachelor's degree, master's degree, etc.)? */
SELECT 
		CASE
			WHEN Education = 1 THEN 'High School Diploma'
			WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
		END AS education_level, 
        COUNT(education) degree_population
FROM employeeData.employee_education e
GROUP BY 1;

/*Is there a correlation between employees' educational backgrounds and the departments they work in?*/
SELECT e.Department, e.EducationField,  t1.education_level
FROM employeeData.employee_education e
JOIN (SELECT Education,
		CASE
			WHEN Education = 1 THEN 'High School Diploma'
			WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level
			FROM employeeData.employee_education e
			GROUP BY 1) t1
ON e.Education = t1.Education;

/*Are certain departments more likely to have employees with higher or lower levels of education?*/
SELECT Department, COUNT(Education) Number_of_higher_education
FROM employeeData.employee_education
WHERE Education > 3
GROUP BY 1;
		
/* What is the average level of education among employees in the company?*/
SELECT  CASE
			WHEN Education = 1 THEN 'High School Diploma'
			WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level,
            AVG(Education) average_education
FROM employeeData.employee_education
GROUP BY 1;

/* How does this vary across different job roles or departments? */
/* Job Roles */
SELECT  JobRole, AVG(Education) average_education
FROM employeeData.employee_education
GROUP BY 1;

/* Departments */
SELECT  Department, AVG(Education) average_education
FROM employeeData.employee_education
GROUP BY 1;

/* Is there a relationship between an employee's level of education and their job position or title? */
SELECT  JobRole, AVG(Education) average_education
FROM employeeData.employee_education
GROUP BY 1
ORDER BY 2 DESC;

/*Do certain positions require or attract employees with specific educational qualifications? */
SELECT JobRole, CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, Education
FROM employeeData.employee_education
ORDER BY 3 DESC;

/* OR */
SELECT JobRole,  CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other' 
			END AS education_level
FROM employeeData.employee_education
GROUP BY 1, 2;

/* How does education level correlate with salary or income? */
SELECT DISTINCT education_level, MonthlyIncome, COUNT(education_level) number_of_occurrences
FROM (SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, MonthlyIncome
FROM employeeData.employee_education
) t1
GROUP BY 1, 2
ORDER BY 3 DESC;


/* Are employees with higher education generally compensated more? */
SELECT DISTINCT education_level, MonthlyIncome, COUNT(education_level) OVER (PARTITION BY MonthlyIncome) number_of_occurrences
FROM (SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, MonthlyIncome
FROM employeeData.employee_education
) t1
GROUP BY 1, 2
ORDER BY 3 DESC;


/* Is there a correlation between an employee's level of education and their likelihood of receiving promotions? */
SELECT DISTINCT education_level, YearsSinceLastPromotion, COUNT(education_level) number_of_occurrences
FROM (SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  -- Add this line to handle unexpected values
			END AS education_level, YearsSinceLastPromotion
FROM employeeData.employee_education
) t1
WHERE YearsSinceLastPromotion > 0
GROUP BY 1, 2
ORDER BY 3 DESC;


/* This shows the educational qualifications that recruitment focuses on when attracting candidates within the last year */
SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, YearsAtCompany, COUNT(Education) number_of_occurrences
	FROM employeeData.employee_education
    WHERE YearsAtCompany < 2
    GROUP BY 1, 2
    ORDER BY 3 DESC; 


/* Are there trends in the educational backgrounds of recently hired employees? */
SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, YearsAtCompany, COUNT(Education) number_of_occurrences
	FROM employeeData.employee_education
    WHERE YearsAtCompany < 5
    GROUP BY 1, 2
    ORDER BY 3 DESC; 

/* Is there a relationship between education levels and employee satisfaction? */
SELECT education_level, JobSatisfaction, SUM(occurrences) occurrences
FROM
(SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, JobSatisfaction , COUNT(*) AS occurrences
FROM employeeData.employee_education
GROUP BY 1, 2) t1
WHERE JobSatisfaction > 2
GROUP BY 1, 2
ORDER BY 3 DESC;



/* Do employees with higher education report higher job satisfaction? */
SELECT education_level, JobSatisfaction, SUM(occurrences) occurrences
FROM
(SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  
			END AS education_level, JobSatisfaction , COUNT(*) AS occurrences
FROM employeeData.employee_education
GROUP BY 1, 2) t1
WHERE JobSatisfaction >= 3
GROUP BY 1, 2
ORDER BY 3 DESC;

/* What ages occur the most in the company */
SELECT Age, HourlyRate, MonthlyIncome, JobRole, JobSatisfaction
FROM employeeData.employee_education;

/* What ages occur the most in the company */
SELECT Age, HourlyRate, COUNT(*) Occurrences
FROM employeeData.employee_education
GROUP BY 1, 2
ORDER BY 3 DESC;

/* What ages make the most hourly in the company */
SELECT Age, HourlyRate, COUNT(*) Occurrences
FROM employeeData.employee_education
GROUP BY 1, 2
ORDER BY 2 DESC;

/* what are the highest age range occurrences within each Department */
SELECT Age, Department, COUNT(*) age_distribution
FROM employeeData.employee_education
GROUP BY 1, 2 
ORDER BY 1, 3 DESC;

/*Altering the table and removing irrelevant columns */
ALTER TABLE employeeData.employee_education
DROP COLUMN StandardHours;

ALTER TABLE employeeData.employee_education
DROP COLUMN Over18;

ALTER TABLE employeeData.employee_education
DROP COLUMN JobInvolvement;

ALTER TABLE employeeData.employee_education
DROP COLUMN EnvironmentSatisfaction;

/* Creating a view  for tableau visualisation*/
Create View educationalPromotions as 
SELECT DISTINCT education_level, YearsSinceLastPromotion, COUNT(education_level) number_of_occurrences
FROM (SELECT CASE 
			WHEN Education = '1' THEN 'High School Diploma'
            WHEN Education = 2 THEN 'Bachelor\'s Degree'
			WHEN Education = 3 THEN 'Master\'s Degree'
			WHEN Education = 4 THEN 'Ph.D.'
			ELSE 'Other'  -- Add this line to handle unexpected values
			END AS education_level, YearsSinceLastPromotion
FROM employeeData.employee_education
) t1
WHERE YearsSinceLastPromotion > 0
GROUP BY 1, 2;
-- ORDER BY 3 DESC;

SELECT * FROM educationalPromotions
ORDER BY 2 DESC;