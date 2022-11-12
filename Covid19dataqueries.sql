USE PortfolioProject;

--1. Counts the total cases, total deaths, and death percentage globally 
SELECT 
SUM(new_cases) AS Total_Cases, 
SUM(Cast(new_deaths as bigint)) AS Total_Deaths,
SUM(Cast(new_deaths as bigint))/SUM(new_cases) *100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--2 Looks at the total death count by Location(continent) 
SELECT 
location, 
SUM(cast(new_deaths as bigint)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL 
and location NOT IN ('World','European Union', 'International', 'High income','Lower middle income', 'Low income','middle income','Upper middle income')
GROUP BY location
ORDER BY TotalDeathCount DESC 

--3 Looks at countries Highest Infection count and Percent of the population infected
SELECT 
location, 
population,
MAX(total_cases) AS HighestInfectionCount, 
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM 
CovidDeaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC 

--4 Looks at Highest Infection Count and Percent of Population Infected by date
SELECT 
location, 
population,
date,
MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM 
CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC
