USE HospitalClean;
SELECT* from Admissions;
SELECT COUNT(*) AS total_Admission
FROM Admissions;

SELECT WardID, COUNT(*) AS Admission_per_ward 
FROM Admissions
	GROUP BY WardID
	HAVING COUNT(*) > 150 
	ORDER BY Admission_per_ward DESC;
SELECT* FROM Admissions;
SELECT* FROM Patients;

SELECT* 
FROM Patients
WHERE Gender = 'F' AND DateOfBirth < '1960-01-01';

SELECT* 
FROM Admissions
WHERE Outcome IN ('Deceased', 'Absconded');

SELECT*
FROM Admissions
WHERE DischargeDate IS NULL;

SELECT* 
FROM Patients
WHERE State = 'Ebonyi' AND LastName LIKE 'O%';

SELECT AdmissionID, DATEDIFF(day, AdmissionDate, DischargeDate) AS LengthOfStay
FROM Admissions
WHERE DischargeDate IS NOT NULL;

SELECT AVG(DATEDIFF(day, AdmissionDate, DischargeDate)) AS LengthOfStay
FROM Admissions
WHERE DischargeDate IS NOT NULL;

SELECT DiagnosisID, COUNT(*) AS Admission_per_diagnosis
FROM Admissions
	GROUP BY DiagnosisID
	ORDER BY Admission_per_diagnosis DESC;

SELECT* FROM Admissions;

SELECT MIN(AdmissionDate)AS EarliestAdmission, MAX(AdmissionDate) AS LatestAdmission
FROM Admissions;

SELECT DiagnosisID, COUNT(*) AS Diagnosis_Max_Admission
FROM Admissions
	GROUP BY DiagnosisID
	HAVING COUNT(*) >80
	ORDER BY Diagnosis_Max_Admission DESC;


SELECT a.AdmissionID, a.AdmissionDate, w.WardName
FROM Admissions a
	INNER JOIN Wards w
	ON a.WardID = w.WardID;

SELECT* FROM Diagnoses


SELECT a.AdmissionID, a.AdmissionDate, s.FullName, d.DiagnosisName
FROM Admissions a
	INNER JOIN Staff s
		ON a.StaffID = s.StaffID
	INNER JOIN Diagnoses d
		ON a.DiagnosisID = d.DiagnosisID;


SELECT p.PatientID, p.FirstName, a.AdmissionID
FROM Patients p
	LEFT JOIN Admissions a
	ON p.PatientID = a.PatientID
WHERE a.AdmissionID IS NULL;


SELECT w.WardName,
	COUNT(a.AdmissionID) AS Admission_per_ward
FROM Wards w
	LEFT JOIN Admissions a
	ON w.WardID = a.AdmissionID
	GROUP BY w.wardName;

SELECT* FROM Admissions;


SELECT d.DiagnosisName, a.AdmissionID
FROM Diagnoses d
LEFT JOIN Admissions a
ON d.DiagnosisID = a.DiagnosisID
WHERE a.AdmissionID IS NULL;


SELECT 
		a1.PatientID,
		p.FirstName,
		p.LastName, 
		a1.AdmissionDate AS Date_firstAdmission,
		a2.AdmissionDate AS Date_SecondAdmission,
		a1.AdmissionID AS FirstAdmission, 
		a2.AdmissionID AS SecondAdmission
FROM Admissions a1
	JOIN Admissions a2 
	ON a1.PatientID = a2.PatientID
	INNER JOIN Patients p
	ON p.PatientID = a1.PatientID
WHERE a1.AdmissionID < a2.AdmissionID;


SELECT AdmissionID, DATEDIFF(day, AdmissionDate, DischargeDate) AS LenghtOfStay
FROM Admissions
WHERE DATEDIFF(day, AdmissionDate, DischargeDate) > (
	SELECT AVG(DATEDIFF(day, AdmissionDate, DischargeDate))
	FROM Admissions
	);
SELECT* FROM Wards;


SELECT FirstName, LastName
FROM Patients
WHERE PatientID IN (
	SELECT a.PatientID
	FROM Admissions a
		INNER JOIN Wards w
		ON a.WardID = w.WardID
	WHERE w.WardName = 'ICU'
)
SELECT p.PatientID, p.FirstName, p.LastName,
	(SELECT MAX(a.AdmissionDate)
	FROM Admissions a
	WHERE a.PatientID = p.PatientID) AS MostRecentAdmission
FROM Patients p;


SELECT p.PatientID, p.FirstName, p.LastName
FROM Patients p
WHERE (
	SELECT a.Outcome
	FROM Admissions a
	WHERE a.PatientID = p.PatientID
	AND a.AdmissionDate = (
		SELECT MAX(a2.AdmissionDate)
		FROM Admissions a2
		WHERE a2.PatientID = p.PatientId
		)
) = 'Deceased';

-----DATE FUNCTIONS-----
SELECT w.WardID, w.WardName,
	AVG(DATEDIFF(day, a.AdmissionDate, a.DischargeDate)) AS WardAvgStay
FROM Admissions a
INNER JOIN Wards w ON a.WardID = w.WardID
WHERE a.DischargeDate IS NOT NULL
GROUP BY w.WardID, w.WardName
HAVING AVG(DATEDIFF(day, a.AdmissionDate, a.DischargeDate)) < (
	SELECT AVG(DATEDIFF(day, AdmissionDate, DischargeDate))
	FROM Admissions
	WHERE DischargeDate IS NOT NULL
);

-----STRING FUNCTIONS-----
SELECT PatientID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Patients;
SELECT PatientID, PhoneNumber
FROM Patients
WHERE PhoneNumber LIKE '%00'
SELECT PatientID, PhoneNumber
FROM Patients
WHERE RIGHT(PhoneNumber, 2) = '00';

-----STRING FUNCTIONS-----
SELECT PatientID, PhoneNumber,
	REPLACE(PhoneNumber, '080', '234-80') AS UpdatedPhoneNumber
FROM Patients;
SELECT PatientID, PhoneNumber,
	'234-' + RIGHT(PhoneNumber, 10)AS UpdatedPhoneNumber
FROM Patients;
SELECT PatientID,
	CONCAT(FirstName, ' ', LastName) AS FullName,
	CHARINDEX(' ', CONCAT(FirstName,' ', LastName)) AS SpacePosition
FROM Patients;


--------DATE FUNCTIONS--------
SELECT* FROM Patients;
SELECT PatientID, FirstName, LastName, DateOfBirth,
	DATEDIFF(year, DateOfBirth, GETDATE()) AS Age
FROM Patients;
SELECT PatientID, FirstName, LastName, DateOfBirth,
	DATEDIFF(year, DateOfBirth, GETDATE()) -
	CASE
		WHEN DATEADD(year, DATEDIFF(year, DateOfBirth, GETDATE()), DateOfBirth) > GETDATE()
		THEN 1
		ELSE 0
	END AS TrueAge
FROM Patients;

SELECT YEAR(AdmissionDate) AS AdmissionYear,
	COUNT(*) AS TotalAdmissions
FROM Admissions
GROUP BY YEAR(AdmissionDate)
ORDER BY AdmissionYear;
select* from Admissions;

SELECT YEAR(HireDate) AS HireYear,
	COUNT (*) AS TotalHire
FROM Staff
GROUP BY YEAR(HireDate)
ORDER BY HireYear;

-----DATE FUNCTIONS, AGGREGATE FUNCTIONS-----
SELECT MONTH(AdmissionDate) AS AdmissionMonth,
	COUNT(*) AS TotalAdmission_PerMonth
FROM Admissions
GROUP BY MONTH(AdmissionDate)
ORDER BY AdmissionMonth
SELECT AdmissionID, AdmissionDate,
	DATEADD(day, 7, AdmissionDate) AS AdmissionAfter_7 
FROM Admissions;

--------WINDOW FUNCTIONS, AGGREGATE FUNCTIONS--------
SELECT PatientID, AdmissionID,AdmissionDate,
	ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY AdmissionDate) AS AdmissionNumber
FROM Admissions;
SELECT WardID, COUNT(*) AS TotalAdmissions,
	DENSE_RANK() OVER (ORDER BY COUNT (*) DESC) AS WardRank
FROM Admissions
GROUP BY WardID;
SELECT MONTH(AdmissionDate) AS AdmissionMonth, COUNT(*) AS MonthlyAdmissions,
	SUM(COUNT(*)) OVER(ORDER BY MONTH(AdmissionDate)) AS RunningTotal
FROM Admissions
WHERE YEAR(AdmissionDate) = 2024
GROUP BY MONTH(AdmissionDate)
ORDER BY AdmissionMonth;

-----CTEs,WINDOW FUNCTIONS (LAG),DATE FUNCTIONS-----
SELECT PatientID, AdmissionID, AdmissionDate,
	DATEDIFF(day,
	LAG(AdmissionDate) OVER (PARTITION BY PatientID	ORDER BY AdmissionDate),
	AdmissionDate) AS DaysSincePreviousAdmissionDate
FROM Admissions;

--------CTEs, CONCAT,AGGREGATE FUNCTIONS--------
WITH PatientName AS (
	SELECT PatientID, CONCAT(FirstName, ' ', LastName) AS FullName
	FROM Patients
)
SELECT PatientID, FullName, CHARINDEX(' ', FullName) AS SpacePosition
FROM PatientName;
WITH AdmissionCounts AS (
	SELECT PatientID, COUNT(*) AS TotalAdmissions
	FROM Admissions
	GROUP BY PatientID
)
SELECT PatientID, TotalAdmissions
FROM AdmissionCounts
WHERE TotalAdmissions > 1;

------CTEs-----
WITH RankedAdmissions AS (
	SELECT PatientID, Outcome,
		ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY AdmissionDate DESC) AS RecencyRank
		FROM Admissions
)
SELECT PatientID, RecencyRank
FROM RankedAdmissions
WHERE RecencyRank = 1 AND OUTCOME = 'Deceased';

--------SUBQUERY--------
SELECT p.PatientID, p.FirstName, p.LastName
FROM Patients p
WHERE(
	SELECT a.Outcome
	FROM Admissions a
	WHERE a.PatientID = p.PatientID
	AND a.AdmissionDate = (
		SELECT MAX(a2.AdmissionDate)
		FROM Admissions a2
		WHERE a2.PatientId = p.PatientID
		)
) = 'Deceased';

--------CTE, CONCATS, INNER JOIN--------
WITH RankedAdmissions AS (
	SELECT a.PatientID,
		CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
		a.Outcome,
		ROW_NUMBER() OVER(PARTITION BY a.PatientID ORDER BY a.AdmissionDate DESC) AS RecencyRank
	FROM Admissions a
	INNER JOIN Patients p ON a.PatientID = p.PatientID
)
SELECT PatientID, FullName
FROM RankedAdmissions
WHERE RecencyRank = 1 AND Outcome = 'Deceased';

-----CTEs, JOIN-----
WITH RankedAdmissions AS (
	SELECT a.PatientID, p.FirstName, p.LastName, a.Outcome,
		ROW_NUMBER() OVER(PARTITION BY a.PatientID ORDER BY a.AdmissionDate DESC) AS RecencyRank
	FROM Admissions a
	INNER JOIN Patients p ON a.PatientId = p.PatientID
	)
SELECT PatientID, FirstName, LastName
FROM RankedAdmissions
WHERE RecencyRank = 1 AND Outcome = 'Deceased';

------CTEs, DATE FUNCTIONS-----
WITH WardStats AS (
	SELECT w.WardID, w.WardName,
		AVG(CAST(DATEDIFF(day, a.AdmissionDate, a.DischargeDate) AS DECIMAL (10, 2))) AS WardAvgStay
	FROM Admissions a
	INNER JOIN Wards w ON a.WardID = w.WardID
	WHERE a.DischargeDate IS NOT NULL
	GROUP BY w.WardID, w.WardName
),
HospitalStats AS (
	SELECT AVG(CAST(DATEDIFF(day, AdmissionDate, DischargeDate) AS DECIMAL (10, 2))) AS HospitalAvgStay
	FROM Admissions
	WHERE DischargeDate IS NOT NULL
)
SELECT WardStats.WardID, WardStats.WardName, WardStats.WardAvgStay, HospitalStats.HospitalAvgStay
FROM WardStats, HospitalStats
WHERE WardStats.WardAvgStay > HospitalStats.HospitalAvgStay;