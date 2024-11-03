Select *
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
Order by 3,4



--Select *
--From PortfolioProject.dbo.CovidVaccinations$
--Order by 3,4


--Select Data that we are going to be using

Select location, date,total_cases, new_cases, total_deaths,population
Where continent is not null
From PortfolioProject.dbo.CovidDeaths$
order by 1,2

--Looking for Total Cases vs Total Deaths
--Shows Likelihood of dying if you contract covid in your country

Select location, date,total_cases, total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths$
Where location like '%United Kingdom%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Total Population
--Shows what Percentage of population got covid

Select location, date,population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
--Where location like '%United Kingdom%'
order by 1,2


--Looking at Countries with Highest Infection rate Compared to Population


Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths$
--Where location like '%United Kingdom%'
Where continent is not null
Group by location,population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count Per Population


Select location, MAX(total_cases) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths$
--Where location like '%United Kingdom%'
Where continent is not null
Group by location
order by  TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT


--Showing Continents With The Highest Death Count Per Populatin

Select continent, MAX(total_cases) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths$
--Where location like '%United Kingdom%'
Where continent is not null
Group by continent
order by  TotalDeathCount desc


----GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
 (new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths$
--Where location like '%states%' where continent is not null
--Group By date 
order by 1,2



--Looking At Total Population VS Vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 From PortfolioProject..CovidDeaths dea
FROM PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE

WITH PopvsVac (Continent, Location ,Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 From PortfolioProject..CovidDeaths dea
FROM PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac



--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 From PortfolioProject..CovidDeaths dea
FROM PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated





----Creating View to store data for later visualizations


Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeopleVaccinated

FROM PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null 


select*
from PercentPopulationVaccinated


