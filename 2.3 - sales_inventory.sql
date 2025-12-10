use store

--Find out the avg_inventory as per the store and product.

SELECT
   st.Store_Name, p.Product_Name,
    P.Product_Category,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	--sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit,
	AVG(I.Stock_On_Hand) AS Avg_Stock_On_Hand
FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
INNER JOIN 
    INVENTORY AS I ON S.Store_ID = I.Store_ID AND S.Product_ID = I.Product_ID
	
GROUP BY
     st.Store_Name,
    P.Product_Category,
	p.Product_Name
ORDER BY
    st.Store_Name, p.Product_Category,
    Total_Revenue DESC;



	/*
	
Interpretation :

The resulting table provides the raw data for inventory health. To make it actionable, we would look at this data in relation to sales:

Low Stock / High Sales: If a product in a store has a low Avg_Stock_On_Hand but historically high sales (from my previous analysis),
it suggests a stock-out risk and potential missed revenue. This product is likely being understocked.

High Stock / Low Sales: If a product in a store has a high Avg_Stock_On_Hand but low sales, it suggests excess inventory. 
This product is tying up capital and taking up shelf space. This stock might need to be transferred or sold off at a discount.

*/



	--- Analysis to find product that are poorly stocked
	


	SELECT 
   st.Store_Name, p.Product_Name,
    P.Product_Category,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	--sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit,
	AVG(I.Stock_On_Hand) AS Avg_Stock_On_Hand
FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
INNER JOIN 
    INVENTORY AS I ON S.Store_ID = I.Store_ID AND S.Product_ID = I.Product_ID
	
GROUP BY
     st.Store_Name,
    P.Product_Category,
	p.Product_Name
HAVING AVG(I.Stock_On_Hand) < 5
ORDER BY
    st.Store_Name, p.Product_Category,
    Total_Revenue DESC;


		--- Analysis to find product that are over stocked


		SELECT 
   st.Store_Name, p.Product_Name,
    P.Product_Category,
    SUM(S.Units) AS Total_Units_Sold,
    SUM(S.Units * P.Product_retail_Price) AS Total_Revenue,
	--sum(S.units*(P.Product_retail_Price-P.Product_Cost)) as Total_profit,
	AVG(I.Stock_On_Hand) AS Avg_Stock_On_Hand
FROM
    SALES AS S
INNER JOIN
    STORES AS ST ON S.Store_ID = ST.Store_ID
INNER JOIN
    PRODUCTS AS P ON S.Product_ID = P.Product_ID
INNER JOIN 
    INVENTORY AS I ON S.Store_ID = I.Store_ID AND S.Product_ID = I.Product_ID
	
GROUP BY
     st.Store_Name,
    P.Product_Category,
	p.Product_Name
HAVING AVG(I.Stock_On_Hand) > 50
ORDER BY
    st.Store_Name, p.Product_Category,
    Total_Revenue DESC;





	select salary 
	row_number() over ( order by salary asc ) as row_sal 
	from emp 
	where row_sal =2 
	order by row_sal desc
	