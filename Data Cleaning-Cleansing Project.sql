# data cleaning/cleansing project
# creating a copy from the original/raw data

CREATE TABLE layoffs_staging
SELECT * FROM layoffs;


# --------------------------------------------------------------------------------
# 1): Removing Duplicates

ALTER TABLE layoffs_staging ADD COLUMN id INT KEY AUTO_INCREMENT;

WITH duplicate_finding AS (
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
					  percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE id IN (SELECT id FROM duplicate_finding WHERE row_num > 1);

ALTER TABLE layoffs_staging DROP COLUMN id;

# --------------------------------------------------------------------------------
# 2): Standarizing Data


UPDATE layoffs_staging
SET 
	company = TRIM(company),
    location = TRIM(location), 
    industry = TRIM(industry), 
    total_laid_off = TRIM(total_laid_off),
    percentage_laid_off = TRIM(percentage_laid_off),
    `date` = TRIM(`date`), 
    stage = TRIM(stage),
    country = TRIM(country), 
    funds_raised_millions = TRIM(funds_raised_millions);


UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging
SET country = 'United States'
WHERE country LIKE 'United States%';

UPDATE layoffs_staging
SET date = str_to_date(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging MODIFY COLUMN `date` DATE;



# --------------------------------------------------------------------------------
# 3): NULL/Blank Values


UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';


UPDATE layoffs_staging AS t1
JOIN layoffs_staging AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL) AND (t2.industry IS NOT NULL);



# --------------------------------------------------------------------------------
# 4): Remove Unnecessary Columns/Rows

DELETE
FROM layoffs_staging
WHERE (total_laid_off IS NULL) AND (percentage_laid_off IS NULL);


# --------------------------------------------------------------------------------
# 5): Data Display

SELECT * FROM layoffs_staging ORDER BY company;