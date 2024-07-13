use world_layoffs;

-- Exploratory Data Analysis
select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select*
from layoffs_staging2
where percentage_laid_off =1
order by funds_raised_millions desc;

-- laid offs per company
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- when these laid off started
select min(`date`), max(`date`)
from layoffs_staging2;

-- laid offs with respect to industries
select industry , sum(total_laid_off)
from layoffs_staging2
group by industry 
order by 2 desc;

-- laid offs with respect to countries
select country, sum(total_laid_off)
from layoffs_staging2
group by country 
order by 2 desc;

-- total laid offs per year from start to end
select year(`date`) as `year` , sum(total_laid_off)
from layoffs_staging2
group by `year`
order by 1 desc;

-- laid offs with respect to stage
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- total laid offs per month
select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 ;

-- rolling total per month
with roll_total as(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from roll_total;

-- company laid offs per month
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

-- ranking top 5 companies by their laid offs in each year
with company_year(company, years,total_laid_off)as
(select company, year(`date`) , sum(total_laid_off) as total_off
from layoffs_staging2
group by company, year(`date`)
),company_as_rank as
(select *,
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_as_rank
where ranking <=5;





