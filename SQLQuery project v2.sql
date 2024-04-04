select *
from [Portfilio project].dbo.Coviddeaths
where continent is not null

select location,date, total_cases, new_cases,total_deaths,population
from [Portfilio project].dbo.Coviddeaths
order by 1,2

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [Portfilio project].dbo.Coviddeaths
order by 1,2

select location,date, total_cases,population ,(total_deaths/population)*100 as deathpercentage
from [Portfilio project].dbo.Coviddeaths
--where location	like '%Asia%'

select location,Max(total_deaths) as deathcount
from [Portfilio project].dbo.Coviddeaths
order by 1,2

select location, population , max(total_cases) as highestrateinfected ,Max((total_cases/population))*100 as infectedper
from [Portfilio project].dbo.Coviddeaths
--where location	like '%Asia%'
group by location, population
order by 1,2


select location,Max(total_deaths) as deathcount
from [Portfilio project].dbo.Coviddeaths
where continent is not null
group by location
order by deathcount desc

select continent,Max(total_deaths) as deathcount
from [Portfilio project].dbo.Coviddeaths
where continent is not null
group by continent
order by deathcount desc

select sum(new_cases)as totalcases, sum(cast(new_deaths as int))as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfilio project].dbo.Coviddeaths
where continent is not null
--group by date
order by 1,2

select *
from [Portfilio project].dbo.Coviddeaths dea
join [Portfilio project].dbo.Covidvaccination vac
     on dea.location = vac.location 
	 and dea.date = vac.date

select dea.continent,  dea.location, dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingpplvaccinated
from [Portfilio project].dbo.Coviddeaths dea
join [Portfilio project].dbo.Covidvaccination vac
     on dea.location = vac.location 
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


with popvsVac(continent,location,date,population,new_vaccinations,rollingpplvaccinated)
as
(
select dea.continent,  dea.location, dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingpplvaccinated
from [Portfilio project].dbo.Coviddeaths dea
join [Portfilio project].dbo.Covidvaccination vac
     on dea.location = vac.location 
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)    
select *,(rollingpplvaccinated/population)*100
from popvsVac

Drop table if exists #Percentpopulationvaccinate

Create Table #Percentpopulationvaccinate
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
rollingpplvaccinated numeric
)

Insert into #Percentpopulationvaccinate
select dea.continent,  dea.location, dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingpplvaccinated
from [Portfilio project].dbo.Coviddeaths dea
join [Portfilio project].dbo.Covidvaccination vac
     on dea.location = vac.location 
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3
  
select *,(rollingpplvaccinated/population)*100
from #Percentpopulationvaccinate



create view Percentpopulationvaccinate as
select dea.continent,  dea.location, dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingpplvaccinated
from [Portfilio project].dbo.Coviddeaths dea
join [Portfilio project].dbo.Covidvaccination vac
     on dea.location = vac.location 
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from Percentagepopulationvaccinated