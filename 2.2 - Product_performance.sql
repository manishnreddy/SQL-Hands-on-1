/* Product performance Analysis-
Find out the report of Product and Store relationship towards sale.
Is there any category that outshines the rest .High demanded product among all locations as per the sales.*/

use store

SELECT
    ST.Store_Name,
    P.Product_Name,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit

FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
GROUP BY
    ST.Store_Name,
    P.Product_Name
ORDER BY
    ST.Store_Name ASC,
    Total_Revenue DESC;

--Is there any category that outshines the rest


SELECT 
   
    P.Product_Category,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit

FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
GROUP BY
   
    P.Product_Category
ORDER BY
    
    Total_Revenue DESC;


--High demanded product among all locations as per the sales.



SELECT top 1
   
    P.Product_Name,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit

FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
GROUP BY
   
    P.Product_Name
ORDER BY
    
    Total_Units_Sold DESC;




----- using CTE Is there any category that outshines the rest .High demanded product among all locations as per the sales.


	;WITH CategoryPerformance AS (
    -- CTE 1: Aggregate sales by category
    SELECT
        P.Product_Category,
        SUM(S.Units) AS Total_Units_Sold,
        SUM(S.Units * P.Product_retail_Price) AS Total_Revenue
    FROM
        SALES AS S
    INNER JOIN
        PRODUCTS AS P ON S.Product_ID = P.Product_ID
    GROUP BY
        P.Product_Category
),
ProductDemand AS (
    -- CTE 2: Aggregate sales by individual product (for high-demanded product)
    SELECT
        P.Product_Name,
        SUM(S.Units) AS Total_Units_Sold
    FROM
        SALES AS S
    INNER JOIN
        PRODUCTS AS P ON S.Product_ID = P.Product_ID
    GROUP BY
        P.Product_Name
)
-- Final SELECT 1: Find the Category that Outshines the Rest
SELECT TOP 100 PERCENT
    CP.Product_Category,
    CP.Total_Units_Sold,
    FORMAT(CP.Total_Revenue, 'C', 'en-US') AS Total_Revenue,
    RANK() OVER (ORDER BY CP.Total_Revenue DESC) AS Category_Rank
FROM
    CategoryPerformance AS CP
ORDER BY
    Category_Rank ASC;
-- Final SELECT 2: Find the High Demanded Product among all locations
-- NOTE: In a single query execution, you typically only run one SELECT. So run this second select query after.

/*
SELECT TOP 1
    PD.Product_Name,
    PD.Total_Units_Sold
FROM
    ProductDemand AS PD
ORDER BY
    PD.Total_Units_Sold DESC;
*/