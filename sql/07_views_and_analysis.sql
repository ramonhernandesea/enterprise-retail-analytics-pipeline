-- ==================================================
-- 07 Views And Analysis Queries
-- Enterprise Retail Analytics Pipeline
-- ==================================================

CREATE OR REPLACE SECURE VIEW VIEW_DIM_STORE AS
SELECT DimStoreID, DimLocationID, SourceStoreID, StoreName, StoreNumber, StoreManager 
FROM Dim_Store;

-- Product Dimension Pass-Through View
CREATE OR REPLACE SECURE VIEW VIEW_DIM_PRODUCT AS
SELECT 
     DimProductID, ProductID, ProductTypeID, ProductCategoryID, ProductName, 
     ProductType, ProductCategory, ProductRetailPrice, ProductWholesalePrice, 
     ProductCost, ProductRetailProfit, ProductWholesaleUnitProfit, ProductProfitMarginUnitPercent 
FROM Dim_Product;

-- Channel Dimension Pass-Through View
CREATE OR REPLACE SECURE VIEW VIEW_DIM_CHANNEL AS
SELECT DimChannelID, ChannelID, ChannelCategoryID, ChannelName, ChannelCategory 
FROM Dim_Channel;

-- Location Dimension Pass-Through View
CREATE OR REPLACE SECURE VIEW VIEW_DIM_LOCATION AS
SELECT DimLocationID, Address, City, PostalCode, State_Province, Country 
FROM Dim_Location;

-- Date Dimension Pass-Through View
CREATE OR REPLACE SECURE VIEW VIEW_DIM_DATE AS
SELECT 
     DIMDATEID        AS DimDateID
    ,DATE             AS FullDate
    ,DAY_NAME         AS DayNameOfWeek
    ,DAY_NUM_IN_MONTH AS DayNumberOfMonth
    ,MONTH_NAME       AS MonthName
    ,MONTH_NUM_IN_YEAR AS MonthNumberOfYear
    ,YEAR             AS CalendarYear 
FROM Dim_Date;

-- Customer Dimension Pass-Through View
CREATE OR REPLACE SECURE VIEW VIEW_DIM_CUSTOMER AS
SELECT DimCustomerID, DimLocationID, CustomerID, CustomerFullName, CustomerFirstName, CustomerLastName, CustomerGender 
FROM Dim_Customer;

-- Custom View 1
CREATE OR REPLACE SECURE VIEW VIEW_ANALYTICS_STORE_PERFORMANCE AS
SELECT 
     s.STORENUMBER        AS StoreNumber
    ,s.STORENAME          AS StoreName
    ,d.YEAR               AS CalendarYear
    ,SUM(f.SALEAMOUNT)    AS Total_Sales_Actual
    ,SUM(f.SALETOTALPROFIT) AS Total_Profit_Actual
    ,SUM(f.SALEQUANTITY)  AS Total_Items_Sold
FROM FACT_SALESACTUAL f
INNER JOIN DIM_STORE s ON f.DIMSTOREID = s.DIMSTOREID
INNER JOIN DIM_DATE d  ON f.DIMSALEDATEID = d.DIMDATEID
WHERE s.STORENUMBER IN (5, 8, 10, 21)
GROUP BY s.STORENUMBER, s.STORENAME, d.YEAR;

-- Custom View 2

CREATE OR REPLACE SECURE VIEW VIEW_ANALYTICS_CASUAL_BONUS_POOL AS
SELECT 
     s.STORENUMBER        AS StoreNumber
    ,s.STORENAME          AS StoreName
    ,d.YEAR               AS CalendarYear
    ,p.PRODUCTTYPE        AS ProductType
    ,SUM(f.SALEAMOUNT)    AS Casual_Sales_Amount
    ,SUM(f.SALEQUANTITY)  AS Casual_Quantity_Sold
FROM FACT_SALESACTUAL f
INNER JOIN DIM_STORE s   ON f.DIMSTOREID = s.DIMSTOREID
INNER JOIN DIM_PRODUCT p ON f.DIMPRODUCTID = p.DIMPRODUCTID
INNER JOIN DIM_DATE d    ON f.DIMSALEDATEID = d.DIMDATEID
WHERE s.STORENUMBER IN (5, 8, 10, 21) 
  AND p.PRODUCTTYPE IN ('Men''s Casual', 'Women''s Casual')
GROUP BY s.STORENUMBER, s.STORENAME, d.YEAR, p.PRODUCTTYPE;

-- Custom View 3

CREATE OR REPLACE SECURE VIEW VIEW_ANALYTICS_DAY_OF_WEEK_TRENDS AS
SELECT 
     s.STORENUMBER        AS StoreNumber
    ,s.STORENAME          AS StoreName
    ,d.DAY_NAME           AS DayNameOfWeek
    ,d.MONTH_NAME         AS MonthName
    ,p.PRODUCTCATEGORY    AS ProductCategory
    ,SUM(f.SALEAMOUNT)    AS Total_Sales
    ,COUNT(DISTINCT f.SALESHEADERID) AS Total_Transactions
FROM FACT_SALESACTUAL f
INNER JOIN DIM_STORE s   ON f.DIMSTOREID = s.DIMSTOREID
INNER JOIN DIM_PRODUCT p ON f.DIMPRODUCTID = p.DIMPRODUCTID
INNER JOIN DIM_DATE d    ON f.DIMSALEDATEID = d.DIMDATEID
WHERE s.STORENUMBER IN (5, 8, 10, 21)
GROUP BY s.STORENUMBER, s.STORENAME, d.DAY_NAME, d.MONTH_NAME, p.PRODUCTCATEGORY;

SELECT GET_DDL('SCHEMA', 'ENTERPRISE_COMMERCE_DW.PUBLIC');

SELECT
    COUNT(*) AS TOTAL_FACT_ROWS,

    SUM(CASE WHEN ds.DIMSTOREID IS NULL THEN 1 ELSE 0 END) AS BAD_STORE_KEYS,
    SUM(CASE WHEN dp.DIMPRODUCTID IS NULL THEN 1 ELSE 0 END) AS BAD_PRODUCT_KEYS,
    SUM(CASE WHEN dd.DIMDATEID IS NULL THEN 1 ELSE 0 END) AS BAD_DATE_KEYS



SELECT *
FROM VIEW_ANALYTICS_STORE_PERFORMANCE;

SELECT *
FROM VIEW_ANALYTICS_CASUAL_BONUS_POOL;

SELECT *
FROM VIEW_ANALYTICS_DAY_OF_WEEK_TRENDS;


-- year issue with weekly trend fix

create or replace secure view VIEW_ANALYTICS_DAY_OF_WEEK_TRENDS(
	STORENUMBER,
	STORENAME,
	CALENDARYEAR,  -- fixes expected column issue
	DAYNAMEOFWEEK,
	MONTHNAME,
	PRODUCTCATEGORY,
	TOTAL_SALES,
	TOTAL_TRANSACTIONS
) as
SELECT 
     s.STORENUMBER        AS StoreNumber
    ,s.STORENAME          AS StoreName
    ,d.YEAR               AS CalendarYear  -- pulls year column from dim_date
    ,d.DAY_NAME           AS DayNameOfWeek
    ,d.MONTH_NAME         AS MonthName
    ,p.PRODUCTCATEGORY    AS ProductCategory
    ,SUM(f.SALEAMOUNT)    AS Total_Sales
    ,COUNT(DISTINCT f.SALESHEADERID) AS Total_Transactions
FROM FACT_SALESACTUAL f
INNER JOIN DIM_STORE s   ON f.DIMSTOREID = s.DIMSTOREID
INNER JOIN DIM_PRODUCT p ON f.DIMPRODUCTID = p.DIMPRODUCTID
INNER JOIN DIM_DATE d    ON f.DIMSALEDATEID = d.DIMDATEID
WHERE s.STORENUMBER IN (5, 8, 10, 21)
GROUP BY 
     s.STORENUMBER
    ,s.STORENAME
    ,d.YEAR              -- added to grouping to slice rows by year
    ,d.DAY_NAME
    ,d.MONTH_NAME
    ,p.PRODUCTCATEGORY;

SELECT GET_DDL('VIEW', 'VIEW_ANALYTICS_DAY_OF_WEEK_TRENDS');


--- Add Target data for Sales by Store Viz 

CREATE OR REPLACE SECURE VIEW VIEW_ANALYTICS_STORE_PERFORMANCE AS
SELECT 
     s.STORENUMBER           AS StoreNumber
    ,s.STORENAME             AS StoreName
    ,ss.CITY                 AS City         
    ,ss.STATEPROVINCE        AS StateProvince 
    ,d.YEAR                  AS CalendarYear
    ,SUM(f.SALEAMOUNT)       AS Total_Sales_Actual
    ,SUM(f.SALETOTALPROFIT)  AS Total_Profit_Actual
    ,SUM(f.SALEQUANTITY)     AS Total_Items_Sold

    ,MAX(t.TargetSalesAmount) AS Target
FROM FACT_SALESACTUAL f
INNER JOIN DIM_STORE s ON f.DIMSTOREID = s.DIMSTOREID
INNER JOIN DIM_DATE d  ON f.DIMSALEDATEID = d.DIMDATEID
LEFT JOIN STAGE_STORE ss ON s.STORENUMBER = ss.STORENUMBER
LEFT JOIN STAGE_TARGET_CHANNEL_RESELLER_STORE t
    ON d.YEAR = t.Year
    AND 'Store Number ' || s.STORENUMBER = t.TargetName
WHERE s.STORENUMBER IN (5, 8, 10, 21)
GROUP BY s.STORENUMBER, s.STORENAME, ss.CITY, ss.STATEPROVINCE, d.YEAR; 


--adding city and state to view

CREATE OR REPLACE VIEW VIEW_ANALYTICS_STORE_PERFORMANCE AS 
SELECT 
    s.Storename,
    s.Storenumber,
    s.City,            -- <-- Added City only
    s.StateProvince,   -- <-- Added StateProvince only
    f.Calendaryear,
    f.SelectedYearSales,
    f.BackgroundYearSales,
    f.SelectedYearProfitColor,
    f.SelectedYear,
    f.Storenumber AS Storenumber_Fact,
    f.TARGET,
    f.TotalItemsSold,
    f.TotalProfitActual,
    f.TotalSalesActual,
    f.YearMatchFilter
FROM DIM_STORE s
LEFT JOIN FACT_STORE_PERFORMANCE f 
    ON s.StoreID = f.StoreID;
        
-- TABLEAU

SELECT CONCAT(SYSTEM$RETURN_CURRENT_ORG_NAME(), '-', CURRENT_ACCOUNT_NAME(), '.snowflakecomputing.com') AS TABLEAU_SERVER_URL;
