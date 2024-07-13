-- DATA CLEANING 
USE WORLD_LAYOFFS;
SELECT *
FROM layoffs;

/* 1. REMOVE DUPLICATES
2. STANDARDIZE THE DATA
3. NULL VALUES OR BLANK VALUES
4. REMOVE ANY COLUMN */

CREATE TABLE LAYOFFS_STAGING
LIKE LAYOFFS;
SELECT *
FROM layoffs_staging;

INSERT INTO LAYOFFS_STAGING
SELECT*
FROM LAYOFFS;

SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions) AS row_numb
FROM LAYOFFS_STAGING;

WITH DUPLICATE_CTE AS
(SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions) AS row_numb
FROM LAYOFFS_STAGING
)
SELECT* 
FROM DUPLICATE_CTE
WHERE ROW_NUMB >1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_numb` INT) 
   ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions) AS row_numb
FROM LAYOFFS_STAGING;

SELECT*
FROM layoffs_staging2
WHERE row_numb >1;

SET SQL_SAFE_UPDATES =0;

-- STANDARDIZING DATA
SELECT company
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry='Crypto'
where industry like 'Crypto%';

select *
from layoffs_staging2;

select distinct location
from layoffs_staging2
order by 1;

select `date`
from layoffs_staging2;

update layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');
alter table layoffs_staging2
modify column `date` date;

-- Removing null values
select distinct industry
from layoffs_staging2;

select *
from layoffs_staging2
where industry is null 
or industry=' ';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
     on t1.company=t2.company 
where (t1.industry is null or t1.industry= ' ')
and t2.industry is not null;

select *
from layoffs_staging2
where company like'Bally%';

select *
from layoffs_staging2
where percentage_laid_off is null
and total_laid_off is null;

delete 
from layoffs_staging2
where percentage_laid_off is null
and total_laid_off is null;

-- Removing unecessary column

alter table layoffs_staging2
drop column row_numb;




