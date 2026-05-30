--Select *
--From dbo.EmployeeDemographics

--Select *
--From dbo.EmployeeDemographics
--Join [SQL Training: Employee Data].dbo.EmployeeSalary
--On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Select *
--From dbo.EmployeeDemographics
--Full Outer Join [SQL Training: Employee Data].dbo.EmployeeSalary
--On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--Select EmployeeDemographics.EmployeeID, FirstName, LastName, Age, JobTitle,Salary
--From dbo.EmployeeDemographics
--Inner Join [SQL Training: Employee Data].dbo.EmployeeSalary
--On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Select EmployeeDemographics.EmployeeID, FirstName, LastName, Age, JobTitle,Salary
--From dbo.EmployeeDemographics
--Inner Join [SQL Training: Employee Data].dbo.EmployeeSalary
--On EmployeeDemographics.EmployeeID = EmployeeSalary.Employee

--Select *
--From [SQL Training: Employee Data].dbo.EmployeeDemographics     
--Union All       (UNION removes duplicates, UNION ALL doesn't remove duplicates)
--Select *
--From [SQL Training: Employee Data].dbo.WareHouseemployeeDemographics

--SELECT FirstName, LastName, Age,
--Case
--when Age > 30 then 'Adult'
--when Age BETWEEN 26 AND 30 then 'Young Adult'
--ELSE 'Young'
--end
--From [SQL Training: Employee Data].dbo.EmployeeDemographics
--where Age is not null
--order by age

Select *
From [SQL Training: Employee Data].dbo.EmployeeDemographics     

Update [SQL Training: Employee Data].dbo.EmployeeDemographics
set age = 23
where FirstName = 'Darryl' And LastName = 'Philbin'

--Update [SQL Training: Employee Data].dbo.EmployeeDemographics
--set EmployeeID = 1012, age = 25
--where FirstName = 'Holly' And LastName = 'Flax'
 
