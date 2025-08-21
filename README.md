# Layoffs Data Cleaning Project using SQL 📊
This project demonstrates a comprehensive data cleaning process on a real-world dataset of company layoffs. The goal was to transform a raw, messy dataset into a clean, structured format ready for exploratory data analysis (EDA).

Key Skills Demonstrated 🛠️
SQL Data Cleaning: Mastering essential data cleaning techniques.

Data Manipulation Language (DML): Using UPDATE, DELETE, and INSERT to modify data.

Data Definition Language (DDL): Using CREATE TABLE, DROP TABLE, and ALTER TABLE to manage database structure.

SQL Functions: Applying string functions (TRIM), date functions (STR_TO_DATE), and window functions (ROW_NUMBER()).

Table Joins & CTEs: Utilizing joins for data population and Common Table Expressions (CTEs) for efficient querying.

Project Steps 📋
1. Data Staging & Duplicate Removal
A staging table (layoffs_staging) was created to work on a copy of the original data, ensuring the raw data remains untouched.

Duplicates were identified using a ROW_NUMBER() window function partitioned by all columns. A row_num greater than one indicates a duplicate.

These duplicate rows were then removed from the dataset.

2. Data Standardization
Company Names: The TRIM() function was used to remove leading and trailing whitespace from the company column.

Industry Names: The LIKE operator was used to find and standardize inconsistent industry names (e.g., 'Crypto Currency', 'Cryptocurrency' to 'Crypto').

Country Names: Inconsistent country names were standardized (e.g., 'United States.' to 'United States').

Date Format: The date column, originally a text string, was converted to a proper DATE data type using STR_TO_DATE() and ALTER TABLE.

3. Handling Null & Blank Values
A self-join was used to populate missing industry values. The script joined the table on company to find instances where a company's industry was known and filled in the blanks where it was not.

4. Final Cleanup
Rows with no useful information (where both total_laid_off and percentage_laid_off were NULL) were removed.

The temporary row_num column, which was only needed for the de-duplication process, was dropped to finalize the clean table.

Project Files 📂
Data Cleaning.sql: Contains all the SQL queries used for the data cleaning process.

layoffs.csv: The original raw dataset used for this project.
