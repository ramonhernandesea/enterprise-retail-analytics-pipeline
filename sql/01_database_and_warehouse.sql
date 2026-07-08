-- ==================================================
-- 01 Database And Warehouse
-- Enterprise Retail Analytics Pipeline
-- ==================================================

-- Step 1: Create IT Session Database
CREATE OR REPLACE DATABASE ENTERPRISE_COMMERCE_DW;


-- Step 2: Create IT Session DW
CREATE OR REPLACE WAREHOUSE ENTERPRISE_COMMERCE_DW WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 600 AUTO_RESUME = TRUE COMMENT = '';
