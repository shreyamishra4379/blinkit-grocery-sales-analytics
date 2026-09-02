/* ============================================================
   FILE 3: DERIVED COLUMNS
   ============================================================
   Run this AFTER File 2 (02_data_cleaning.sql) succeeds.
   Adds new columns to: dbo.Grocery_Sales_Clean

   What this file does:
   - Adds Outlet_Age (calculated from establishment year)
   - Adds Item_Category_Group (Food / Drinks / Non-Consumable,
     derived from the Item_Identifier prefix)
   - Fixes fat content label for non-consumable items
     (a non-food item shouldn't have a "fat content" value)
   ============================================================ */

USE BlinkitAnalytics;
GO

-- Step 3.1: Add Outlet_Age
ALTER TABLE dbo.Grocery_Sales_Clean ADD Outlet_Age INT;
GO

UPDATE dbo.Grocery_Sales_Clean
SET Outlet_Age = 2013 - Outlet_Establishment_Year;
GO

-- Step 3.2: Add Item_Category_Group
ALTER TABLE dbo.Grocery_Sales_Clean ADD Item_Category_Group VARCHAR(20);
GO

UPDATE dbo.Grocery_Sales_Clean
SET Item_Category_Group =
    CASE
        WHEN LEFT(Item_Identifier, 2) = 'FD' THEN 'Food'
        WHEN LEFT(Item_Identifier, 2) = 'DR' THEN 'Drinks'
        WHEN LEFT(Item_Identifier, 2) = 'NC' THEN 'Non-Consumable'
        ELSE 'Other'
    END;
GO

-- Step 3.3: Fix fat content for non-consumables
UPDATE dbo.Grocery_Sales_Clean
SET Item_Fat_Content = 'Not Applicable'
WHERE Item_Category_Group = 'Non-Consumable';
GO

-- Verify: preview the new columns
SELECT TOP 10 Item_Identifier, Item_Category_Group, Outlet_Age, Item_Fat_Content
FROM dbo.Grocery_Sales_Clean;
