

CREATE TABLE layoffs_staging LIKE layoffs;
INSERT layoffs_staging SELECT * FROM layoffs;
SELECT * FROM layoffs_staging;

-- Menambahkan row_num ke tabel layoffs_staging
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
      industry, total_laid_off, percentage_laid_off, `date`,
      stage, country, funds_raised_millions) AS row_num FROM layoffs_staging;
 -- Menampilakn row_num 2     
with duplicate_cte AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
      industry, total_laid_off, percentage_laid_off, `date`,
      stage, country, funds_raised_millions) AS row_num FROM layoffs_staging)
      SELECT* FROM duplicate_cte WHERE row_num>1;
   
 -- Langkah awal remove duplicate yaitu dengan membuat table baru lagi. 
 -- Sebab row_num hanya muncul pada query dan tidak disimpan di tabel layoffs_staging
 
 -- Membuat tabel 3 yang dapat menyimpan row_num
 
 START TRANSACTION;
CREATE TABLE `layoffs_staging2` ( -- the new table is layoffs_staging2
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ROLLBACK;
SELECT * FROM layoffs_staging2;
INSERT layoffs_staging2 SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
      industry, total_laid_off, percentage_laid_off, `date`,
      stage, country, funds_raised_millions) AS row_num FROM layoffs_staging;
SELECT * FROM layoffs_staging2;

-- Delete duplicate data
DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- Check Again
SELECT * FROM layoffs_staging2 WHERE ROW_NUM>1;


-- 2. Standarizing the data

-- To find out the values in the column

-- Column: Indsutry
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1; 

-- Update CryptoCurrency and Crypto Currency to Crypto Currency
UPDATE layoffs_staging2 SET industry = 'Crypto Currency'
WHERE industry LIKE 'cryptocurrency' OR industry LIKE 'Crypto Currency';
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;



-- Column: Country
SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';  
SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;

-- Column Date
-- Display column "date" in mm/dd/yyyy and column "date" with yyyy-mm-dd format.
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;

-- Update into with yyyy-mm-dd format
UPDATE layoffs_staging2 SET `date` =STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2;
-- Update into date type
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
SELECT * FROM layoffs_staging2;

-- 3. NULL OR BLANK VALUES

-- Column: Industry
SELECT * FROM layoffs_staging2 WHERE industry is null OR industry ='';

SELECT * FROM layoffs_staging2 WHERE `company` = 'Airbnb'
OR `company` = "Bally's Interactive" OR `company` = 'Carvana'
OR `company` = "Juul";

UPDATE layoffs_staging2 SET industry = CASE 
    WHEN company = 'Airbnb' THEN 'Travel'
    WHEN company = 'Juul' THEN 'Consumer'
    WHEN company = 'Carvana' THEN 'Transportation'
    ELSE industry  -- tetap sama jika tidak memenuhi kondisi 
    END WHERE company IN ('Airbnb', 'Juul', 'Carvana');

-- TOTAL LAID PAID OFF AND PERCENTAGE LAID OFF COLUMN

SELECT * FROM layoffs_staging2 WHERE total_laid_off is null AND percentage_laid_off is null;
DELETE FROM layoffs_staging2 WHERE total_laid_off is null AND percentage_laid_off is null;

SELECT * FROM layoffs_staging2 WHERE `date` is null;  -- Date is already in date type

-- 4. Drop row num
ALTER TABLE layoffs_staging2 DROP COLUMN row_num; 
SELECT * FROM layoffs_staging2;


-- EXPLORATORY DATA ANALYSIS

-- EXPLORATORY DATA ANALYSIS

-- The highest total laid off and percentage laid off
SELECT MAX(total_laid_off) AS Total_laid_off, MAX(percentage_laid_off) AS laid_off_in_percent FROM layoffs_staging2;

-- List companies that lay off 100%
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY company DESC;

-- Total the companies that lay off 100%
SELECT COUNT(*) AS Total_companies_laid_off FROM layoffs_staging2 WHERE percentage_laid_off = 1;

-- Total laid off based on industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2 GROUP BY industry ORDER BY 2 DESC;

-- Total laid off based on country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;

-- Average Laid off each country
SELECT country, AVG(total_laid_off) AS avg_laid_off
FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;


-- Based on year
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY YEAR(`date`) ORDER BY 1 DESC;

-- Based on month during 2020-2023
SELECT SUBSTRING(`date`,1, 7) AS `month`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY SUBSTRING(`date`,1, 7) ORDER BY 2 DESC;

-- Company laid-off based on year
WITH Company_Year(company, `year`,total_laid_off)  AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`))
, Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY  `year` ORDER BY 
total_laid_off DESC) AS Ranking FROM Company_Year
WHERE `year` is not null) 
SELECT * FROM Company_Year_Rank WHERE Ranking <=3;

