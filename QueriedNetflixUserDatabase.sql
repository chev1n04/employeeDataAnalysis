SELECT * FROM user_data.netflix_database;


SELECT COUNT(*) FROM user_data.netflix_database;

-- To find the distribution of users based on demographics such as age, gender, and location--
/* Starting off with the distribution of users in each country */
SELECT Country , COUNT(Country) no_of_users
 FROM user_data.netflix_database
 GROUP BY 1;

/* Finding the distribution of users in each Age range */
/* SELECT Age, COUNT(Age) age_distribution
FROM user_data.netflix_database
GROUP BY 1
ORDER BY 1; */ 

SELECT
 CONCAT(FLOOR(Age / 5) * 5, ' - ', FLOOR(Age / 5) * 5 + 4, ' years') age_range, 
 COUNT(*) age_distribution 
 FROM user_data.netflix_database
 GROUP BY 1
 ORDER BY 1;
 
 /* Finding the distribution of users in each gender */
 SELECT  Gender, COUNT(*) gender_distribution 
 FROM user_data.netflix_database
 GROUP BY 1; 
 
 
-- How has the user base evolved over time in terms of demographics? --
/* First we have to work on the date columns */
ALTER TABLE user_data.netflix_database
MODIFY COLUMN join_date DATE;

ALTER TABLE user_data.netflix_database
MODIFY COLUMN last_payment DATE;

/* How has the user base evolved over time in terms of demographics?*/
SELECT *
 FROM user_data.netflix_database
 ORDER BY join_date;
 
 /* What days did specific age ranges sign up the most */
 SELECT  CONCAT(FLOOR(Age / 5) * 5, ' - ', FLOOR(Age / 5) * 5 + 4, ' years') age_range, join_date,  COUNT(*) distribution
 FROM user_data.netflix_database
 WHERE join_date BETWEEN '2002-01-01' AND '2004-01-01'
 GROUP BY  2, 1
 ORDER BY 3 DESC;
 
 
 /* distribution of users across different subscription plans*/
 SELECT subscription_type, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1
 ORDER BY 2;
 
 /* by gender */
 SELECT subscription_type, Gender, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2
 ORDER BY 3;
 
 /* by country */
 SELECT subscription_type, Country, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2
 ORDER BY 3 DESC;
 /* Same thing but by country and gender */
 SELECT subscription_type, Country,Gender, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2, 3
 ORDER BY 4 DESC;
 
 /* When finding devices most commonly used by users*/
 SELECT  Device, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1
 ORDER BY 2 DESC;
 
 /* Devices by region */
 SELECT Country,  Device, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2
 ORDER BY 3;
 
 --  CREATING DIFFERENT VIEWS FOR VISUALISATION -- 
 CREATE VIEW `subscription_per_country_by_gender` AS 
SELECT subscription_type, Country,Gender, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2, 3
 ORDER BY 4 DESC;
 
 CREATE VIEW `devices_per_country` AS 
 SELECT Country,  Device, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1, 2
 ORDER BY 3;
 
 CREATE VIEW `subscription_counts` AS 
 SELECT subscription_type, COUNT(*) distribution
 FROM user_data.netflix_database
 GROUP BY 1
 ORDER BY 2;
 
 CREATE VIEW `age_range_distributions` AS 
 SELECT
 CONCAT(FLOOR(Age / 5) * 5, ' - ', FLOOR(Age / 5) * 5 + 4, ' years') age_range, 
 COUNT(*) age_distribution 
 FROM user_data.netflix_database
 GROUP BY 1
 ORDER BY 1;
 



 
 
