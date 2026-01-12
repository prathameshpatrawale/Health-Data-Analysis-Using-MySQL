
# Healthcare Data Analysis (SQL)

## Project Overview
This project involves a comprehensive analysis of a healthcare dataset using MySQL. The goal was to transform raw healthcare records into actionable insights, focusing on patient demographics, medical conditions, hospital performance, and insurance billing.

The project demonstrates advanced SQL techniques including Data Cleaning, Window Functions, Stored Procedures, and CTEs.



## Tools Used
**Database:**  
MySQL

**Concepts:**  
- Data Normalization  
- Aggregations  
- Table Joins  
- Stored Procedures  
- CASE Statements  



## Database Schema
The dataset contains information on **10,000 patient records** with the following key attributes:

- **Patient Info:** Name, Age, Gender, Blood Type  
- **Medical Info:** Medical Condition, Doctor, Hospital, Medication, Test Results  
- **Logistics:** Date of Admission, Discharge Date, Admission Type, Insurance Provider  
- **Financials:** Billing Amount  



## Key Insights & Queries

### 1. Data Cleaning & Transformation
- Standardized date formats using `STR_TO_DATE` for Date of Admission and Discharge Date.
- Modified column data types using `ALTER TABLE` to ensure data integrity and optimized storage.

### 2. Patient Demographics
- **Average Age:** The average hospitalized patient is 51 years old.
- **Age Range:** Patient ages range from 18 to 85.
- **Peak Admission:** 59-year-olds represent the highest frequency of admissions (175 patients).

### 3. Medical & Hospital Analysis
- **Conditions:**  
  Asthma is the most common condition (1,708 patients), while Diabetes has the lowest frequency in this dataset.
- **Top Hospital:**  
  Smith PLC emerged as the most preferred hospital with the highest admission count.
- **Risk Categorization:**  
  Created a logic-based risk model:
  - Normal Results → Low Risk  
  - Abnormal Results → Medium Risk  
  - Inconclusive Results → High Risk  

### 4. Financial & Insurance Metrics
- **Top Provider:**  
  - Cigna is the most preferred insurance provider with over 2,040 patients.
  - Analyzed average, minimum, and maximum billing amounts across all insurance providers to identify cost variances.

### 5. Specialized Logic
#### Blood Donor Matching
Developed a stored procedure called `Blood_Match` to automate the identification of life-saving matches:
- Pairs universal donors (O-) with universal recipients (AB+).
- Filters donors in the prime age range (20–40).
- Prioritizes matches within the same hospital to reduce logistics time.



## How to Use
1. Clone this repository.
2. Import the dataset into your MySQL environment.
3. Run the `healthcare_analysis.sql` file to create the database and execute the analytical queries.



## Future Enhancements
- Integration with Power BI or Tableau for visual dashboards.
- Trend analysis for seasonal admissions.
- Predictive modeling for patient stay duration using Python.
