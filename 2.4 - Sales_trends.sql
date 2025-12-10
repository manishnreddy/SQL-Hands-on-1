use store
/*Stores performance Analysis-
Find the sales trend over the different Stores and find the best and least five stores as per the performance in one query.
Does the area of store location  effect the sales of the product */

;WITH StorePerformance AS (
    -- CTE 1: Calculate the Total Revenue for each Store
    SELECT
        ST.Store_Name,
        ST.Store_City,
        ST.Store_Location,
        SUM(S.Units * P.Product_retail_Price) AS Total_Revenue
    FROM
        SALES AS S
    INNER JOIN
        STORES AS ST ON S.Store_ID = ST.Store_ID
    INNER JOIN
        PRODUCTS AS P ON S.Product_ID = P.Product_ID
    GROUP BY
        ST.Store_Name, ST.Store_City, ST.Store_Location
),
RankedStores AS (
    -- CTE 2: Apply the Window Function (RANK) to the results of CTE 1
    SELECT
        SP.Store_Name,
        SP.Store_City,
        SP.Store_Location,
        SP.Total_Revenue,
        -- Ranking for Best Stores (Highest Revenue = Rank 1)
        RANK() OVER (ORDER BY SP.Total_Revenue DESC) AS Store_Rank_Best,
        -- Ranking for Least Performing Stores (Lowest Revenue = Rank 1)
        RANK() OVER (ORDER BY SP.Total_Revenue ASC) AS Store_Rank_Least
    FROM
        StorePerformance AS SP
)
-- Final SELECT: Filter on the pre-calculated Rank columns
SELECT
    RS.Store_Name,
    RS.Store_City,
    RS.Store_Location,
    RS.Store_Rank_Best,
    RS.Store_Rank_Least
FROM
    RankedStores AS RS
WHERE
    -- Now we can filter on the calculated ranks!
    RS.Store_Rank_Best <= 5
    OR
    RS.Store_Rank_Least <= 5
ORDER BY
    RS.Store_Rank_Best ASC;


	--Does the area of store location  effect the sales of the product



	SELECT
    ST.Store_Location,
    COUNT(DISTINCT ST.Store_ID) AS Number_of_Stores,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue_by_Location,
    AVG(S.Units * P.Product_retail_Price) AS Avg_Revenue_Per_Store -- Better metric
FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
GROUP BY
    ST.Store_Location
ORDER BY
    Total_Revenue_by_Location DESC;


	/*
	Interpretation of Results:

High Volume Locations: 
                    Here Downtown locations show the highest Total_Revenue_by_Location, it suggests these areas are key to overall sales volume.
					 

High Efficiency Locations: 
                    Here a location like Airport has a high Avg_Revenue_Per_Store but a low Number_of_Stores, 
it suggests these few stores are highly effective, possibly due to higher traffic or less local competition.


Low Performance Locations: 
                    IF Residential areas show the lowest metrics, we might conclude that location type is less effective for your product sales.


*/