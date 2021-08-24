USE [master]

--alter database [DataProjectV1] set single_user with rollback immediate

DROP DATABASE IF EXISTS DataProjectV1
GO
DROP PROCEDURE IF EXISTS UnionDataComparison,ExceptDataComparison,IntersectDataComparison,HashDataComparison
go
DROP TABLE IF EXISTS PatientInfo_1
PRINT 'Welcome to Patient Pre Data Central'

DROP PROCEDURE IF EXISTS prePatientData

GO
CREATE DATABASE DataProjectV1
GO

USE DataProjectV1
GO

CREATE TABLE dbo.PatientInfo_1 (
	Patient_ID INT Primary key IDENTITY (1,1),
	LastName varchar(30) NOT NULL,
	FirstName varchar(30) NOT NULL,
	BirthDate DATE NOT NULL,
	PatientPhone# NUMERIC (10,0) NULL,
	Admit_Reason VARCHAR(100) NOT NULL
);

INSERT INTO PatientInfo_1
	(
	LastName,
	FirstName,
	BirthDate,
	PatientPhone#,
	Admit_Reason
	)
VALUES  
	('Uzumaki', 'Naruto','19991010', 3185555555,'Sore Throat'),
	('Otanashi', 'Saya', '18330804', 3181111111,'Sword Wound'),
	('Elric', 'Edward', '18990302',3182222222, 'Broken left leg and right arm'),
	('Takemichi', 'Hanagaki', '20000625',3183333333, 'Hand Stab Wound');

GO

--create stored procedure for Pre Data
CREATE PROCEDURE prePatientData
AS
BEGIN
    SELECT DISTINCT
	    p.Patient_ID,
		p.LastName,
		p.FirstName,
		p.BirthDate,
		p.PatientPhone#,
		p.Admit_Reason
	FROM 
		PatientInfo_1 p 
	ORDER BY 
		p.LastName DESC;

END;	
GO	 

USE [master]
--alter database [DataProjectV2] set single_user with rollback immediate

DROP DATABASE IF EXISTS DataProjectV2
GO

DROP TABLE IF EXISTS PatientInfo_2
PRINT 'Welcome to Patient Post Data Central'

DROP PROCEDURE IF EXISTS postPatientData

GO
CREATE DATABASE DataProjectV2
GO

USE DataProjectV2
GO

CREATE TABLE dbo.PatientInfo_2 (
	Patient_ID INT Primary key IDENTITY (1,1),
	LastName varchar(30) NOT NULL,
	FirstName varchar(30) NOT NULL,
	BirthDate DATE NOT NULL,
	PatientPhone# NUMERIC (10,0) NULL,
	Admit_Reason VARCHAR(100) NOT NULL
);

INSERT INTO PatientInfo_2
	(
	LastName,
	FirstName,
	BirthDate,
	PatientPhone#,
	Admit_Reason
	)
VALUES  
	('Uzumaki', 'Naruto','19991010', 3185555555,'Suspected Covid19'),
	('Otanashi', 'Saya', '18330804', 3181111112,'Sword Wound'),
	('Elric', 'Al', '18990302',3182222222, 'Broken left leg and right arm'),
	('Takemichi', 'Hanagaki', '20000625',3183333333, 'Hand Stab Wound');

GO
--create stored procedure for Post Data


CREATE PROCEDURE postPatientData
AS
BEGIN
    SELECT DISTINCT
	    p.Patient_ID,
		p.LastName,
		p.FirstName,
		p.BirthDate,
		p.PatientPhone#,
		p.Admit_Reason
	FROM 
		PatientInfo_2 p 
	ORDER BY 
		p.LastName DESC;

END;	
GO	  

--UNION COMPARISON
CREATE PROCEDURE UnionDataComparison
AS
BEGIN
	SELECT
		p1.Patient_ID,
		p1.LastName,
		p1.FirstName,
		p1.BirthDate,
		p1.PatientPhone#,
		p1.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p1.Patient_ID AS varchar(100)) + '|' +
					CAST(p1.LastName AS varchar(100)) + '|' +
					CAST(p1.FirstName AS varchar(100)) + '|' +
					CAST(p1.BirthDate AS varchar(100)) + '|' +
					CAST(p1.PatientPhone# AS varchar(100)) + '|' +
					CAST(p1.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue
			FROM 
			DataProjectV1.dbo.PatientInfo_1 p1
	UNION
	SELECT
		p2.Patient_ID,
		p2.LastName,
		p2.FirstName,
		p2.BirthDate,
		p2.PatientPhone#,
		p2.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p2.Patient_ID AS varchar(100)) + '|' +
					CAST(p2.LastName AS varchar(100)) + '|' +
					CAST(p2.FirstName AS varchar(100)) + '|' +
					CAST(p2.BirthDate AS varchar(100)) + '|' +
					CAST(p2.PatientPhone# AS varchar(100)) + '|' +
					CAST(p2.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue 
	FROM 
		DataProjectV2.dbo.PatientInfo_2 p2
END;

GO
--EXCEPT COMPARISON
CREATE PROCEDURE ExceptDataComparison
AS
BEGIN
	SELECT
		p1.Patient_ID,
		p1.LastName,
		p1.FirstName,
		p1.BirthDate,
		p1.PatientPhone#,
		p1.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p1.Patient_ID AS varchar(100)) + '|' +
					CAST(p1.LastName AS varchar(100)) + '|' +
					CAST(p1.FirstName AS varchar(100)) + '|' +
					CAST(p1.BirthDate AS varchar(100)) + '|' +
					CAST(p1.PatientPhone# AS varchar(100)) + '|' +
					CAST(p1.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue
		 FROM 
		 DataProjectV1.dbo.PatientInfo_1 p1
	EXCEPT	
	SELECT
		p2.Patient_ID,
		p2.LastName,
		p2.FirstName,
		p2.BirthDate,
		p2.PatientPhone#,
		p2.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p2.Patient_ID AS varchar(100)) + '|' +
					CAST(p2.LastName AS varchar(100)) + '|' +
					CAST(p2.FirstName AS varchar(100)) + '|' +
					CAST(p2.BirthDate AS varchar(100)) + '|' +
					CAST(p2.PatientPhone# AS varchar(100)) + '|' +
					CAST(p2.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue 
	FROM 
		DataProjectV2.dbo.PatientInfo_2 p2
END;

GO
--INTERSECT COMPARISON
CREATE PROCEDURE IntersectDataComparison
AS
BEGIN
	SELECT
		p1.Patient_ID,
		p1.LastName,
		p1.FirstName,
		p1.BirthDate,
		p1.PatientPhone#,
		p1.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p1.Patient_ID AS varchar(100)) + '|' +
					CAST(p1.LastName AS varchar(100)) + '|' +
					CAST(p1.FirstName AS varchar(100)) + '|' +
					CAST(p1.BirthDate AS varchar(100)) + '|' +
					CAST(p1.PatientPhone# AS varchar(100)) + '|' +
					CAST(p1.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue
		 FROM 
		 DataProjectV1.dbo.PatientInfo_1 p1
	INTERSECT
	SELECT
		p2.Patient_ID,
		p2.LastName,
		p2.FirstName,
		p2.BirthDate,
		p2.PatientPhone#,
		p2.Admit_Reason,
		HASHBYTES('SHA2_256', +
					CAST(p2.Patient_ID AS varchar(100)) + '|' +
					CAST(p2.LastName AS varchar(100)) + '|' +
					CAST(p2.FirstName AS varchar(100)) + '|' +
					CAST(p2.BirthDate AS varchar(100)) + '|' +
					CAST(p2.PatientPhone# AS varchar(100)) + '|' +
					CAST(p2.Admit_Reason AS varchar(100)) + '|' 
		) AS HashValue 
	FROM 
		DataProjectV2.dbo.PatientInfo_2 p2
END;
--HASH MAP COMPARISON
Go
CREATE PROCEDURE HashDataComparison
AS
BEGIN
	SELECT HASHBYTES('SHA2_256', +
				CAST(p1.Patient_ID AS varchar(100)) + '|' +
				CAST(p1.LastName AS varchar(100)) + '|' +
				CAST(p1.FirstName AS varchar(100)) + '|' +
				CAST(p1.BirthDate AS varchar(100)) + '|' +
				CAST(p1.PatientPhone# AS varchar(100)) + '|' +
				CAST(p1.Admit_Reason AS varchar(100)) + '|' 
					) AS HashValue
	FROM 
		DataProjectV1.dbo.PatientInfo_1 p1
	WHERE
		p1.Patient_ID = 1 OR
		p1.Patient_ID = 2 OR
		p1.Patient_ID = 3 OR
		p1.Patient_ID = 4
	INTERSECT 
	SELECT
	HASHBYTES('SHA2_256', +
				CAST(p2.Patient_ID AS varchar(100)) + '|' +
				CAST(p2.LastName AS varchar(100)) + '|' +
				CAST(p2.FirstName AS varchar(100)) + '|' +
				CAST(p2.BirthDate AS varchar(100)) + '|' +
				CAST(p2.PatientPhone# AS varchar(100)) + '|' +
				CAST(p2.Admit_Reason AS varchar(100)) + '|' 
	)  AS HashValue 
	FROM 
		DataProjectV2.dbo.PatientInfo_2 p2
	WHERE
		p2.Patient_ID = 1 OR
		p2.Patient_ID = 2 OR
		p2.Patient_ID = 3 OR
		p2.Patient_ID = 4
END;

