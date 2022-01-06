--1. Let's see what the total number of cases, total_deaths and the death_rate there is in Israel per date

SELECT location
, date
, total_cases
, total_deaths
, ROUND((total_deaths/total_cases) * 100, 2) AS death_rate_percent
FROM Cov_deaths
WHERE location = 'Israel'
ORDER BY location, date


--2. Let's see how many people in reletion to the infected past away during the whole period of time

SELECT location
, date
, population
, total_cases
, total_deaths
, ROUND((total_cases/population) * 100, 2) AS death_toll_percent
FROM Cov_deaths
WHERE location = 'Israel'
ORDER BY location, date


--3 Let's find Top 20 countries with highest infection rate

SELECT *
, ROUND(uptodate_cases/population * 100, 2) AS PercentInfected_PerPopulation
FROM
	(SELECT  TOP 20 location
	, population
	, MAX(total_cases) AS uptodate_cases
	FROM Cov_deaths
	WHERE location not in ('World', 'Asia', 'Europe', 'North America', 'European Union', 'South America', 'United Kingdom', 'Africa')
	GROUP BY location, population
	ORDER BY uptodate_cases DESC) a
ORDER BY 4 DESC


--4 Let's take a look at top 20 countries with highest total deaths per population and death'

SELECT *
, ROUND(total_deaths/population, 4) *100 AS Death_Rate_Per_Population
FROM
	(SELECT TOP 20 location
	, population
	, MAX(cast(total_deaths as int)) AS total_deaths
	FROM Cov_deaths
	WHERE location not in ('World', 'Asia', 'Europe', 'North America', 'European Union', 'South America', 'United Kingdom', 'Africa')
	GROUP BY location, population
	ORDER BY total_deaths DESC) b


--5 Let's take a look at the data, related to continents

SELECT location
, MAX(cast(total_cases as int)) as TotalCases
, MAX(cast(total_deaths as int)) AS TotalDeaths
FROM Cov_deaths
WHERE continent is NULL
GROUP BY location


--6 Let's take a look at the situation in the world (Total cases, Total deaths and death rate worldwide)

SELECT location
, MAX(cast(total_cases as int)) as TotalCases
, MAX(cast(total_deaths as int)) AS TotalDeaths
, ROUND(MAX(cast(total_deaths as float))/MAX(cast(total_cases as float)), 4) *100 AS DeathRateWorldwide
FROM Cov_deaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeaths DESC
			

--7 Let's take a look at vaccination per country
WITH CTE_1
AS (
SELECT continent
, location
, date
, population
, new_cases
, SUM(new_cases) OVER (PARTITION BY location ORDER BY date) AS Running_total_Cases
FROM Cov_deaths
WHERE continent IS NOT NULL)
,
CTE_2
AS (
SELECT continent
, location
, date
, new_vaccinations
, SUM(CAST(new_vaccinations as float)) OVER (PARTITION BY location ORDER BY location, date) AS Running_total_vaccinations
FROM Cov_vacc
WHERE continent IS NOT NULL)


SELECT z.continent, z.location, z.date, z.population, z.new_cases, z.Running_total_cases, x.new_vaccinations, x.Running_total_vaccinations
FROM CTE_1 z JOIN CTE_2 x
	ON z.location = x.location AND z.date = x.date
ORDER BY z.location, z.date



--8 Let's take a look at some general figures per country

CREATE VIEW Country_info AS
SELECT de.continent
, de.location
, de.population
, MAX(CAST(de.total_cases as int)) AS total_cases
, MAX(CAST(de.total_deaths as int)) AS total_deaths
, MAX(CASt(va.total_tests as int)) AS total_tests
, va.population_density
, va.median_age
FROM Cov_deaths de JOIN Cov_vacc va
	ON de.location = va.location AND de.date = va.date
WHERE de.continent IS NOT NULL
GROUP BY de.continent, de.location, de.population, va.population_density, va.median_age

DROP VIEW Country_info

SELECT *
FROM Country_info
ORDER BY total_deaths DESC





