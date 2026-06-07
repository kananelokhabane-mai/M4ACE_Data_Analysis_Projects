WITH CTE_Employee as 
(SELECT FirstName, LastName, Gender, Salary
, COUNT (Gender) OVER (PARTITION BY Gender) as TotalGender
, AVG (Salary) OVER (PARTITION BY Gender) as AvgSalary
FROM [SQL Training: Employee Data].dbo.EmployeeDemographics as emp
	join [SQL Training: Employee Data]..EmployeeSalary as sal
		on emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
select *
from CTE_Employee

create table #temp_Employee (
EmployeeID int,
JobTItle varchar (100),
Salary int
)
select * 
from #temp_Employee
insert into #temp_Employee values (
'1000', 'HR', '47000')
insert into #temp_Employee
select *
from [SQL Training: Employee Data]..EmployeeSalary

select *
from [SQL Training: Employee Data]..EmployeeSalary

Select EmployeeID, Salary, (Select AVG(Salary) from EmployeeSalary) As AllAvgSalary
From EmployeeSalary
