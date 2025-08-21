# 📊 Layoffs Data Cleaning Project  

This project demonstrates a comprehensive **data cleaning process** using SQL on a real-world layoffs dataset. The goal was to transform raw, messy data into a **clean, structured format** ready for **exploratory data analysis (EDA).**  

---

## 🛠️ Key Skills Demonstrated  

- **SQL Data Cleaning**: Mastering essential data wrangling techniques.  
- **Data Manipulation Language (DML)**: `UPDATE`, `DELETE`, and `INSERT` for modifying records.  
- **Data Definition Language (DDL)**: `CREATE TABLE`, `DROP TABLE`, and `ALTER TABLE` for managing database structure.  
- **SQL Functions**:  
  - String functions: `TRIM()`  
  - Date functions: `STR_TO_DATE()`  
  - Window functions: `ROW_NUMBER()`  
- **Table Joins & CTEs**: Efficient querying with **Common Table Expressions (CTEs)** and joins.  

---

## 📋 Project Steps  

### 1. Data Staging & Duplicate Removal  
- Created a **staging table** (`layoffs_staging`) to preserve raw data.  
- Identified duplicates using:  ROW_NUMBER() OVER (
PARTITION BY all_columns ORDER BY (SELECT NULL)
) AS row_num
- Removed rows where `row_num > 1`.  

---

### 2. Data Standardization  
- **Company Names**: Trimmed extra spaces (`TRIM()`).  
- **Industry Names**: Used `LIKE` to merge inconsistent values → e.g., *‘Crypto Currency’* → *‘Crypto’*.  
- **Country Names**: Fixed inconsistencies → e.g., *‘United States.’* → *‘United States’*.  
- **Date Format**: Converted text to `DATE` type using:  STR_TO_DATE(date_column, '%m/%d/%Y')
and updated schema with:  ALTER TABLE layoffs_staging MODIFY COLUMN date DATE;

---

### 3. Handling Null & Blank Values  
- Utilized a **self-join** to populate missing `industry` values from existing company records.  
- Ensured more complete representation of data.  

---

### 4. Final Cleanup  
- Removed rows where both `total_laid_off` and `percentage_laid_off` were **NULL**.  
- Dropped temporary helper column (`row_num`) used during de-duplication.  
- Produced a **fully cleaned table** ready for exploratory analysis.  

---

## 📂 Project Files  

- **`Data Cleaning.sql`** → All SQL queries used in the cleaning process.  
- **`layoffs.csv`** → Original raw dataset.  

---
