USE PortfolioProject;

Select *
FROM CovidDeaths
order by 3,4


--Select *
--FROM CovidVaccinations
--order by 3,4

--Select The data that we will be using 
Select 
location, date, total_cases,new_cases, total_deaths,population

FROM CovidDeaths
order by 1,2

--Looking at total cases vs total deaths and death percentage in united states
Select
location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
where location = 'United States'
order by 1,2

--Looking at the Total Cases Vs Population
--shows what percentage of population got covid
Select
location,date,total_cases, population, (total_cases/population)*100 AS CovidpopPercentage
FROM CovidDeaths
where location = 'United States'
order by 1,2 DESC

--Looking at countries with highest infection rate compared to population 
Select
location, population, MAX(total_cases) HighestInfectionCount,
Max((total_cases/population))*100 AS Percent_Population_Infected
FROM CovidDeaths
GROUP BY population,location
order by Percent_Population_Infected DESC

--Showing Countries with the highest Death count per population
Select
location,MAX(Cast (total_deaths as bigint)) tot_death_count
FROM CovidDeaths
WHERE continent is not null --have to do this where clause to get rid of instances when continent is null but switches to location with continent
GROUP BY location
ORDER BY tot_death_count DESC 

--Break things down by continent 
Select
location,MAX(Cast (total_deaths as bigint)) tot_death_count
FROM CovidDeaths
WHERE continent is null --have to do this where clause to get rid of instances when continent is null but switches to location with continent
GROUP BY location
ORDER BY tot_death_count DESC 


--Showing the continents with highest death counts
Select
continent,MAX(Cast (total_deaths as bigint)) tot_death_count
FROM CovidDeaths
WHERE continent is NOT null --have to do this where clause to get rid of instances when continent is null but switches to location with continent
GROUP BY continent
ORDER BY tot_death_count DESC 

--GLOBAL NUMBERS 

Select 
SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths AS bigint)) AS total_deaths,
SUM(Cast(new_deaths as bigint))/SUM(new_cases) * 100 as DeathPercentage

FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


--Total Population vs Vaccinations
select
dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccination --rolling sum
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER by 2,3


--USE CTE to calculate percentage of people vaccinated 
WITH PopvsVAC (Continent, Location,Date, Population, New_Vaccinations,RollingPeopleVaccinated)
AS (
select
dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
 )

Select
*,
(RollingPeopleVaccinated/Population) *100 AS PercentVaccinated
FROM PopvsVAC

--TEMP Table 
DROP TABLE IF EXISTS #PercentPopulationVaccinated 
CREATE TABLE #PercentPopulationVaccinated
( Continent nvarchar(255),
Location nvarchar(255), 
Date datetime,
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select
dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
 
 Select
*,
(RollingPeopleVaccinated/Population) *100 AS PercentVaccinated
FROM #PercentPopulationVaccinated

--CREATE A VIEW TO STORE DATA LATER visualizations
CREATE VIEW PercentPopulationVaccinated AS 
select
dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

Select *
FROM PercentPopulationVaccinated

