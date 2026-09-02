/* ============================================================
   FILE 1: SETUP & DATA IMPORT
   ============================================================
  

   STEPS:
   1. Run the CREATE DATABASE statement below 
   2. Save GrocerySales.csv to your computer
   3. In SSMS Object Explorer: right-click BlinkitAnalytics
      -> Tasks -> Import Flat File -> select GrocerySales.csv
      -> table name: Grocery_Sales_Raw -> Finish
   4. Run the verification query at the bottom to confirm 8523 rows
   ============================================================ */

CREATE DATABASE BlinkitAnalytics;
GO

USE BlinkitAnalytics;
GO

-- After completing the Import Flat File wizard, verify it worked:
SELECT COUNT(*) AS Row_Count FROM dbo.Grocery_Sales_Raw;
-- Expected result: 8523
