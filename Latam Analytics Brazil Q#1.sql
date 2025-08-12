

-- Objective: Extract LATAM analytics data for GP (Gross Profit) and Load Count, 
-- summarized at Service Type and Transaction Date levels for Brazil operations 
-- after Navis Go-Live (July 2025). This aligns load data with LATAM reporting standards.
-- created by: CAMAJUL

WITH LOAD_DETAILS AS (
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
LOADS.LoadNum
,LOADS.LoadnumGF
,LOADS.Load
,LOADS.[Net Revenue] AS "GP"-- GP for LATAM analytics
 -- Lets add equivalent Services to be alignd with Latam Analytics
,CASE
    WHEN Services LIKE '%OI%' THEN 'Ocean Import'
    WHEN Services LIKE '%OX%' THEN 'Ocean Export'
    WHEN Services LIKE '%CUS%' THEN 'Customs'
    WHEN Services LIKE '%AX%' THEN 'Air Export'
    WHEN Services LIKE '%AI%' THEN 'Air Import'
    WHEN Services LIKE '%TR%' THEN 'Trucking'
    WHEN Services LIKE '%MS%' THEN 'Managed Services'
    ELSE 'Others'
END AS "Service Type"

--,LOADS.Ccode_
,DATEFROMPARTS(LOADS.Year, LOADS.Month, 1) AS "Transaction Date" 


  FROM [csacp].[dbo].[vw_LoadSummaryINTL] AS "LOADS"
  WHERE LOADS.Country='Brasil'
  -- Only loads with GP recognized after Navis Go live (7/1/2025)
  AND DATEFROMPARTS(LOADS.Year, LOADS.Month, 1)='2025-07-01' -- KEY FILTER TO CALCULATE TIMEFRAME MEASUREMENT
  --AND LOADS.LoadNum='521016347'
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  )
  SELECT 
  LD.[Transaction Date]
  --,LD.[Service Type]
  ,SUM(LD.GP) as "GP"
  --,SUM(LD.Load) as "Load Count"
  ,COALESCE(SUM(LD.Load),0) as "Load Count"
  FROM LOAD_DETAILS LD
  
  GROUP BY LD.[Transaction Date]
  --,LD.[Service Type]
  ORDER BY LD.[Transaction Date] DESC
  ;
  -- Search Branchcode available on on premises server

WITH PARTY_CODE AS (
SELECT 
	CS.PartyCode
	  ,CS.[BranchCode]
	  --,CS.[BranchCode]
	  ,BC.RollupBranchName
  FROM [csacp].[dbo].[vw_Customer] CS
  LEFT JOIN [csacp].[dbo].[vw_Customers]  CSS ON CS.[PartyCode] = CSS.[CompanyCode]
  LEFT JOIN [csacp].[dbo].[vw_Branch] BC ON BC.BranchPartyCode = CS.BranchCode
  WHERE BC.RollupBranchName = 'Brazil GF'
  )
  SELECT 
	--LOADS.LoadNum,
	SUM(LOADS.Load) AS "Load Count"
	,SUM(LOADS.[Net Revenue]) AS "GP" -- GP for LATAM analytics
	,PC.BranchCode
	,DATEFROMPARTS(LOADS.Year, LOADS.Month, 1) AS "Transaction Date" 

  FROM [csacp].[dbo].[vw_LoadSummaryINTL] AS "LOADS"
  LEFT JOIN PARTY_CODE PC ON PC.PartyCode=LOADS.Ccode_
  WHERE LOADS.Country='Brasil' 
  -- Only loads with GP recognized after Navis Go live (7/1/2025)
  AND DATEFROMPARTS(LOADS.Year, LOADS.Month, 1)='2025-07-01'
	GROUP BY PC.BranchCode,DATEFROMPARTS(LOADS.Year, LOADS.Month, 1)
 --,DATEFROMPARTS(LOADS.Year, LOADS.Month, 1) 
  ORDER BY [Transaction Date] ASC
--  ;