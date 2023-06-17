SELECT *
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
ORDER  BY 3,4


--SELECT *
--FROM JOELPORTFOLIOPROJECT..WORLDCOVIDVACCINATIONS$
--ORDER  BY 3,4

SELECT LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS,POPULATION
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
ORDER BY 1,2 


--TOTAL CASES VS TOTAL DEATHS
--LIKELIHOOD OF DYING IF YOU CONTRACT COVID

SELECT LOCATION, DATE, TOTAL_CASES,TOTAL_DEATHS,(CAST(total_deaths/total_cases AS INT))*100 AS DEATHPERCENTAGE
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
WHERE LOCATION LIKE '%KINGDOM%'
ORDER BY 1,2 


--TOTAL CASES VS POPULATION

SELECT LOCATION, DATE, TOTAL_CASES, POPULATION, (cast(TOTAL_cases/population as int )) * 100 as deathpercentage
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
WHERE LOCATION LIKE '%KINGDOM%'
ORDER BY 1,2 


--SHOW PERCENTAGE OF POPULATION GOT COVID

SELECT LOCATION, DATE, TOTAL_CASES, POPULATION, TOTAL_DEATHS
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
WHERE LOCATION LIKE '%KINGDOM%'
ORDER BY 1,2 


--COUMTRIES WITH HIGHEST INFECTION RATE TO POPULATION

--COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT LOCATION, MAX(cast(TOTAL_DEATHS as int))AS TOTALALDEATHCOUNT
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
--WHERE LOCATION LIKE '%KINGDOM%'
where continent is not null
GROUP BY LOCATION 
order by TOTALALDEATHCOUNT desc


--BREAK THINGS DOWN BY CONTINENT

SELECT LOCATION, MAX(cast(TOTAL_DEATHS as int))AS TOTALALDEATHCOUNT
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
--WHERE LOCATION LIKE '%KINGDOM%'
where continent is not null
GROUP BY LOCATION 
order by TOTALALDEATHCOUNT desc


--SHOWING CONTINET WITH HIGHEST DEATHCOUNT

SELECT continent, MAX(cast(TOTAL_DEATHS as int))AS TOTALALDEATHCOUNT
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
--WHERE LOCATION LIKE '%KINGDOM%'
where continent is not null
GROUP BY continent
order by TOTALALDEATHCOUNT desc


  --GLOBAL NUMBERS

  Select SUM(new_cases) as total_cases,SUM (cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int ))/SUM(new_cases) * 100 as Deathpercentage
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$
--WHERE LOCATION LIKE '%KINGDOM%'
where continent is not null
--GROUP BY DATE
ORDER BY 1,2 



--TOTAL  POPULATION VS VACCINATION

SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location
,dea.date) as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)* 100
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$ dea
JOIN JOELPORTFOLIOPROJECT..WORLDCOVIDVACCINATIONS$ vac
     ON dea.location = vac.location
and dea.date = vac.date 
where  dea.continent is not null
order by 2,3



--USE CTE

With PopsVac (Continent,location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)* 100
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$ dea
JOIN JOELPORTFOLIOPROJECT..WORLDCOVIDVACCINATIONS$ vac
     ON dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
)
select *, (Rollingpeoplevaccinated/population)* 100
from PopsVac


--TIME TABLE

CREATE TABLE #PERCENTAGEPOPULTIONVACCINATED
(
CONTINENT NVARCHAR (255),
LOCATION NVARCHAR (255),
DATE DATETIME,
POPULATION NUMERIC,
ROLLINGPEOPLEVACCINNATED NUMERIC 
)


INSERT INTO #PERCENTPOPULATIONVACCINNATED
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)* 100
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$ dea
JOIN JOELPORTFOLIOPROJECT..WORLDCOVIDVACCINATIONS$ vac
     ON dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
)


--CREATE VIEW TO STORE DATA

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)* 100
FROM JOELPORTFOLIOPROJECT..WORLDCOVIDDEATHS$ dea
JOIN JOELPORTFOLIOPROJECT..WORLDCOVIDVACCINATIONS$ vac
     ON dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

select *
from 





