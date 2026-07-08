-- ==================================================
-- 06 Fact Tables
-- Enterprise Retail Analytics Pipeline
-- ==================================================

-- Fact_ProductSalesTarget

TRUNCATE TABLE Fact_ProductSalesTarget;
DROP TABLE IF EXISTS Fact_ProductSalesTarget;
-- create table

CREATE TABLE Fact_ProductSalesTarget
(
     DimProductID INTEGER CONSTRAINT FK_ProductTarget_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID)
	,DimTargetDateID NUMBER(9) CONSTRAINT FK_ProductTarget_DimTargetDateID FOREIGN KEY REFERENCES DIM_DATE(DimDateID) 
    ,ProductTargetSalesQuantity DECIMAL(18,4)
);

--insert
INSERT INTO Fact_ProductSalesTarget
	(
		 DimProductID
		,DimTargetDateID 
		,ProductTargetSalesQuantity
	)
	SELECT DISTINCT   
		  Dim_Product.DimProductID
		 ,DIM_DATE.DimDateID
         ,(STAGE_TARGET_PRODUCT.SALESQUANTITYTARGET / 365)
	FROM STAGE_TARGET_PRODUCT
	INNER JOIN Dim_Product ON
	Dim_Product.ProductID = STAGE_TARGET_PRODUCT.PRODUCTID
    INNER JOIN DIM_DATE ON
    DIM_DATE.YEAR = STAGE_TARGET_PRODUCT.YEAR;
    
SELECT * FROM Fact_ProductSalesTarget;


-- Fact_SRCSalesTarget
TRUNCATE TABLE Fact_SRCSalesTarget;

SELECT * FROM Fact_SRCSalesTarget;

DROP TABLE IF EXISTS Fact_SRCSalesTarget;

CREATE TABLE Fact_SRCSalesTarget
(
     DimStoreID INTEGER CONSTRAINT FK_SRCTarget_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID)
    ,DimResellerID INTEGER CONSTRAINT FK_SRCTarget_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID)
    ,DimChannelID INTEGER CONSTRAINT FK_SRCTarget_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID)
	,DimTargetDateID NUMBER(9) CONSTRAINT FK_SRCTarget_DimTargetDateID FOREIGN KEY REFERENCES DIM_DATE(DimDateID)
    ,SalesTargetAmount DECIMAL(18,4)
);

-- insert complex
INSERT INTO Fact_SRCSalesTarget
	(
		 DimStoreID
        ,DimResellerID
		,DimChannelID
		,DimTargetDateID
        ,SalesTargetAmount
	)
	SELECT DISTINCT  
		   NVL(ds.DimStoreID, -1) AS DimStoreID
		  ,NVL(dr.DimResellerID, -1) AS DimResellerID
          ,NVL(dc.DimChannelID, -1) AS DimChannelID
		  ,dd.DimDateID AS DimTargetDateID
          ,(st.TargetSalesAmount / 365) AS SalesTargetAmount
	FROM STAGE_TARGET_CHANNEL_RESELLER_STORE st
    INNER JOIN DIM_DATE dd 
        ON dd.YEAR = st.Year
    LEFT OUTER JOIN Dim_Channel dc 
        ON REPLACE(UPPER(st.ChannelName), '-', '') =
           REPLACE(UPPER(dc.ChannelName), '-', '')
    LEFT OUTER JOIN Dim_Store ds 
        ON ds.StoreName = st.TargetName
    LEFT OUTER JOIN Dim_Reseller dr 
        ON dr.ResellerID = st.TargetName;
        

SELECT * FROM Fact_SRCSalesTarget;


--Fact_SalesActual
TRUNCATE TABLE FACT_SALESACTUAL;
DROP TABLE IF EXISTS FACT_SALESACTUAL CASCADE;

SELECT * FROM Fact_SalesActual;

DROP TABLE IF EXISTS Fact_SalesActual;

CREATE OR REPLACE TABLE FACT_SALESACTUAL (
     SALESHEADERID    INTEGER NOT NULL
    ,SALESDETAILID    INTEGER NOT NULL
    ,DIMSTOREID       INTEGER NOT NULL
    ,DIMPRODUCTID     INTEGER NOT NULL
    ,DIMSALEDATEID    INTEGER NOT NULL
    ,SALEQUANTITY     INTEGER NOT NULL
    ,SALEAMOUNT       NUMBER(38,4) NOT NULL
    ,SALETOTALPROFIT  NUMBER(38,4) NOT NULL
    ,CONSTRAINT PK_FactSales PRIMARY KEY (SALESHEADERID, SALESDETAILID)
);

-- load 
INSERT INTO FACT_SALESACTUAL (
     SALESHEADERID
    ,SALESDETAILID
    ,DIMSTOREID
    ,DIMPRODUCTID
    ,DIMSALEDATEID
    ,SALEQUANTITY
    ,SALEAMOUNT
    ,SALETOTALPROFIT
)
SELECT 
     h.SALESHEADERID
    ,d.SALESDETAILID
    ,NVL(s.DIMSTOREID, -1) AS DIMSTOREID     
    ,NVL(p.DIMPRODUCTID, -1) AS DIMPRODUCTID
    ,NVL(dt.DIMDATEID, -1) AS DIMSALEDATEID  
    ,d.SALESQUANTITY
    ,d.SALESAMOUNT
    ,(d.SALESAMOUNT - (d.SALESQUANTITY * NVL(p.PRODUCTCOST, 0))) AS SALETOTALPROFIT 
FROM ENTERPRISE_COMMERCE_DW.PUBLIC.STAGE_SALESHEADER h
INNER JOIN ENTERPRISE_COMMERCE_DW.PUBLIC.STAGE_SALESDETAIL d 
    ON h.SALESHEADERID = d.SALESHEADERID
LEFT OUTER JOIN DIM_STORE s 
    ON h.STOREID = s.SOURCESTOREID            
LEFT OUTER JOIN DIM_PRODUCT p 
    ON d.PRODUCTID = p.PRODUCTID 
LEFT OUTER JOIN DIM_DATE dt 
    ON h.DATE = dt.DATE;



SELECT * FROM Fact_SalesActual LIMIT 10;
