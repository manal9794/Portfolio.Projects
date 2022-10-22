select *
from [Project 1 (covid)]..CovidDeaths
where continent is not null
order by 3,4

--select*
--from CovidVaccinations
--order by 3,4

-- select data that we are going to be starting with 

Select location, date,total_cases, new_cases,total_deaths, population
from [Project 1 (covid)]..CovidDeaths
where continent is not null
order by 1,2

-- Total Cases Vs Total Death
-- showing the likelihood of daying if you conact covid in your country

Select location, date,total_cases, total_deaths,(total_deaths/total_cases)*100 AS Death_rate
from [Project 1 (covid)]..CovidDeaths
where location like '%canada%'
and continent is not null 
order by 1,2

--total cases Vs population
--shows what percentage of what population infected with covid 

Select location, date,total_cases, population,(total_cases/population)*100 AS case_rate
from [Project 1 (covid)]..CovidDeaths
where location like '%canada%'
order by 1,2

-- Countries with highest infection rate compared to population

Select location,population, Max(total_cases)AS Highestinfection,Max((total_cases/population))*100 AS percentofpeopleinfected 
from [Project 1 (covid)]..CovidDeaths
--where location like '%canada%'
group by location, population
order by percentofpeopleinfected desc 

-- Countries with the Highest death count per population

Select location,max(cast(total_deaths as int)) As TotalDeathCount
from [Project 1 (covid)]..CovidDeaths
--where location like '%canada%'
where continent is not null
group by location
order by TotalDeathCount desc

-- Breaking things down by continent
-- showing countries with the highest death count per population

Select continent,max(cast(total_deaths as int)) As TotalDeathCount
from [Project 1 (covid)]..CovidDeaths
--where location like '%canada%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Project 1 (covid)]..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Looking at total population Vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Project 1 (covid)]..CovidDeaths as dea
Join [Project 1 (covid)]..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 







