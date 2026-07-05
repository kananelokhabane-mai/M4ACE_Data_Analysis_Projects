Select * 
From [dbo].[HR Data]

Alter table [dbo].[HR Data]
Add age int 
-- added a new column
Update [dbo].[HR Data]
Set age = DATEDIFF(year,[birth_date], GETDATE())

Update [dbo].[HR Data]
Set term_date = 'Active'
Where term_date is NULL OR term_date = ''
-- inaccurate, some term_dates are a time in the future, employee is still active
Update [dbo].[HR Data]
Set term_date = NULL OR term_date = '' OR term_date = 'NULL'
Where term_date = 'Active'
-- used force-undo
UPDATE [dbo].[HR Data]
SET term_date = NULL
WHERE term_date = '' OR term_date = 'NULL'

Select EmployeeID, first_name,last_name,term_date as term_status,
--status if active today (2026-06-21)
Case 
When term_date is NULL or term_date = '' then 'Active'
When TRY_CONVERT(DATE, LEFT(term_date, 10)) > getdate() then 'Active (Future contract)'
Else 'Terminated'
End as Current_status,
-- tenure based on current status
Case 
When term_date is NULL or TRY_CONVERT(DATE, LEFT(term_date, 10)) > getdate()
  Then DATEDIFF(YEAR, TRY_CONVERT(DATE, hire_date), GETDATE())
 Else DATEDIFF(YEAR, TRY_CONVERT(DATE, hire_date), TRY_CONVERT(DATE, LEFT(term_date, 10)))
 End as years_of_service
From [dbo].[HR Data]

With EmployeeData_CTE as (
 Select [EmployeeID], [first_name],[last_name],[department], [jobtitle],
  Case 
When term_date is NULL or term_date = '' then 'Active'
When TRY_CONVERT(DATE, LEFT(term_date, 10)) > getdate() then 'Active (Future contract)'
Else 'Terminated'
End as Current_status,
-- tenure logic
Case
 When [term_date] is NULL
    Or [term_date] = ''
    Or [term_date] = 'NULL'
    Or TRY_CONVERT(Date, Left([term_date], 10)) > GETDATE()
    Then DATEDIFF(year, TRY_CONVERT(Date, [hire_date]), GETDATE())
 Else DATEDIFF(year, TRY_CONVERT(date, [hire_date]), TRY_CONVERT(date, left([term_date],10)))
End as years_of_service
From [dbo].[HR Data]),
-- assigning ranks
EmployeeRanks_CTE as (
  Select [EmployeeID], 
         ([first_name] + ' ' + [last_name]) as full_name,
         [department],
         [jobtitle],
         years_of_service,
         Current_status,
  -- rank employees inside their own dept.
  Dense_rank() Over (partition by [department] order by years_of_service Desc)
      as seniority_rank
From EmployeeData_CTE
 Where Current_status like 'Active%')   -- to rank only active employees--)
 -- to get only top 3
 Select [department], 
        seniority_rank,
        full_name,
        [jobtitle],
        years_of_service,
        Current_status
    From EmployeeRanks_CTE
    Where seniority_rank <= 3
    Order by [department], seniority_rank

    --calculating employee turnover
    Select [department],
      Count (*) as total_hires,
      SUM (CASE 
            WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 0
            WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 0
            ELSE 1 
        END) AS total_terminations,
  ROUND(
        (SUM(CASE 
                WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 0
                WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 0
                ELSE 1 
             END) * 100.0) / COUNT (*), 
        2
 ) AS turnover_rate_percentage
    From [dbo].[HR Data]
    Group by [department]
    Order by turnover_rate_percentage desc

    -- calculating gender distribution in the company
    SELECT 
    [department],
    -- Total employess in the department
    COUNT(*) AS total_employees,
    SUM(
       CASE 
       WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    ROUND((SUM(CASE WHEN gender = 'Male' THEN 1.0 ELSE 0.0 END) * 100.0) / COUNT(*), 2) AS male_percentage,
    SUM(
       CASE 
       WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
    ROUND((SUM(CASE WHEN gender = 'Female' THEN 1.0 ELSE 0.0 END) * 100.0) / COUNT(*), 2) AS female_percentage
FROM [dbo].[HR Data]
GROUP BY [department]
ORDER BY [department] desc;

-- calculating the race distribution in the company
Select [department],
    ISNULL([race], 'Not Specified') AS race_demographic,
    COUNT(*) AS total_count,
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) 
 FROM [dbo].[HR Data]), 
        2
    ) AS company_percentage
FROM [dbo].[HR Data]
GROUP BY [department],[race]
ORDER BY total_count DESC
-- race by department
SELECT 
    [department],
    ISNULL([race], 'Not Specified') AS race_demographic,
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER(PARTITION BY [department]), 2) AS dept_percentage
FROM [dbo].[HR Data]
GROUP BY [department], [race]
ORDER BY [department] ASC, total_count DESC;

-- Analysing department
SELECT [department],
  COUNT(*) AS lifetime_hires,
    SUM(CASE 
            WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
            WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
            ELSE 0 
        END) AS active_headcount,
    ROUND(
        (SUM(CASE 
                WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
                WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
                ELSE 0 
             END) * 100.0) / 
        (SELECT COUNT(*) FROM [dbo].[HR Data] 
         WHERE term_date IS NULL OR term_date = '' OR term_date = 'NULL' 
            OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE()), 
        2
    ) AS active_workforce_share_percentage

FROM [dbo].[HR Data]
GROUP BY [department]
ORDER BY active_headcount DESC;


-- analysing job positions in the company
SELECT [jobtitle],
    SUM(CASE 
            WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
            WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
            ELSE 0 
        END) AS active_headcount
FROM [dbo].[HR Data]
GROUP BY [jobtitle]
ORDER BY active_headcount DESC;

SELECT 
    CASE 
        WHEN [jobtitle] LIKE '%Chief%' OR [jobtitle] LIKE '%VP%' OR [jobtitle] LIKE '%Vice President%' OR [jobtitle] LIKE '%Director%' THEN 'Executive Leadership'
        WHEN [jobtitle] LIKE '%Manager%' OR [jobtitle] LIKE '%Supervisor%' OR [jobtitle] LIKE '%Lead%' THEN 'Middle Management'
        ELSE 'Individual Contributors / Staff'
    END AS organizational_tier, 
    SUM(CASE 
            WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
            WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
            ELSE 0 
        END) AS active_headcount,     
    ROUND(
        (SUM(CASE 
                WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
                WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
                ELSE 0 
             END) * 100.0) / 
        (SELECT COUNT(*) FROM [dbo].[HR Data] 
         WHERE term_date IS NULL OR term_date = '' OR term_date = 'NULL' 
            OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE()), 
        2
    ) AS tier_percentage
FROM [dbo].[HR Data]
GROUP BY 
    CASE 
        WHEN [jobtitle] LIKE '%Chief%' OR [jobtitle] LIKE '%VP%' OR [jobtitle] LIKE '%Vice President%' OR [jobtitle] LIKE '%Director%' THEN 'Executive Leadership'
        WHEN [jobtitle] LIKE '%Manager%' OR [jobtitle] LIKE '%Supervisor%' OR [jobtitle] LIKE '%Lead%' THEN 'Middle Management'
        ELSE 'Individual Contributors / Staff'
    END
ORDER BY active_headcount;


-- analysing location
SELECT [department],
    SUM(CASE 
            WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' THEN 1
            WHEN TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1
            ELSE 0 
        END) AS active_headcount,
    SUM(CASE 
            WHEN (term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE())
                 AND [location] LIKE '%Headquarter%' THEN 1 
            ELSE 0 
        END) AS hq_count,
    ROUND(
        (SUM(CASE WHEN (term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE()) AND [location] LIKE '%Headquarter%' THEN 1.0 ELSE 0.0 END) * 100.0) / 
        NULLIF(SUM(CASE WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1 ELSE 0 END), 0),
        2
    ) AS hq_percentage,
    SUM(CASE 
            WHEN (term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE())
                 AND [location] LIKE '%Remote%' THEN 1 
            ELSE 0 
        END) AS remote_count,
    ROUND(
        (SUM(CASE WHEN (term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE()) AND [location] LIKE '%Remote%' THEN 1.0 ELSE 0.0 END) * 100.0) / 
        NULLIF(SUM(CASE WHEN term_date IS NULL OR term_date = '' OR term_date = 'NULL' OR TRY_CONVERT(DATE, LEFT(term_date, 10)) > GETDATE() THEN 1 ELSE 0 END), 0),
        2
    ) AS remote_percentage
FROM [dbo].[HR Data]
GROUP BY [department]
ORDER BY remote_percentage DESC