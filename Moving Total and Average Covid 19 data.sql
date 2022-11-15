--1 Looking at Data for Covid Deaths moving totals and moving averages over time
-- So there when there is a null, the moving average doesnt take that one in account. So Checking with no nulls for tableau and removing non country locations
SELECT 
 location,
CAST(date AS date) AS Date,
new_deaths, 
SUM(CAST(new_deaths as bigint)) OVER (PARTITION BY location ORDER BY Date) AS MovingTotal, 
AVG(Cast(new_deaths as float)) OVER (Partition by location ORDER BY date ) AS MovingAverage  
FROM CovidDeaths
WHERE new_deaths IS NOT NULL AND location NOT IN ('World','European Union', 'International', 'High income','Lower middle income', 'Low income','middle income','Upper middle income') AND continent IS NOT NULL 
Group BY date, location, new_deaths
ORDER BY location







