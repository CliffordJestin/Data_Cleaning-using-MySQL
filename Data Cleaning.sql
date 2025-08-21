-- --- Data Cleaning Project: Layoffs Dataset ---

-- Create a staging table to work on a copy of the data
-- This is a best practice to avoid modifying the raw data
DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT layoffs_staging SELECT * FROM layoffs;

-- Identify and remove duplicates
-- We create a CTE to find duplicates using a row number partitioned by all columns
-- A row_num > 1 indicates a duplicate
WITH duplicate_cte AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY
                company,
                location,
                industry,
                total_laid_off,
                percentage_laid_off,
                `date`,
                stage,
                country,
                funds_raised_millions
        ) AS row_num
    FROM
        layoffs_staging
)
-- Delete duplicates by selecting all records where row_num > 1
DELETE FROM duplicate_cte
WHERE row_num > 1;

-- If your MySQL version doesn't support DELETE from a CTE, you can use a staging table
-- Create a new table with an added row_num column
DROP TABLE IF EXISTS layoffs_staging2;
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
  `row_num` int
);

-- Insert data from the original staging table into the new table, calculating the row number
INSERT INTO layoffs_staging2
SELECT
    *,
    ROW_NUMBER() OVER(
        PARTITION BY
            company,
            location,
            industry,
            total_laid_off,
            percentage_laid_off,
            `date`,
            stage,
            country,
            funds_raised_millions
    ) AS row_num
FROM
    layoffs_staging;

-- Now delete the duplicate rows from the new table
DELETE FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standardizing Data
-- Standardizing the 'company' column by trimming whitespace
UPDATE layoffs_staging2
SET company = TRIM(company);
select company from layoffs_staging2;

-- Standardizing the 'industry' column
-- Find and update similar industry names to a single standard
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardizing the 'country' column
-- Fix inconsistent entries like 'United States.'
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Standardizing the 'date' column
-- Change the data type from TEXT to DATE for proper sorting and analysis
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Handling Null and Blank Values
-- Populating missing 'industry' values
-- We join the table with itself on 'company' to find and fill null industries
-- This assumes that a company will have a consistent industry
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE
    t1.industry IS NULL
    AND t2.industry IS NOT NULL;
    
    
    
-- 4. Removing Columns and Rows    
-- Remove rows with completely null data
-- If total_laid_off and percentage_laid_off are both NULL, the row is not useful
DELETE FROM layoffs_staging2
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
    
-- Remove the 'row_num' column
-- This column was only for cleaning purposes and is no longer needed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num; 
select * from layoffs_staging2;  