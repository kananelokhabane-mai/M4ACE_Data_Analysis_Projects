--SELECT TOP 4 *
--FROM EmployeeDemographics

--SELECT DISTINCT (FirstName)
--FROM EmployeeDemographics

--SELECT * (* selects the whole table)
--FROM EmployeeDemographics

--SELECT COUNT (EmployeeID): counts ll non-null values in a column
--FROM EmployeeDemographics

--SELECT COUNT (EmployeeID) AS EmployeeCount: "AS" gives the column a name
--FROM EmployeeDemographics

--SELECT MAX (Salary) AS HighestSalary
--FROM EmployeeSalary

--SELECT MIN (Salary) AS LowestSalary
--FROM EmployeeSalary

--SELECT AVG (Salary) AS AvgSalary
--From EmployeeSalary

--SELECT *
--FROM [SQL Training Week 1: Employee Data].dbo.EmployeeDemographics

--SELECT *
--FROM EmployeeDemographics
--Where LastName = 'Scott'

--SELECT *
--FROM EmployeeDemographics
--WHERE LastName <> 'Scott'

SELECT *
FROM EmployeeDemographics
WHERE Age >= 30 AND Gender = 'Female'

