/* ============================================================
   FILE 5: BUSINESS ANALYSIS QUERIES
   ============================================================
   Run this AFTER File 4 (04_star_schema.sql) succeeds.
   Uses: dbo.dim_item, dbo.dim_outlet, dbo.fact_sales

   Each query below is INDEPENDENT - run them one at a time in
   a new query window, in any order. Each is labeled with what
   business question it answers.
   ============================================================ */

USE BlinkitAnalytics;
GO


-- ===== QUERY 5.1: Top 10 selling items by total sales =====
SELECT TOP 10
    f.Item_Identifier,
    i.Item_Type,
    SUM(f.Item_Outlet_Sales) AS Total_Sales
FROM dbo.fact_sales f
JOIN dbo.dim_item i ON f.Item_Identifier = i.Item_Identifier
GROUP BY f.Item_Identifier, i.Item_Type
ORDER BY Total_Sales DESC;


-- ===== QUERY 5.2: Average sales by outlet type =====
-- [ALREADY RUN - RESULT: Supermarket Type3 highest avg sales]
SELECT
    o.Outlet_Type,
    COUNT(*) AS Num_Transactions,
    AVG(f.Item_Outlet_Sales) AS Avg_Sales,
    SUM(f.Item_Outlet_Sales) AS Total_Sales
FROM dbo.fact_sales f
JOIN dbo.dim_outlet o ON f.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Type
ORDER BY Avg_Sales DESC;


-- ===== QUERY 5.3: Sales performance by outlet location type =====
SELECT
    o.Outlet_Location_Type,
    SUM(f.Item_Outlet_Sales) AS Total_Sales,
    AVG(f.Item_Outlet_Sales) AS Avg_Sales
FROM dbo.fact_sales f
JOIN dbo.dim_outlet o ON f.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Location_Type
ORDER BY Total_Sales DESC;


-- ===== QUERY 5.4: Fat content distribution (for donut chart) =====
SELECT
    Item_Fat_Content,
    COUNT(*) AS Item_Count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS Pct_Of_Total
FROM dbo.dim_item
GROUP BY Item_Fat_Content;


-- ===== QUERY 5.5: Sales performance by outlet age (for line chart) =====
SELECT
    o.Outlet_Establishment_Year,
    o.Outlet_Age,
    SUM(f.Item_Outlet_Sales) AS Total_Sales,
    AVG(f.Item_Outlet_Sales) AS Avg_Sales
FROM dbo.fact_sales f
JOIN dbo.dim_outlet o ON f.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Establishment_Year, o.Outlet_Age
ORDER BY o.Outlet_Establishment_Year;


-- ===== QUERY 5.6: Top-selling item types by total sales =====
SELECT
    i.Item_Type,
    SUM(f.Item_Outlet_Sales) AS Total_Sales
FROM dbo.fact_sales f
JOIN dbo.dim_item i ON f.Item_Identifier = i.Item_Identifier
GROUP BY i.Item_Type
ORDER BY Total_Sales DESC;


-- ===== QUERY 5.7: Average MRP by item type =====
SELECT
    Item_Type,
    AVG(Item_MRP) AS Avg_MRP
FROM dbo.dim_item
GROUP BY Item_Type
ORDER BY Avg_MRP DESC;


-- ===== QUERY 5.8: KPI summary block (Total Sales, Avg MRP, Item Count) =====
SELECT
    SUM(Item_Outlet_Sales) AS Total_Sales,
    (SELECT AVG(Item_MRP) FROM dbo.dim_item) AS Avg_MRP,
    (SELECT COUNT(DISTINCT Item_Identifier) FROM dbo.dim_item) AS Num_Items
FROM dbo.fact_sales;


-- ===== QUERY 5.9: Visibility quartile analysis (diagnostic) =====
-- [ALREADY RUN - RESULT: no positive correlation, lowest quartile
--  outsold highest quartile by ~25%]
;WITH VisibilityBuckets AS (
    SELECT
        f.Item_Outlet_Sales,
        f.Item_Visibility,
        NTILE(4) OVER (ORDER BY f.Item_Visibility) AS Visibility_Quartile
    FROM dbo.fact_sales f
)
SELECT
    Visibility_Quartile,
    COUNT(*) AS Num_Items,
    AVG(Item_Visibility) AS Avg_Visibility,
    AVG(Item_Outlet_Sales) AS Avg_Sales
FROM VisibilityBuckets
GROUP BY Visibility_Quartile
ORDER BY Visibility_Quartile;


-- ===== QUERY 5.10: Outlet performance ranking within each format =====
-- [NEXT TO RUN - identifies which specific outlets underperform peers]
SELECT
    o.Outlet_Identifier,
    o.Outlet_Type,
    SUM(f.Item_Outlet_Sales) AS Total_Sales,
    RANK() OVER (
        PARTITION BY o.Outlet_Type
        ORDER BY SUM(f.Item_Outlet_Sales) DESC
    ) AS Rank_Within_Type
FROM dbo.fact_sales f
JOIN dbo.dim_outlet o ON f.Outlet_Identifier = o.Outlet_Identifier
GROUP BY o.Outlet_Identifier, o.Outlet_Type
ORDER BY o.Outlet_Type, Rank_Within_Type;
