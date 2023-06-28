--TABLE 1 COVID_DEATHS

select * from portfolioproject.dbo.coviddeaths
where continent is not null
ORDER BY 3,4


select location,date,total_cases,new_cases,total_deaths,population
from portfolioproject.dbo.coviddeaths
ORDER BY 1,2

select location,date,total_cases,new_cases,total_deaths,(cast(total_deaths as int)), (cast(total_cases as int))
from portfolioproject.dbo.coviddeaths
ORDER BY 1,2

SELECT location,date,total_cases,new_cases,total_deaths,
(CAST(total_deaths AS decimal) / CAST(total_cases AS decimal))*100 AS death_percentage
FROM portfolioproject.dbo.coviddeaths
where location like 'united states'
ORDER BY
  1, 2;

SELECT location,date,total_cases,new_cases,total_deaths,population,
(total_cases / population )*100 as percentage_population 
FROM portfolioproject.dbo.coviddeaths
where location like 'united states'
ORDER BY
  1, 2;

SELECT location,max(total_cases) as highestinfectioncount,population,
max((total_cases / population ))*100 as infected_populationpercentage 
FROM portfolioproject.dbo.coviddeaths
group by location,population
ORDER BY infected_populationpercentage  desc

SELECT location,max(cast(total_deaths as int)) as total_deathcount 
FROM portfolioproject.dbo.coviddeaths
where continent is not null
group by location
ORDER BY total_deathcount  desc


--continent
SELECT continent,max(cast(total_deaths as int)) as total_deathcount 
FROM portfolioproject.dbo.coviddeaths
where continent is not null
group by continent
ORDER BY total_deathcount  desc



SELECT continent,max(cast(total_deaths as int)) as total_deathcount 
FROM portfolioproject.dbo.coviddeaths
where continent is not null
group by continent
ORDER BY total_deathcount  desc

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
where continent is not null
order by 1,2


----------------------------------------------
--table 2 covid_vacinnation

select cd.continent ,cd.location,cd.date,cd.population,cd.location,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as bigint)) OVER(partition by cd.location ORDER BY CD.LOCATION,CD.DATE) as vacinated
from portfolioproject.dbo.coviddeaths CD
JOIN portfolioproject..covidvacinnation CV
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3


--CTE

with prevstab (continent,location,data,population,new_vaccination,vacinated)
as
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as bigint)) OVER(partition by cd.location ORDER BY CD.LOCATION,CD.DATE) as vacinated
from portfolioproject.dbo.coviddeaths CD
JOIN portfolioproject..covidvacinnation CV
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
---order by 2,3
)

select *,(vacinated/population)*100 as vacvspop from prevstab


--TEMPTABLE

DROP Table if exists #Per
create table #per
(continent nvarchar(110),
location nvarchar(110),
date datetime,
population numeric,
new_vaccinations numeric ,
vacinated numeric
)
insert into #per
select cd.continent ,cd.location,cd.[date],cd.population,cv.new_vaccinations,
sum(convert(bigint,cv.new_vaccinations)) OVER(partition by cd.location ORDER BY CD.LOCATION,CD.DATE) as vacinated
from portfolioproject.dbo.coviddeaths CD
JOIN portfolioproject..covidvacinnation CV
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3


select *,(vacinated/population)*100 as VACPOPULATIONPER from #per




