create database healthcare;

use healthcare;

-- Exploring dataSET
SELECT * FROM health;

-- DESCribing characteristics of TABLE.
DESC health;

-- Converting data types 
UPDATE health SET `Date of Admission` = STR_TO_DATE(`Date of Admission`, '%d-%m-%Y');
UPDATE health SET `Discharge Date` = STR_TO_DATE(`Discharge Date`, '%d-%m-%Y');

ALTER TABLE health 
    MODIFY COLUMN Name varchar(255),
    MODIFY COLUMN Gender varchar(20),
    MODIFY COLUMN `Blood Type` varchar(5),
    MODIFY COLUMN `Medical Condition` varchar(255),
    MODIFY COLUMN Doctor varchar(255),
    MODIFY COLUMN Hospital varchar(255),
    MODIFY COLUMN `Insurance Provider` varchar(255),
    MODIFY COLUMN `Admission Type` varchar(50),
    MODIFY COLUMN Medication varchar(255),
    MODIFY COLUMN `Date of Admission` DATE,
    MODIFY COLUMN `Discharge Date` DATE,
    MODIFY COLUMN `Test Results` varchar(255);

-- 1.  Counting Total Record in Database
-- Total 10000 rocords present
SELECT COUNT(*) FROM health;

-- 2. Finding maximum Age of patient admitted.
SELECT max(Age) FROM health;
-- Maximum Age is 85 years


-- 3. Finding Average Age of hospitalized patients.
SELECT ROUND(avg(Age), 0) FROM health;
-- Average Age is 51

-- 4. Calculating Patients Hospitalized Age-wise from Maximum to Minimum
SELECT Age, COUNT(Age) as Total
FROM health
GROUP BY Age
ORDER BY Age DESC;
-- Minimum Age is 18 total patients are 164 and maximum Age is 85 total patients are 123 

-- 5. Calculating Maximum COUNT of patients on basis of total patients hospitalized with respect to Age.
SELECT COUNT(Age) as max_patient, Age
FROM health
GROUP BY Age
ORDER BY max_patient DESC , Age DESC;
-- 59 years old patients has maximum COUNT 175

-- 6. Ranking Age on the number of patients Hospitalized   
SELECT Age, COUNT(Age) as Total, RANK() OVER( ORDER BY COUNT(Age)  DESC) as ranking
FROM health
GROUP BY Age
ORDER BY Total DESC; 

-- 7. Finding COUNT of Medical Condition of patients and lisitng it BY maximum no of patients.
SELECT 
    ROUND(avg(age),0) as Avg_Age, `Medical Condition`, 
    COUNT(`Medical Condition`) as Total_patient
FROM health 
GROUP BY `Medical Condition`
ORDER BY Total_patient DESC;
-- Asthma patients = 1708 are Higher than other and Diabetes patients = 1623 lower than other

-- 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.    
SELECT `Medical Condition`, Medication, count(Medication) as Total, 
    RANK() OVER(PARTITION BY `Medical Condition` ORDER BY COUNT(Medication) desc ) as Ranking
FROM health
GROUP BY `Medical Condition`, Medication
ORDER BY 1 ASC;


-- 9. Most preffered Insurance Provide  BY Patients Hospatilized
select `Insurance Provider`, count(`Insurance Provider`) as Total_Ins
from health 
GROUP BY `Insurance Provider`
ORDER BY Total_Ins desc;
-- Most preffered Insurance Provider is cigna with 2040 hospitalized patients.
    
-- 10. Finding out most preffered Hospital
SELECT Hospital, count(Hospital) as Total_Patient_Add
FROM health 
GROUP BY Hospital
ORDER BY Total_Patient_Add DESC;
-- Smith PLC is most preffered Hospital with 19 Addmision.

-- 11. Identifying AverAge Billing Amount BY Medical Condition.
SELECT `Medical Condition`, ROUND(AVG(Billing_Amount),2) as Avg_Bill
FROM health
GROUP BY `Medical Condition`
ORDER BY Avg_Bill DESC;

-- 12. Finding Billing Amount of patients admitted and number of days spent in respective hospital.
SELECT Name, Hospital, `Medical Condition`, Age, Medication, 
    SUM(ROUND(Billing_Amount,2)) OVER(Partition by Hospital ORDER BY Hospital DESC) AS Total_Amount,
    DATEDIFF(Discharge_Date, Admission_Date) as Total_Days
FROM health
ORDER BY Total_Amount DESC, Total_Days DESC;

-- 13. Finding  average Total number of days sepnt and Avg Bill by patient in an hospital for given medical condition
SELECT `Medical Condition`,
ROUND(AVG(Billing_Amount) ,2) as Average_Bill,
ROUND(AVG(DATEDIFF(Discharge_Date , Admission_Date) ), 0)as Avg_Days
from health
GROUP BY `Medical Condition`
ORDER BY Average_Bill DESC;

-- 14. Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with COUNT of days taken to get results to Normal
SELECT `Medical Condition`,Hospital, Doctor, 
ROUND(DATEDIFF(Discharge_Date, Admission_Date), 0) as Total_Days
FROM health
WHERE Test_Results = 'Normal'
ORDER BY Total_Days DESC;


-- 15. Calculate number of blood types of patients which lies betwwen Age 20 to 45
SELECT Blood_Type, count(Blood_Type) as Total_Patients
FROM health
WHERE Age BETWEEN 20 and 45
GROUP BY Blood_Type
ORDER BY Total_Patients DESC;
-- B- patient are higher than other with 501 patients and B+ patients are lower with  443 patients

-- 16. Find how many of patient are Universal Blood Donor and Universal Blood reciever
select DISTINCT
    (   SELECT COUNT(Blood_Type) 
        FROM health
        GROUP BY Blood_Type 
        HAVING Blood_Type = 'O-'
    ) as Universal_Blood_Donor,
    (
        SELECT count(Blood_Type)
        FROM health
        GROUP BY Blood_Type
        HAVING Blood_Type = 'AB+'
    ) as Universal_Blood_Reciver
FROM health;


-- 17. Create a procedure to find Universal Blood Donor to an Universal Blood Reciever, with priority to same hospital and afterwards other hospitals
DROP PROCEDURE Blood_Match;
DELIMITER $$

CREATE PROCEDURE Blood_Match(IN Pat_Name VARCHAR(255))
BEGIN
    SELECT 
        d.Name AS Donor_Name, 
        d.Blood_Type AS Donor_Blood, 
        d.Hospital AS Donor_Hospital,
        r.Name AS Recipient_Name, 
        r.Blood_Type AS Recipient_Blood, 
        r.Hospital AS Recipient_Hospital
    FROM health d
    JOIN health r 
        ON d.Blood_Type = 'O-' AND r.Blood_Type = 'AB+'
    WHERE r.Name LIKE CONCAT('%', Pat_Name, '%') 
      AND d.Age BETWEEN 20 AND 40
    ORDER BY (d.Hospital = r.Hospital) DESC; 
END$$

DELIMITER ;
CALL Blood_Match('Theresa Robertson'); 
/* 
- This stored procedure, Blood_Match, identifies potential life-saving matches by pairing Universal 
- Donors (O-) with Universal Recipients (AB+) from the health table. It filters for donors in the prime 
- age range of 20 to 40 and uses a specific patient name input to generate a targeted list of compatible candidates. 
- The logic prioritizes matches within the same hospital to optimize medical logistics while still providing cross-hospital 
- options for broader donor availability.
*/

-- 18. Provide a list of hospitals along with the COUNT of patients admitted in the year 2022 AND 2023?
SELECT Hospital, COUNT(Hospital) as Total_Pat
FROM health
where Admission_Date BETWEEN '2022-01-01' and '2023-12-31'
GROUP BY Hospital
ORDER BY Total_Pat DESC;

-- 19. Find the averAge, minimum and maximum billing amount for each insurance provider?
SELECT `Insurance Provider`,
    ROUND(AVG(Billing_Amount),2) as Avg_Bill, 
    MIN(Billing_Amount) as Min_Bill, 
    Max(Billing_Amount) as Max_Bill
FROM health
GROUP BY `Insurance Provider`
ORDER BY `Insurance Provider` ASC;

-- 20. Create a new COLUMN that categorizes patients as high, medium, or low risk based on their medical condition.
SELECT Name, Age, `Medical Condition`, Test_Results,
CASE 
    WHEN Test_Results = 'Normal' THEN  'Low Risk'
    WHEN Test_Results = 'Abnormal' THEN  'Medium Risk'
    WHEN Test_Results = 'Inconclusive' THEN  'High Risk'
END as Risk_Level
FROM health;


-- 21. Find the total patient of each blood GROUP
SELECT Blood_Type, count(Blood_Type) as total_patients
from health
GROUP BY Blood_Type
order by total_patients;

-- 22. Total amount BY the insurance provider 
SELECT `Insurance Provider`, ROUND(sum(Billing_Amount), 2) as Total_Amount
from health
GROUP BY `Insurance Provider`
ORDER BY 2 DESC;

