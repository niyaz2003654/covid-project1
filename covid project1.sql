
select *
from covid.`coviddeaths 1`
WHERE continent is not NULL
 ORDER BY 3,4

-- select *
-- from covid.`covidvaccinations 2`
--  ORDER BY 3,4

-- select the data we are going to be using
select location,date,total_cases,new_cases,total_deaths,population
from covid.`coviddeaths 1`
ORDER BY 1,2

-- looking at total case vs total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covid.`coviddeaths 1`
ORDER BY 1,2

--  lookiing at tootal cse vs population
select location,date,total_cases,population,(total_cases/population)*100 as deathpercentage
from covid.`coviddeaths 1`
-- where location like '%india%'
ORDER BY 1,2

-- looking at country with highest infection rate compared to population
select location,population, Max(total_cases) as highestinfectioncout , 
Max((total_cases/population))*100 as percentpopulationinfected
from covid.`coviddeaths 1`
-- where location like '%india%'
GROUP BY location,population
ORDER BY percentpopulationinfected desc

-- showing countrywith highest death count per population
select location, Max(total_deaths) as totaldeathcount
from covid.`coviddeaths 1`
-- where location like '%india%'
WHERE continent is not NULL
GROUP BY location
ORDER BY totaldeathcount desc

-- LETS BREAK THINGS DOWN BY CONTINENT
 select continent, Max(total_deaths) as totaldeathcount
from covid.`coviddeaths 1`
-- where location like '%india%'
WHERE continent is not NULL
GROUP BY continent
ORDER BY totaldeathcount desc

--  breaking global numbers
select date,SUM(new_cases)
from covid.`coviddeaths 1`
where continent is not NULL
group by `date`
order by 1,2


--.....using  covaccination details.....--

--  loking at total popualtion and vacinat 
-- use cte
with popvsvac (continent,location,date,population,new_vaccinations,
rollingpeoplevacinated)
as
(
select dea .continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevacinated
FROM covid.`coviddeaths 1` dea
JOIN covid.`covidvaccinations 2` vac
 on dea.location=vac.location
 and dea.date=vac.date
 WHERE dea.continent is not NULL
--  order by 2,3
)
select *,(rollingpeoplevacinated/population)*100
from popvsvac

-- tem TABLE
drop table if exists #percentpopulationvaccinate
create table #percentpopulationvaccinate
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevacinated numeric
)
insert into #percentpopulationvaccinated
select dea .continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevacinated
FROM covid.`coviddeaths 1` dea
JOIN covid.`covidvaccinations 2` vac
 on dea.location=vac.location
 and dea.date=vac.date
 --WHERE dea.continent is not NULL
--  order by 2,3
select *,(rollingpeoplevacinated/population)*100
from #select dea .continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevacinated
FROM covid.`coviddeaths 1` dea
JOIN covid.`covidvaccinations 2` vac
 on dea.location=vac.location
 and dea.date=vac.date
 select *,(rollingpeoplevacinated/population)*100
from  #percentpopulationvaccinated
 
--  creating view to store the data for later

create view percentpopulationvaccinated as
 select dea .continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevacinated
FROM covid.`coviddeaths 1` dea
JOIN covid.`covidvaccinations 2` vac
 on dea.location=vac.location
 and dea.date=vac.date
 WHERE dea.continent is not NULL
--  order by 2,3
-- select *
-- from percentpopulationvaccinated
