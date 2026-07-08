-- ==================================================
-- 02 External Stages
-- Enterprise Retail Analytics Pipeline
-- ==================================================

-- Step 3: Create a Snowflake stage for all tables
CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".CHANNEL_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/channel' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".CHANNEL_CATEGORY_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/channelcategory' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".CUSTOMER_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/customer' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".PRODUCT_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/product' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".PRODUCT_CATEGORY_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/productcategory' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".PRODUCT_TYPE_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/producttype' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".RESELLER_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/reseller' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".SALES_DETAIL_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/salesdetail' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".SALES_HEADER_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/salesheader' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".STORE_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/store' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".TARGET_DATA_CHANNEL_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/targetdatachannel' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');

CREATE OR REPLACE STAGE "ENTERPRISE_COMMERCE_DW"."PUBLIC".TARGET_DATA_PRODUCT_STAGE URL = 'azure://dropshipcommercedata.blob.core.windows.net/targetdataproduct' CREDENTIALS = (AZURE_SAS_TOKEN = '<YOUR_AZURE_SAS_TOKEN>');
