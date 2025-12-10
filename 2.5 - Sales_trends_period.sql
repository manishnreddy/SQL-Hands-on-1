
/*Sales Trend Analysis : 
	Monthly wise sales trend over the stores, location for both year(2022 & 2023) */
	use store
	SELECT
    YEAR(S.Date) AS Sale_Year,
    MONTH(S.Date) AS Sale_Month,
    ST.Store_Name,
    ST.Store_Location,

    -- Aggregated Sales Metrics
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
    SUM(S.Units * (P.Product_retail_Price - P.Product_Cost)) AS Total_Profit

FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID

-- Filter for the specific years (2022 and 2023)
WHERE
    YEAR(S.Date) IN (2022, 2023)
GROUP BY
    YEAR(S.Date),
    MONTH(S.Date),
    ST.Store_Name,
    ST.Store_Location

-- Order for a clear trend view
ORDER BY
    Sale_Year,
    Sale_Month,
	Total_Profit desc;