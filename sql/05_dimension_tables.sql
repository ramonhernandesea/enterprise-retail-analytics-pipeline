-- ==================================================
-- 05 Dimension Tables
-- Enterprise Retail Analytics Pipeline
-- ==================================================

-- Dim Location
CREATE OR REPLACE TABLE Dim_Location( 
    DimLocationID INT IDENTITY(1,1) CONSTRAINT PK_DimLocationID PRIMARY KEY NOT NULL
    ,Address VARCHAR(255) NOT NULL
    ,City VARCHAR(255) NOT NULL            
    ,PostalCode VARCHAR(255) NOT NULL   
    ,State_Province VARCHAR(255) NOT NULL  
    ,Country VARCHAR(255) NOT NULL         
);
--gold plated row
INSERT INTO Dim_Location
(
     DimLocationID
    ,Address
    ,City
    ,PostalCode
    ,State_Province
    ,Country
)
VALUES
( 
     -1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
);

-- load data
INSERT INTO Dim_Location (
     Address
    ,City
    ,PostalCode
    ,State_Province
    ,Country
)

SELECT
Address,
City,
PostalCode,
StateProvince,
Country
FROM STAGE_CUSTOMER;

INSERT INTO Dim_Location (
     Address
    ,City
    ,PostalCode
    ,State_Province
    ,Country
)

SELECT
Address,
City,
PostalCode,
StateProvince,
Country
FROM STAGE_RESELLER;



SELECT * FROM dim_location

-- Dim Date

-- Create table script for Dimension DIM_DATE
CREATE OR REPLACE TABLE DIM_DATE (
     DimDateID NUMBER(9) PRIMARY KEY
    ,DATE DATE NOT NULL
    ,FULL_DATE_DESC VARCHAR(64) NOT NULL
    ,DAY_NUM_IN_WEEK NUMBER(1) NOT NULL
    ,DAY_NUM_IN_MONTH NUMBER(2) NOT NULL
    ,DAY_NUM_IN_YEAR NUMBER(3) NOT NULL
    ,DAY_NAME VARCHAR(10) NOT NULL
    ,DAY_ABBREV VARCHAR(3) NOT NULL
    ,WEEKDAY_IND VARCHAR(64) NOT NULL
    ,US_HOLIDAY_IND VARCHAR(64) NOT NULL
    ,COMPANY_HOLIDAY_IND VARCHAR(64) NOT NULL
    ,MONTH_END_IND VARCHAR(64) NOT NULL
    ,WEEK_BEGIN_DATE_NKEY NUMBER(9) NOT NULL
    ,WEEK_BEGIN_DATE DATE NOT NULL
    ,WEEK_END_DATE_NKEY NUMBER(9) NOT NULL
    ,WEEK_END_DATE DATE NOT NULL
    ,WEEK_NUM_IN_YEAR NUMBER(9) NOT NULL
    ,MONTH_NAME VARCHAR(10) NOT NULL
    ,MONTH_ABBREV VARCHAR(3) NOT NULL
    ,MONTH_NUM_IN_YEAR NUMBER(2) NOT NULL
    ,YEARMONTH VARCHAR(10) NOT NULL
    ,QUARTER NUMBER(1) NOT NULL
    ,YEARQUARTER VARCHAR(10) NOT NULL
    ,YEAR NUMBER(5) NOT NULL
    ,FISCAL_WEEK_NUM NUMBER(2) NOT NULL
    ,FISCAL_MONTH_NUM NUMBER(2) NOT NULL
    ,FISCAL_YEARMONTH VARCHAR(10) NOT NULL
    ,FISCAL_QUARTER NUMBER(1) NOT NULL
    ,FISCAL_YEARQUARTER VARCHAR(10) NOT NULL
    ,FISCAL_HALFYEAR NUMBER(1) NOT NULL
    ,FISCAL_YEAR NUMBER(5) NOT NULL
    ,SQL_TIMESTAMP TIMESTAMP_NTZ
    ,CURRENT_ROW_IND CHAR(1) DEFAULT 'Y'
    ,EFFECTIVE_DATE DATE DEFAULT TO_DATE(CURRENT_TIMESTAMP)
    ,EXPIRATION_DATE DATE DEFAULT TO_DATE('9999-12-31')
)
COMMENT = 'Type 0 Dimension Table Housing Calendar and Fiscal Year Date Attributes';

-- Populate data into DIM_DATE
INSERT INTO DIM_DATE
SELECT 
     DimDateID
    ,DATE_COLUMN
    ,FULL_DATE_DESC
    ,DAY_NUM_IN_WEEK
    ,DAY_NUM_IN_MONTH
    ,DAY_NUM_IN_YEAR
    ,DAY_NAME
    ,DAY_ABBREV
    ,WEEKDAY_IND
    ,US_HOLIDAY_IND
    ,COMPANY_HOLIDAY_IND
    ,MONTH_END_IND
    ,WEEK_BEGIN_DATE_NKEY
    ,WEEK_BEGIN_DATE
    ,WEEK_END_DATE_NKEY
    ,WEEK_END_DATE
    ,WEEK_NUM_IN_YEAR
    ,MONTH_NAME
    ,MONTH_ABBREV
    ,MONTH_NUM_IN_YEAR
    ,YEARMONTH
    ,CURRENT_QUARTER
    ,YEARQUARTER
    ,CURRENT_YEAR
    ,FISCAL_WEEK_NUM
    ,FISCAL_MONTH_NUM
    ,FISCAL_YEARMONTH
    ,FISCAL_QUARTER
    ,FISCAL_YEARQUARTER
    ,FISCAL_HALFYEAR
    ,FISCAL_YEAR
    ,SQL_TIMESTAMP
    ,CURRENT_ROW_IND
    ,EFFECTIVE_DATE
    ,EXPIRA_DATE
FROM (
    SELECT 
         TO_DATE('2012-12-31 23:59:59','YYYY-MM-DD HH24:MI:SS') AS DD
        ,SEQ1() AS Sl
        ,ROW_NUMBER() OVER (ORDER BY Sl) AS row_numbers
        ,DATEADD(DAY,row_numbers,DD) AS V_DATE
        ,CASE 
            WHEN DATE_PART(DD, V_DATE) < 10 AND DATE_PART(MM, V_DATE) > 9 THEN DATE_PART(YEAR, V_DATE)||DATE_PART(MM, V_DATE)||'0'||DATE_PART(DD, V_DATE)
            WHEN DATE_PART(DD, V_DATE) < 10 AND DATE_PART(MM, V_DATE) < 10 THEN DATE_PART(YEAR, V_DATE)||'0'||DATE_PART(MM, V_DATE)||'0'||DATE_PART(DD, V_DATE)
            WHEN DATE_PART(DD, V_DATE) > 9 AND DATE_PART(MM, V_DATE) < 10 THEN DATE_PART(YEAR, V_DATE)||'0'||DATE_PART(MM, V_DATE)||DATE_PART(DD, V_DATE)
            WHEN DATE_PART(DD, V_DATE) > 9 AND DATE_PART(MM, V_DATE) > 9 THEN DATE_PART(YEAR, V_DATE)||DATE_PART(MM, V_DATE)||DATE_PART(DD, V_DATE) 
         END AS DimDateID
        ,V_DATE AS DATE_COLUMN
        ,DAYNAME(DATEADD(DAY,row_numbers,DD)) AS DAY_NAME_1
        ,CASE
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Mon' THEN 'Monday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Tue' THEN 'Tuesday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Wed' THEN 'Wednesday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Thu' THEN 'Thursday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Fri' THEN 'Friday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Sat' THEN 'Saturday'
            WHEN DAYNAME(DATEADD(DAY,row_numbers,DD)) = 'Sun' THEN 'Sunday' 
         END ||', '||
         CASE 
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Jan' THEN 'January'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Feb' THEN 'February'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Mar' THEN 'March'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Apr' THEN 'April'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='May' THEN 'May'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Jun' THEN 'June'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Jul' THEN 'July'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Aug' THEN 'August'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Sep' THEN 'September'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Oct' THEN 'October'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Nov' THEN 'November'
            WHEN MONTHNAME(DATEADD(DAY,row_numbers,DD)) ='Dec' THEN 'December' 
         END ||' '|| TO_VARCHAR(DATEADD(DAY,row_numbers,DD), ' dd, yyyy') AS FULL_DATE_DESC
        ,DATEADD(DAY,row_numbers,DD) AS V_DATE_1
        ,DAYOFWEEK(V_DATE_1)+1 AS DAY_NUM_IN_WEEK
        ,DATE_PART(DD,V_DATE_1) AS DAY_NUM_IN_MONTH
        ,DAYOFYEAR(V_DATE_1) AS DAY_NUM_IN_YEAR
        ,CASE
            WHEN DAYNAME(V_DATE_1) = 'Mon' THEN 'Monday'
            WHEN DAYNAME(V_DATE_1) = 'Tue' THEN 'Tuesday'
            WHEN DAYNAME(V_DATE_1) = 'Wed' THEN 'Wednesday'
            WHEN DAYNAME(V_DATE_1) = 'Thu' THEN 'Thursday'
            WHEN DAYNAME(V_DATE_1) = 'Fri' THEN 'Friday'
            WHEN DAYNAME(V_DATE_1) = 'Sat' THEN 'Saturday'
            WHEN DAYNAME(V_DATE_1) = 'Sun' THEN 'Sunday' 
         END AS DAY_NAME
        ,DAYNAME(DATEADD(DAY,row_numbers,DD)) AS DAY_ABBREV
        ,CASE
            WHEN DAYNAME(V_DATE_1) = 'Sun' AND DAYNAME(V_DATE_1) = 'Sat' THEN 'Not-Weekday'
            ELSE 'Weekday' 
         END AS WEEKDAY_IND
        ,CASE
            WHEN (DimDateID = DATE_PART(YEAR, V_DATE)||'0101' OR DimDateID = DATE_PART(YEAR, V_DATE)||'0704' OR DimDateID = DATE_PART(YEAR, V_DATE)||'1225' OR DimDateID = DATE_PART(YEAR, V_DATE)||'1226') THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Wed' AND DATEADD(DAY,-2,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Thu' AND DATEADD(DAY,-3,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Fri' AND DATEADD(DAY,-4,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Sat' AND DATEADD(DAY,-5,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Sun' AND DATEADD(DAY,-6,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Mon' AND LAST_DAY(V_DATE_1) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='May' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Tue' AND DATEADD(DAY,-1 ,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Wed' AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Thu' AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Fri' AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Sat' AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Sun' AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Mon' AND DATE_PART(YEAR, V_DATE_1)||'-09-01' = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Tue' AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Wed' AND (DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Thu' AND (DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Fri' AND (DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,20,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Sat' AND (DATEADD(DAY,27,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Sun' AND (DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Mon' AND (DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Tue' AND (DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN 'Holiday'
            ELSE 'Not-Holiday' 
         END AS US_HOLIDAY_IND
        ,CASE
            WHEN (DimDateID = DATE_PART(YEAR, V_DATE)||'0101' OR DimDateID = DATE_PART(YEAR, V_DATE)||'0219' OR DimDateID = DATE_PART(YEAR, V_DATE)||'0528' OR DimDateID = DATE_PART(YEAR, V_DATE)||'0704' OR DimDateID = DATE_PART(YEAR, V_DATE)||'1225' )THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Mar' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Fri' AND LAST_DAY(V_DATE_1) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Mar' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Sat' AND DATEADD(DAY,-1,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Mar' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'Sun' AND DATEADD(DAY,-2,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Tue' AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Wed' AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Thu' AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Fri' AND DATE_PART(YEAR, V_DATE_1)||'-04-01' = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Wed' AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Thu' AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Fri' AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Sat' AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Sun' AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Mon' AND DATE_PART(YEAR, V_DATE_1)||'-04-01'= V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Apr' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'Tue' AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Wed' AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Thu' AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Fri' AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Sat' AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Sun' AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Mon' AND DATE_PART(YEAR, V_DATE_1)||'-09-01' = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Sep' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'Tue' AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Wed' AND DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Thu' AND DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Fri' AND DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Sat' AND DATEADD(DAY,27,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Sun' AND DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Mon' AND DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            WHEN MONTHNAME(V_DATE_1) ='Nov' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'Tue' AND DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN 'Holiday'
            ELSE 'Not-Holiday' 
         END AS COMPANY_HOLIDAY_IND
        ,CASE                                           
            WHEN LAST_DAY(V_DATE_1) = V_DATE_1 THEN 'Month-end'
            ELSE 'Not-Month-end' 
         END AS MONTH_END_IND
        ,CASE 
            WHEN DATE_PART(MM,DATE_TRUNC('week',V_DATE_1)) < 10 AND DATE_PART(DD,DATE_TRUNC('week',V_DATE_1)) < 10 THEN DATE_PART(YYYY,DATE_TRUNC('week',V_DATE_1))||'0'||DATE_PART(MM,DATE_TRUNC('week',V_DATE_1))||'0'||DATE_PART(DD,DATE_TRUNC('week',V_DATE_1))  
            WHEN DATE_PART(MM,DATE_TRUNC('week',V_DATE_1)) < 10 AND DATE_PART(DD,DATE_TRUNC('week',V_DATE_1)) > 9 THEN DATE_PART(YYYY,DATE_TRUNC('week',V_DATE_1))||'0'||DATE_PART(MM,DATE_TRUNC('week',V_DATE_1))||DATE_PART(DD,DATE_TRUNC('week',V_DATE_1))    
            WHEN DATE_PART(MM,DATE_TRUNC('week',V_DATE_1)) > 9 AND DATE_PART(DD,DATE_TRUNC('week',V_DATE_1)) < 10 THEN DATE_PART(YYYY,DATE_TRUNC('week',V_DATE_1))||DATE_PART(MM,DATE_TRUNC('week',V_DATE_1))||'0'||DATE_PART(DD,DATE_TRUNC('week',V_DATE_1))    
            WHEN DATE_PART(MM,DATE_TRUNC('week',V_DATE_1)) > 9 AND DATE_PART(DD,DATE_TRUNC('week',V_DATE_1)) > 9 THEN DATE_PART(YYYY,DATE_TRUNC('week',V_DATE_1))||DATE_PART(MM,DATE_TRUNC('week',V_DATE_1))||DATE_PART(DD,DATE_TRUNC('week',V_DATE_1)) 
         END AS WEEK_BEGIN_DATE_NKEY
        ,DATE_TRUNC('week',V_DATE_1) AS WEEK_BEGIN_DATE
        ,CASE 
            WHEN DATE_PART(MM,LAST_DAY(V_DATE_1,'week')) < 10 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) < 10 THEN DATE_PART(YYYY,LAST_DAY(V_DATE_1,'week'))||'0'||DATE_PART(MM,LAST_DAY(V_DATE_1,'week'))||'0'||DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) 
            WHEN DATE_PART(MM,LAST_DAY(V_DATE_1,'week')) < 10 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) > 9 THEN DATE_PART(YYYY,LAST_DAY(V_DATE_1,'week'))||'0'||DATE_PART(MM,LAST_DAY(V_DATE_1,'week'))||DATE_PART(DD,LAST_DAY(V_DATE_1,'week'))   
            WHEN DATE_PART(MM,LAST_DAY(V_DATE_1,'week')) > 9 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) < 10 THEN DATE_PART(YYYY,LAST_DAY(V_DATE_1,'week'))||DATE_PART(MM,LAST_DAY(V_DATE_1,'week'))||'0'||DATE_PART(DD,LAST_DAY(V_DATE_1,'week'))   
            WHEN DATE_PART(MM,LAST_DAY(V_DATE_1,'week')) > 9 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) > 9 THEN DATE_PART(YYYY,LAST_DAY(V_DATE_1,'week'))||DATE_PART(MM,LAST_DAY(V_DATE_1,'week'))||DATE_PART(DD,LAST_DAY(V_DATE_1,'week')) 
         END AS WEEK_END_DATE_NKEY
        ,LAST_DAY(V_DATE_1,'week') AS WEEK_END_DATE
        ,WEEK(V_DATE_1) AS WEEK_NUM_IN_YEAR
        ,CASE 
            WHEN MONTHNAME(V_DATE_1) ='Jan' THEN 'January'
            WHEN MONTHNAME(V_DATE_1) ='Feb' THEN 'February'
            WHEN MONTHNAME(V_DATE_1) ='Mar' THEN 'March'
            WHEN MONTHNAME(V_DATE_1) ='Apr' THEN 'April'
            WHEN MONTHNAME(V_DATE_1) ='May' THEN 'May'
            WHEN MONTHNAME(V_DATE_1) ='Jun' THEN 'June'
            WHEN MONTHNAME(V_DATE_1) ='Jul' THEN 'July'
            WHEN MONTHNAME(V_DATE_1) ='Aug' THEN 'August'
            WHEN MONTHNAME(V_DATE_1) ='Sep' THEN 'September'
            WHEN MONTHNAME(V_DATE_1) ='Oct' THEN 'October'
            WHEN MONTHNAME(V_DATE_1) ='Nov' THEN 'November'
            WHEN MONTHNAME(V_DATE_1) ='Dec' THEN 'December' 
         END AS MONTH_NAME
        ,MONTHNAME(V_DATE_1) AS MONTH_ABBREV
        ,MONTH(V_DATE_1) AS MONTH_NUM_IN_YEAR
        ,CASE 
            WHEN MONTH(V_DATE_1) < 10 THEN YEAR(V_DATE_1)||'-0'||MONTH(V_DATE_1)   
            ELSE YEAR(V_DATE_1)||'-'||MONTH(V_DATE_1) 
         END AS YEARMONTH
        ,QUARTER(V_DATE_1) AS CURRENT_QUARTER
        ,YEAR(V_DATE_1)||'-0'||QUARTER(V_DATE_1) AS YEARQUARTER
        ,YEAR(V_DATE_1) AS CURRENT_YEAR
        ,TO_DATE(YEAR(V_DATE_1)||'-01-01','YYYY-MM-DD') AS FISCAL_CUR_YEAR
        ,TO_DATE(YEAR(V_DATE_1) -1||'-01-01','YYYY-MM-DD') AS FISCAL_PREV_YEAR
        ,CASE 
            WHEN V_DATE_1 < FISCAL_CUR_YEAR THEN DATEDIFF('week', FISCAL_PREV_YEAR,V_DATE_1)
            ELSE DATEDIFF('week', FISCAL_CUR_YEAR,V_DATE_1)  
         END AS FISCAL_WEEK_NUM  
        ,DECODE(DATEDIFF('MONTH',FISCAL_CUR_YEAR, V_DATE_1)+1 ,-2,10,-1,11,0,12, DATEDIFF('MONTH',FISCAL_CUR_YEAR, V_DATE_1)+1 ) AS FISCAL_MONTH_NUM
        ,CONCAT(YEAR(FISCAL_CUR_YEAR), CASE WHEN TO_NUMBER(FISCAL_MONTH_NUM) = 10 OR TO_NUMBER(FISCAL_MONTH_NUM) = 11 OR TO_NUMBER(FISCAL_MONTH_NUM) = 12 THEN '-'||FISCAL_MONTH_NUM ELSE CONCAT('-0',FISCAL_MONTH_NUM) END ) AS FISCAL_YEARMONTH
        ,CASE 
            WHEN QUARTER(V_DATE_1) = 4 THEN 4
            WHEN QUARTER(V_DATE_1) = 3 THEN 3
            WHEN QUARTER(V_DATE_1) = 2 THEN 2
            WHEN QUARTER(V_DATE_1) = 1 THEN 1 
         END AS FISCAL_QUARTER
        ,CASE 
            WHEN V_DATE_1 < FISCAL_CUR_YEAR THEN YEAR(FISCAL_CUR_YEAR)
            ELSE YEAR(FISCAL_CUR_YEAR)+1 
         END ||'-0'||
         CASE 
            WHEN QUARTER(V_DATE_1) = 4 THEN 4
            WHEN QUARTER(V_DATE_1) = 3 THEN 3
            WHEN QUARTER(V_DATE_1) = 2 THEN 2
            WHEN QUARTER(V_DATE_1) = 1 THEN 1 
         END AS FISCAL_YEARQUARTER
        ,CASE 
            WHEN QUARTER(V_DATE_1) = 4 THEN 2 
            WHEN QUARTER(V_DATE_1) = 3 THEN 2
            WHEN QUARTER(V_DATE_1) = 1 THEN 1 
            WHEN QUARTER(V_DATE_1) = 2 THEN 1
         END AS FISCAL_HALFYEAR
        ,YEAR(FISCAL_CUR_YEAR) AS FISCAL_YEAR
        ,TO_TIMESTAMP_NTZ(V_DATE) AS SQL_TIMESTAMP
        ,'Y' AS CURRENT_ROW_IND
        ,TO_DATE(CURRENT_TIMESTAMP) AS EFFECTIVE_DATE
        ,TO_DATE('9999-12-31') AS EXPIRA_DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 730))
) v;

SELECT * FROM DIM_DATE


-- Dim Channel
DROP TABLE IF EXISTS Dim_Channel;
CREATE OR REPLACE TABLE Dim_Channel (
     DimChannelID INT IDENTITY(1,1) CONSTRAINT PK_DimChannel PRIMARY KEY NOT NULL
    ,ChannelID INTEGER NOT NULL
    ,ChannelCategoryID INTEGER NOT NULL
    ,ChannelName VARCHAR(255) NOT NULL            
    ,ChannelCategory VARCHAR(255) NOT NULL
);


--gold plated row
INSERT INTO Dim_Channel (
     ChannelID
    ,ChannelCategoryID
    ,ChannelName
    ,ChannelCategory
)
VALUES ( 
     -1
    ,-1
    ,'Unknown'
    ,'Unknown'
);


--3 load
INSERT INTO Dim_Channel (
     ChannelID
    ,ChannelCategoryID
    ,ChannelName
    ,ChannelCategory
)
VALUES (
     -1
    ,-1
    ,'Unknown'
    ,'Unknown'
);

-- load data
INSERT INTO Dim_Channel (
     ChannelID
    ,ChannelCategoryID
    ,ChannelName
    ,ChannelCategory
)
SELECT 
     ch.ChannelID AS ChannelID
    ,ch.ChannelCategoryID AS ChannelCategoryID
    ,ch.Channel AS ChannelName
    ,cat.ChannelCategory AS ChannelCategory
FROM STAGE_CHANNEL ch
INNER JOIN STAGE_CHANNELCATEGORY cat
    ON ch.ChannelCategoryID = cat.ChannelCategoryID;

SELECT * FROM DIM_CHANNEL


-- Dim Store
DROP TABLE IF EXISTS Dim_Store CASCADE;

CREATE OR REPLACE TABLE Dim_Store (
     DimStoreID      INTEGER NOT NULL CONSTRAINT PK_StoreID PRIMARY KEY 
    ,DimLocationID   INTEGER NOT NULL
    ,SourceStoreID   INTEGER NOT NULL
    ,StoreName       VARCHAR(255) NOT NULL
    ,StoreNumber     INTEGER NOT NULL
    ,StoreManager    VARCHAR(255) NOT NULL
);

--gold plated row
INSERT INTO Dim_Store (
     DimStoreID
    ,DimLocationID
    ,SourceStoreID 
    ,StoreName 
    ,StoreNumber 
    ,StoreManager 
)
VALUES (
     -1
    ,-1          
    ,-1          
    ,'Unknown'   
    ,-1          
    ,'Unknown'   
);

--load data

INSERT INTO Dim_Store (
     DimStoreID
    ,DimLocationID
    ,SourceStoreID 
    ,StoreName 
    ,StoreNumber 
    ,StoreManager      
)
SELECT DISTINCT
     STOREID AS DimStoreID        
    ,-1 AS DimLocationID
    ,STOREID AS SourceStoreID 
    ,CONCAT('Store ', STORENUMBER) AS StoreName 
    ,STORENUMBER AS StoreNumber 
    ,NVL(STOREMANAGER, 'Unknown') AS StoreManager     
FROM ENTERPRISE_COMMERCE_DW.PUBLIC.STAGE_STORE
WHERE STORENUMBER IS NOT NULL;


SELECT * FROM Dim_Store ORDER BY StoreNumber;



--Dim_Reller
CREATE OR REPLACE TABLE Dim_Reseller (
DimResellerID INT IDENTITY(1,1) CONSTRAINT PK_StoreID PRIMARY KEY NOT
NULL
,DimLocationID INTEGER NOT NULL
,ResellerID VARCHAR(255) NOT NULL
,ContactName VARCHAR(255) NOT NULL
,PhoneNumber VARCHAR(255) NOT NULL
,Email VARCHAR(255) NOT NULL
);

--gold plated row
INSERT INTO Dim_Reseller  (

 DimLocationID 
,ResellerID 
,ContactName 
,PhoneNumber 
,Email 
)

VALUES (

-1
,'Unknown'
,'Unknown'
,'Unknown'
,'Unknown'

);


--load


INSERT INTO Dim_Reseller (

DimLocationID 
,ResellerID 
,ContactName 
,PhoneNumber 
,Email 
)

SELECT 
     NVL(loc.DimLocationID, -1) AS DimLocationID
    ,r.ResellerID AS ResellerID
    ,r.Contact AS ContactName
    ,r.PhoneNumber AS PhoneNumber
    ,r.EmailAddress AS Email
FROM ENTERPRISE_COMMERCE_DW.PUBLIC.STAGE_RESELLER r
LEFT JOIN ENTERPRISE_COMMERCE_DW.PUBLIC.Dim_Location loc
    ON UPPER(r.City) = UPPER(loc.City) 
    AND UPPER(r.StateProvince) = UPPER(loc.State_Province)
    -- Force text evaluation so the 'Unknown' placeholder doesn't break numeric columns
    AND r.PostalCode::VARCHAR = loc.PostalCode::VARCHAR;

Select * From DIM_RESELLER


--Dim_Customer


CREATE OR REPLACE TABLE Dim_Customer (
     DimCustomerID INT IDENTITY(1,1) CONSTRAINT PK_CustomerID PRIMARY KEY NOT NULL
    ,DimLocationID INT NOT NULL
    ,CustomerID VARCHAR(255) NOT NULL
    ,CustomerFullName VARCHAR(510) NOT NULL
    ,CustomerFirstName VARCHAR(255) NOT NULL
    ,CustomerLastName VARCHAR(255) NOT NULL
    ,CustomerGender VARCHAR(50) NOT NULL
);

--gold plated row
INSERT INTO Dim_Customer (
     DimLocationID 
    ,CustomerID 
    ,CustomerFullName
    ,CustomerFirstName 
    ,CustomerLastName 
    ,CustomerGender 
)
VALUES (
     -1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
);

--Load w/ full Name
INSERT INTO Dim_Customer (
     DimLocationID 
    ,CustomerID 
    ,CustomerFullName
    ,CustomerFirstName 
    ,CustomerLastName 
    ,CustomerGender 
)
SELECT 
     NVL(loc.DimLocationID, -1) AS DimLocationID
    ,c.CustomerID AS CustomerID
    ,c.FirstName || ' ' || c.LastName AS CustomerFullName -- Concatenates full name
    ,c.FirstName AS CustomerFirstName
    ,c.LastName AS CustomerLastName
    ,c.Gender AS CustomerGender
FROM ENTERPRISE_COMMERCE_DW.PUBLIC.STAGE_CUSTOMER c
LEFT JOIN ENTERPRISE_COMMERCE_DW.PUBLIC.Dim_Location loc
    ON UPPER(c.City) = UPPER(loc.City) 
    AND UPPER(c.StateProvince) = UPPER(loc.State_Province)
    AND c.PostalCode::VARCHAR = loc.PostalCode::VARCHAR;


Select * From DIM_CUSTOMER

--Dim Product

CREATE TABLE Dim_Product (
     DimProductID INT IDENTITY(1,1) CONSTRAINT PK_DimProductID PRIMARY KEY NOT NULL
    ,ProductID INTEGER NOT NULL
    ,ProductTypeID INTEGER NOT NULL
    ,ProductCategoryID INTEGER NOT NULL
    ,ProductName VARCHAR(255) NOT NULL
    ,ProductType VARCHAR(255) NOT NULL
    ,ProductCategory VARCHAR(255) NOT NULL
    ,ProductRetailPrice DECIMAL(18,2) NOT NULL
    ,ProductWholesalePrice DECIMAL(18,2) NOT NULL
    ,ProductCost DECIMAL(18,2) NOT NULL
    ,ProductRetailProfit DECIMAL(18,2) NOT NULL
    ,ProductWholesaleUnitProfit DECIMAL(18,2) NOT NULL
    ,ProductProfitMarginUnitPercent DECIMAL(18,4) NOT NULL
    );

--gold plated row

INSERT INTO Dim_Product (
     ProductID
    ,ProductTypeID
    ,ProductCategoryID
    ,ProductName
    ,ProductType
    ,ProductCategory
    ,ProductRetailPrice
    ,ProductWholesalePrice
    ,ProductCost
    ,ProductRetailProfit
    ,ProductWholesaleUnitProfit
    ,ProductProfitMarginUnitPercent
)
VALUES (
     -1
    ,-1
    ,-1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,0.00
    ,0.00
    ,0.00
    ,0.00
    ,0.00
    ,0.0000
);

--load data

INSERT INTO Dim_Product (
     ProductID
    ,ProductTypeID
    ,ProductCategoryID
    ,ProductName
    ,ProductType
    ,ProductCategory
    ,ProductRetailPrice
    ,ProductWholesalePrice
    ,ProductCost
    ,ProductRetailProfit
    ,ProductWholesaleUnitProfit
    ,ProductProfitMarginUnitPercent
)
SELECT 
     p.ProductID AS ProductID
    ,p.ProductTypeID AS ProductTypeID
    ,t.ProductCategoryID AS ProductCategoryID
    ,p.Product AS ProductName
    ,t.ProductType AS ProductType
    ,c.ProductCategory AS ProductCategory
    ,p.Price AS ProductRetailPrice
    ,p.WholesalePrice AS ProductWholesalePrice
    ,p.Cost AS ProductCost
    -- Calculated Fields
    ,(p.Price - p.Cost) AS ProductRetailProfit
    ,(p.WholesalePrice - p.Cost) AS ProductWholesaleUnitProfit
    ,ROUND(((p.Price - p.Cost) / NULLIF(p.Price, 0)) * 100, 4) AS ProductProfitMarginUnitPercent
FROM STAGE_PRODUCT p
INNER JOIN STAGE_PRODUCTTYPE t
    ON p.ProductTypeID = t.ProductTypeID
INNER JOIN STAGE_PRODUCTCATEGORY c
    ON t.ProductCategoryID = c.ProductCategoryID;


SELECT * FROM  DIM_PRODUCT
