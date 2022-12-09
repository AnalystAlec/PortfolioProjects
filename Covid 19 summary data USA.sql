USE PortfolioProject;
-- Monthly total cases in USA
Select 
location AS Country, 
MONTH(date) as Month,
YEAR(date) as Year , 
DATENAME(month,date) + ' ' + DATENAME(year,date) AS month_year,
SUM(new_cases) AS Monthly_Total_Cases 
FROM CovidDeaths
WHERE location = 'United States' AND continent IS NOT NULL 
Group BY MONTH(date) , YEAR(date), DATENAME(month,date) , DATENAME(year,date), location
ORDER BY Year(date), Month(date)
--Monthly Total Deaths in USA
Select 
location AS Country, 
MONTH(date) as Month,
YEAR(date) as Year , 
DATENAME(month,date) + ' ' + DATENAME(year,date) AS month_year,
SUM(CAST(new_deaths AS bigint)) AS Monthly_Total_Deaths,
SUM(CAST(new_deaths AS bigint))/(population)  AS Monthly_Death_percentage
FROM CovidDeaths
WHERE location = 'United States' AND continent IS NOT NULL 
Group BY MONTH(date) , YEAR(date), DATENAME(month,date) , DATENAME(year,date), location, population
ORDER BY Year(date), Month(date)
--Monthly Total People Fully Vaccinated in USA
Select 
CD.location AS Country, 
MONTH(CD.date) as Month,
YEAR(CD.date) as Year , 
DATENAME(month,CD.date) + ' ' + DATENAME(year,CD.date) AS month_year,
MAX(CAST(people_fully_vaccinated as bigint)) as Monthly_people_fully_vaccinated,
MAX(CAST(people_fully_vaccinated AS bigint))/(CD.population)  AS Monthly_people_fully_vaccinated_percentage
FROM CovidVaccinations CV
join CovidDeaths CD ON CV.location = CD.location AND 
						CV.Date = CD.date
WHERE CD.location = 'United States' AND CD.continent IS NOT NULL 
Group BY  MONTH(CD.date) , YEAR(CD.date), DATENAME(month,CD.date) , DATENAME(year,CD.date), CD.location, CD.population
ORDER BY Year(CD.date), Month(CD.date)

--Monthly Total Tests in USA
Select 
location AS Country, 
MONTH(date) as Month,
YEAR(date) as Year , 
DATENAME(month,date) + ' ' + DATENAME(year,date) AS month_year,
SUM(CAST(new_tests as bigint)) as Monthly_Total_Tests
FROM CovidVaccinations
WHERE location = 'United States' AND continent IS NOT NULL 
Group BY  MONTH(date) , YEAR(date), DATENAME(month,date) , DATENAME(year,date), location
ORDER BY Year(date), Month(date)
--Population/deaths/cases/people fully vaccinated (total) in USA from January 1 2020 - November 10 2022
Select
Distinct CD.location, 
CD.population, 
SUM(CAST(new_deaths as bigint)) as total_death, 
SUM(Cast(new_cases as bigint)) as total_cases, 
MAX(Cast(people_fully_vaccinated as bigint)) as total_people_fully_vaccinated
FROM CovidDeaths CD join CovidVaccinations CV 
ON 
CD.location = CV.location AND CD.date = CV.date
WHERE CD.location = 'United States'
Group By CD.location, CD.population





