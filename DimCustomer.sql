SELECT
	CustomerID AS Customer_BK,
	LastName,
	FirstName,
	CONCAT(LastName, N', ', FirstName) AS LFName,
	CONCAT(FirstName, N' ', LastName) AS FLName,
	ISNULL(City, N'Unknown') AS City,
	ISNULL(StateName, N'Unknown') AS [State],
	ISNULL(RegionName, N'Unknown') AS Region,
	CASE Gender
	WHEN 'M' THEN N'Male'
	WHEN 'F' THEN N'Female'
	WHEN 'N' THEN N'Non-binary'
	ELSE N'Unknown'
	END AS Gender,
	CASE 
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) < 18 THEN N'Under 18'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) BETWEEN 18 AND 24 THEN N'18-24'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) BETWEEN 25 AND 34 THEN N'25-34'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) BETWEEN 35 AND 44 THEN N'35-44'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) BETWEEN 45 AND 54 THEN N'45-54'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) BETWEEN 55 AND 64 THEN N'55-64'
	WHEN DATEDIFF(YY, Birthdate, GETDATE()) >= 65 THEN N'65 and older'
	ELSE N'Unknown'
	END AS AgeGroup,
	CASE 
	WHEN YEAR(Birthdate) BETWEEN 1901 AND 1927 THEN N'Greatest Generation'
	WHEN YEAR(Birthdate) BETWEEN 1928 AND 1945 THEN N'Silent Genearation'
	WHEN YEAR(Birthdate) BETWEEN 1946 AND 1964 THEN N'Baby Boomer'
	WHEN YEAR(Birthdate) BETWEEN 1965 AND 1979 THEN N'Gen X'
	WHEN YEAR(Birthdate) BETWEEN 1980 AND 1996 THEN N'Millenial'
	WHEN YEAR(Birthdate) BETWEEN 1997 AND 2012 THEN N'Gen Z'
	WHEN YEAR(Birthdate) BETWEEN 2013 AND 2025 THEN N'Gen Alpha'
	ELSE N'Unknown'
	END AS Generation
FROM
	SilhouetteCollective.dbo.Customer c
LEFT JOIN
	SilhouetteCollective.dbo.[State] st
ON
	c.StateCode = st.StateCode
LEFT JOIN
	SilhouetteCollective.dbo.Region r
ON
	st.RegionCode = r.RegionCode;