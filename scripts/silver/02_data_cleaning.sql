/* ============================================================
   FILE 2: DATA CLEANING
   ============================================================
   Run this AFTER File 1 (01_setup_and_import.sql) succeeds.
   Creates: dbo.Grocery_Sales_Clean

   What this file does:
   - Copies raw data into a clean working table (keeps raw data untouched)
   - Standardizes inconsistent Item_Fat_Content labels
   - Fills missing Item_Weight values
   - Fixes zero Item_Visibility values (0% visibility is not realistic)
   - Fills missing Outlet_Size values
   ============================================================ */

USE BlinkitAnalytics;
GO

-- Step 2.1: Working copy so raw data stays untouched
SELECT *
INTO dbo.Grocery_Sales_Clean
FROM dbo.Grocery_Sales_Raw;
GO

-- Step 2.2: Standardize inconsistent Item_Fat_Content labels
UPDATE dbo.Grocery_Sales_Clean
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('low fat', 'LF', 'Low Fat') THEN 'Low Fat'
        WHEN Item_Fat_Content IN ('reg', 'Regular') THEN 'Regular'
        ELSE Item_Fat_Content
    END;
GO

-- Step 2.3a: Fill missing Item_Weight using same item's average weight
;WITH ItemAvgWeight AS (
    SELECT Item_Identifier, AVG(Item_Weight) AS Avg_Weight
    FROM dbo.Grocery_Sales_Clean
    WHERE Item_Weight IS NOT NULL
    GROUP BY Item_Identifier
)
UPDATE gsc
SET gsc.Item_Weight = iaw.Avg_Weight
FROM dbo.Grocery_Sales_Clean gsc
JOIN ItemAvgWeight iaw ON gsc.Item_Identifier = iaw.Item_Identifier
WHERE gsc.Item_Weight IS NULL;
GO

-- Step 2.3b: Fallback - fill any remaining missing weights using item-type average
;WITH TypeAvgWeight AS (
    SELECT Item_Type, AVG(Item_Weight) AS Avg_Weight
    FROM dbo.Grocery_Sales_Clean
    WHERE Item_Weight IS NOT NULL
    GROUP BY Item_Type
)
UPDATE gsc
SET gsc.Item_Weight = taw.Avg_Weight
FROM dbo.Grocery_Sales_Clean gsc
JOIN TypeAvgWeight taw ON gsc.Item_Type = taw.Item_Type
WHERE gsc.Item_Weight IS NULL;
GO

-- Step 2.4: Fix zero Item_Visibility using item-type average
;WITH TypeAvgVisibility AS (
    SELECT Item_Type, AVG(Item_Visibility) AS Avg_Visibility
    FROM dbo.Grocery_Sales_Clean
    WHERE Item_Visibility > 0
    GROUP BY Item_Type
)
UPDATE gsc
SET gsc.Item_Visibility = tav.Avg_Visibility
FROM dbo.Grocery_Sales_Clean gsc
JOIN TypeAvgVisibility tav ON gsc.Item_Type = tav.Item_Type
WHERE gsc.Item_Visibility = 0;
GO

-- Step 2.5: Fill missing Outlet_Size using most common size for similar outlets
;WITH SizeMode AS (
    SELECT Outlet_Type, Outlet_Location_Type, Outlet_Size,
           ROW_NUMBER() OVER (
               PARTITION BY Outlet_Type, Outlet_Location_Type
               ORDER BY COUNT(*) DESC
           ) AS rn
    FROM dbo.Grocery_Sales_Clean
    WHERE Outlet_Size IS NOT NULL
    GROUP BY Outlet_Type, Outlet_Location_Type, Outlet_Size
)
UPDATE gsc
SET gsc.Outlet_Size = sm.Outlet_Size
FROM dbo.Grocery_Sales_Clean gsc
JOIN SizeMode sm
    ON gsc.Outlet_Type = sm.Outlet_Type
    AND gsc.Outlet_Location_Type = sm.Outlet_Location_Type
    AND sm.rn = 1
WHERE gsc.Outlet_Size IS NULL;
GO

-- Verify: should return 0 for all (no more nulls/zeros left uncleaned)
SELECT
    SUM(CASE WHEN Item_Weight IS NULL THEN 1 ELSE 0 END) AS Missing_Weight,
    SUM(CASE WHEN Item_Visibility = 0 THEN 1 ELSE 0 END) AS Zero_Visibility,
    SUM(CASE WHEN Outlet_Size IS NULL THEN 1 ELSE 0 END) AS Missing_Size
FROM dbo.Grocery_Sales_Clean;
