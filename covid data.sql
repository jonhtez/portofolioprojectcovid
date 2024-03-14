select *
from PortofolioProject..CovidDeaths
order by 3,4
--select *
--from PortofolioProject..Covidvaccinations
--order by 3,4
select location,date,total_cases,new_cases,total_deaths,
population
from PortofolioProject..CovidDeaths
order by 1,2

--looking at total cases vs Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 'total deaths percentage'
from PortofolioProject..CovidDeaths
order by 1,2

--looking at total cases vs Total Deaths in kenya

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 'total deaths percentage'
from PortofolioProject..CovidDeaths
where location like 'kenya%'
order by 1,2   
--or

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 'total deaths percentage'
from PortofolioProject..CovidDeaths
where location ='kenya'
order by 1,2   

--total cases vs population in percentage

select location,date,population,total_cases, (total_cases/population)*100 'total cases in population percentage'
from PortofolioProject..CovidDeaths
where location ='kenya'
order by 1,2   

--country with highest infection  cases aginst population
select location,population,max(total_cases) 'highest infection cases', max((total_cases/population))*100 'percentage population infected'
from PortofolioProject..CovidDeaths
group by location,population
order by 'percentage population infected' desc 

--country with highest deaths  cases aginst population

select location,max(cast(total_deaths as int)) 'highest death cases'
from PortofolioProject..CovidDeaths
where continent is not null
group by location
order by  'highest death cases'desc 

--by continent
select location,max(cast(total_deaths as int)) 'highest death cases'
from PortofolioProject..CovidDeaths
where continent is null
group by location
order by  'highest death cases'desc

--or
select continent,max(cast(total_deaths as int)) 'highest death cases'
from PortofolioProject..CovidDeaths
where continent is not null
group by continent
order by  'highest death cases'desc

--continent with mos high deaths

SELECT continent, max(cast(total_deaths as int))'continent with most deaths'
from PortofolioProject..CovidDeaths
where continent is not null
group by continent
order by 'continent with most deaths' desc

--Global
SELECT date, sum(new_cases)'new cases total',sum(cast(new_deaths as int)) 'new deaths',sum(cast(new_deaths as int))/sum(new_cases)*100 'new deaths percentage'
from PortofolioProject..CovidDeaths
where continent is not null
group by date
 
 --county with most fully vaccinated people
select location,MAX(cast(people_fully_vaccinated as int)) 'most vaccinated'
from PortofolioProject..Covidvaccinations
where continent is not null
AND people_fully_vaccinated is not null
GROUP BY location
ORDER BY 'most vaccinated' desc



--continent with most fully vaccinated people
select continent,MAX(cast(people_fully_vaccinated as int)) 'most vaccinated'
from PortofolioProject..Covidvaccinations
where continent is not null
AND people_fully_vaccinated is not null
GROUP BY continent
ORDER BY 'most vaccinated' desc

--county with most cases, most deaths, fully vaccinated people 
--select dea.location,dea.continent,MAX(cast(dea.total_cases as int)) 'total cases',
--MAX(cast(dea.total_deaths as int)) 'most deaths',
--MAX(cast(vac.people_fully_vaccinated as int)) 'most vaccinated'
--from PortofolioProject..CovidDeaths dea join PortofolioProject..Covidvaccinations vac
--on dea.location=vac.location and dea.continent=vac.continent
--where dea.continent is not null and
--dea.location is not null
--AND people_fully_vaccinated is not null
--GROUP BY dea.continent,dea.location
--ORDER BY 'most vaccinated','total cases' desc

--total population vs people vaccinated
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over
(partition by dea.location order by dea.location,dea.date)'rolling new vaccinations'
from PortofolioProject..CovidDeaths dea join
PortofolioProject.. Covidvaccinations vac on
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
order by 1,2,3



---total vaccinated vs population using cte


WITH  Popvsvac (continent,location,date,population, new_vaccinations,rolling_new_vaccinations)

AS  (
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over
(partition by dea.location order by dea.location,dea.date)'rolling new vaccinations'
from PortofolioProject..CovidDeaths dea join
PortofolioProject.. Covidvaccinations vac on
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null

)
SELECT *,(rolling_new_vaccinations/population)*100 'total vaccinated percentage'
from Popvsvac


------using temp tables
drop table if exists #POPVSVACC
CREATE TABLE #POPVSVACC
(continent nvarchar(255),location nvarchar(255),date datetime,population numeric,new_vaccinations numeric,rolling_new_vaccinations numeric )
insert into #POPVSVACC
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over
(partition by dea.location order by dea.location,dea.date)'rolling new vaccinations'
from PortofolioProject..CovidDeaths dea join
PortofolioProject.. Covidvaccinations vac on
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null

select *,(rolling_new_vaccinations/population)*100 'population vaccinated percentage'
from #POPVSVACC


create view  
population_accinatedpercentage as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over
(partition by dea.location order by dea.location,dea.date)'rolling new vaccinations'
from PortofolioProject..CovidDeaths dea join
PortofolioProject.. Covidvaccinations vac on
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null





