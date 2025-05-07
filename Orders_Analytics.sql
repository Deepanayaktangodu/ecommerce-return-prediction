-- Step 1: Initial Setup

--A) Load dataset into SSMS (SQL Server Management Studio).

--B) Clean and explore data using SQL:

    --Basic SELECT queries

	--Check if data types are fine

	--See a few sample rows

	--Plan important fields (e.g., Date, Return Flag)

-- Step 1.2: Basic Data Check in SSMS.

-- First, run this SQL query to view a few rows:

Select top 10* 
	From dbo.order_dataset;

	---This gives us a quick glimpse of the data you imported.

-- Second, check the table structure and datatype correctness.

EXEC sp_columns 'order_dataset', 'dbo';

	---This shows column names, data types, and lengths.

-	--We can confirm if important columns like Date, Final Quantity, Refunds have the correct data types.

--Third, count the number of rows:

SELECT COUNT(*) 
	FROM dbo.order_dataset;

	---Just to confirm full data was loaded (expecting ~70,052 rows).

--Step 2: Data Cleaning!

-- Step 2.1: Create the Is_Returned column.

--Why are we creating Is_Returned?

	---To easily identify if an order was returned or not returned.

--We'll check Final_Quantity or Refunded_Item_Count:

	---If they are negative (< 0) ➔ It means Returned ➔ Is_Returned = 1

	--- Else ➔ It means Not Returned ➔ Is_Returned = 0

--First, add a new column to the table:

ALTER TABLE dbo.order_dataset
	ADD Is_Returned INT;

--Second, update the values based on return logic:

UPDATE dbo.order_dataset
SET Is_Returned = CASE 
                     WHEN Final_Quantity < 0 OR Refunded_Item_Count < 0 THEN 1
                     ELSE 0
                  END;

-- Third, quickly check if it’s added properly:

SELECT TOP 10 Item_Name, Final_Quantity, Refunded_Item_Count, Is_Returned
	FROM dbo.order_dataset;

--Step 2.2: Fix the Date Column

--Right now, the Date field is stored as text (nvarchar).

--We need it as a proper DATE datatype so that:
	---We can later do monthly/weekly trend analysis
	---It makes dashboards cleaner in Power BI
	---Modeling becomes easier in Python later.

-- Here is the execusion plan:

-- Since directly changing a column’s datatype is risky,
--Creating a new column Order_Date with correct date format.

--Step 1: Add a new column Order_Date

ALTER TABLE dbo.order_dataset
	ADD Order_Date DATE;

-- Step 2: Update the new column with correct date values

UPDATE dbo.order_dataset
	SET Order_Date = TRY_CONVERT(DATE, Date, 103);

--  Step 3: Check if conversion is successful

SELECT TOP 10 Date, Order_Date
	FROM dbo.order_dataset;

--Step 3: Exploratory Data Analysis (EDA)

--Here’s what we’ll explore next:

	---Total orders vs Returned orders ➔ return rate

	---Return % by Product Category

	---Return % by Time (monthly trend)

	---Impact of Price Reductions on Returns

--Step 1: Basic Return Rate Overview.

--Goal:
	---Find total number of orders and how many were returned.

	---Calculate Return Rate %.

-- Step 1. Find Total Orders and Total Returns

SELECT 
    COUNT(*) AS Total_Orders,
    SUM(Is_Returned) AS Total_Returns
FROM dbo.order_dataset;

--COUNT(*) ➔ counts all orders.

--SUM(Is_Returned) ➔ counts how many orders were returns (since returns are marked as 1).

-- Step 2. Find Return Rate (%)

SELECT 
    ROUND((CAST(SUM(Is_Returned) AS FLOAT) / COUNT(*)) * 100, 2) AS Return_Rate_Percentage
FROM dbo.order_dataset;

-- The percentage of orders that were returned.

---EDA Step 1 Results:

--Total Orders: 70,052

--Total Returns: 10,783

--Return Rate %: ~15.39%

--This means that around 15% of all orders are getting returned — which is a significant number!
--(A company would definitely want to reduce this to save costs and improve profits.)

--What this tells us:
	---There’s a good enough return rate issue to justify predictive modeling and dashboards.

	---We already have a business problem ready to discuss in the project report and interviews:

	---"Analyzed customer returns where 15% of orders were getting returned, leading to profitability loss."

--EDA Step 2:

--Find Return Rate by Product Category — to know which product categories are causing more returns.

SELECT 
    Category,
    COUNT(*) AS Total_Orders,
    SUM(Is_Returned) AS Total_Returns,
    ROUND( (CAST(SUM(Is_Returned) AS FLOAT) / COUNT(*)) * 100, 2) AS Return_Rate_Percentage
FROM dbo.order_dataset
GROUP BY Category
ORDER BY Return_Rate_Percentage DESC;

--This will give:

	---Each product category

	---How many orders

	---How many returns

	---Return rate %

--Return Rate by Product Category (Summary)

--Rank		Category		Return Rate (%)		Key Observation
	1		Product S		100.00%				Only 1 order and it was returned (small volume)
	2		Product T		20.18%				High returns
	3		Product U		20.10%				High returns
	4		Product K		20.00%				High returns
	5		Product I		17.50%				Moderate returns

--Product categories like S, T, U, K, and I have much higher return rates compared to others.
--Some products have very low return rates (like Product Q, Product P).

--What this tells us:

	---Not all products are equal — some categories are way riskier for returns.

	---In your Power BI dashboard, later you can highlight these high-return categories.

--EDA Step 3: Return Rate Trend by Month

--This will help us see if returns are higher in specific months (e.g., festival seasons).

--Goal:

	---Find out in which months returns are higher.

	---Identify seasonal patterns — very useful for business decisions.

SELECT 
    FORMAT(Order_Date, 'yyyy-MM') AS Month_Year,
    COUNT(*) AS Total_Orders,
    SUM(Is_Returned) AS Total_Returns,
    ROUND( (CAST(SUM(Is_Returned) AS FLOAT) / COUNT(*)) * 100, 2) AS Return_Rate_Percentage
FROM dbo.order_dataset
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Month_Year;

--FORMAT(Order_Date, 'yyyy-MM') ➔ extracts Year and Month.

--We group data month-wise and calculate total orders, returns, and return %.

--Month-wise Return Rate Summary:

--Month-Year	Return Rate (%)		Key Insight
2019-01			23.41%				Highest return rate — almost 1 in 4 orders!
2019-02			16.63%				High returns after Jan spike
2018-12			15.18%				High returns — likely due to end-year sales
2019-03			13.56%				Decreasing returns
2019-04			12.95%				Decreasing returns further
2018-11			11.88%				Lowest among these months

--Insights:

	---January 2019 saw the highest return spike.

	---Possible reason: people returning products bought during Christmas/New Year sales.

	---Return rates decreased over time after January.

	---November-December 2018 had steady but moderate returns, possibly due to festival season purchases (Diwali, Christmas).

SELECT * FROM dbo.order_dataset;