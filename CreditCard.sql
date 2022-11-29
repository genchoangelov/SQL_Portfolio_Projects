SELECT *
FROM PortfolioProject..BankChurners

--Looking Total Percentage of Attrited Customers

SELECT Attrition_Flag, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofAttrited
FROM   PortfolioProject..BankChurners
GROUP  BY Attrition_Flag

-- Looking for correlations between Attrited customers 

SELECT Card_Category, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofCardCategory
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Card_Category

-- 93% from Attrited Custemers was categorized with Blue Card
-- The possibillity of a customer with Blue type card category to leave a bank is higher then anouther type of cards.

SELECT Customer_Age, COUNT(*) AS AgeofAttritedClient
FROM PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP BY Customer_Age 
ORDER BY Customer_Age ASC

-----------------------
--ADD new Column Age_Categories for research purposes.
--------------------------------------------------------

ALTER TABLE PortfolioProject..BankChurners
      ADD Age_categories varchar(255);


UPDATE PortfolioProject..BankChurners
     set Age_categories = (CASE
                           WHEN Customer_Age < 30 THEN 'Under 30'
						   WHEN Customer_Age BETWEEN 30 AND 40 THEN '30 - 40'
             WHEN Customer_Age BETWEEN 40 AND 50 THEN '40 - 50'
             WHEN Customer_Age > 50 THEN 'Over 50'
             ELSE Null
                           END);
SELECT *
FROM PortfolioProject..BankChurners

SELECT Age_categories, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofAge_categories
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Age_categories

-- 48% of Attrited Custemer are between 40-50 years old and 31% are Over 50
-- The possibility of customers churning between the age range of 40-50 years is the highest followed by 50-60 years

SELECT Income_Category, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofIncomeCategory
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Income_Category

--37% of Attrited Customers have yearly income Less than $40K 

SELECT Months_Inactive_12_mon, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofMounthsInactive
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon DESC

-- 81% of Attrited Customers didn't use credit card at two or three mounts

SELECT Months_on_book, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofMounthsonBook
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Months_on_book
ORDER BY PercentageofMounthsonBook DESC

---------------------------------------------------------------------------------------------------

ALTER TABLE PortfolioProject..BankChurners
      ADD Months_on_book_Category varchar(255);


UPDATE PortfolioProject..BankChurners
     set Months_on_book_Category = (CASE
                           WHEN Months_on_book < 36 THEN 'Under 36'
						   WHEN Months_on_book >= 36 THEN 'Over 36'
							ELSE Null
                           END);
SELECT *
FROM PortfolioProject..BankChurners


SELECT Months_on_book_Category, 
       COUNT(*) AS count,
       CAST(100 AS DECIMAL (16, 3)) * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentageofMounthsonBookCategory
FROM   PortfolioProject..BankChurners
WHERE Attrition_Flag like '%Attrited%'
GROUP  BY Months_on_book_Category


-- 26% on 36th month of Attrited Customers and more than 50% after the 3rd year

-------------------------------------------------------------------------------------------
--Applying data from attrited customers to existing customers in order to identify existing customers who would abandon the bank's services

SELECT CLIENTNUM,  Attrition_Flag, Months_Inactive_12_mon, Income_Category, Card_Category, Months_on_book, Age_categories
FROM PortfolioProject..BankChurners
WHERE (Attrition_Flag like '%Existing%') 
	AND (Months_Inactive_12_mon = '3') 
	AND ((Income_Category like 'Less than $40k') OR (Income_Category like '$40K - $60K'))
	AND (Card_Category like 'Blue')
	AND (Months_on_book > '35') 
	AND ((Age_categories like 'Over 50') OR (Age_categories like '40 - 50'))
ORDER BY CLIENTNUM ASC

--Creating view to store data for later visualizations--------

CREATE VIEW PotentialAttritedClients111 AS
SELECT CLIENTNUM,  Attrition_Flag, Months_Inactive_12_mon, Income_Category, Card_Category, Months_on_book, Age_categories
FROM PortfolioProject..BankChurners
WHERE (Attrition_Flag like '%Existing%') 
	AND (Months_Inactive_12_mon = '3') 
	AND ((Income_Category like 'Less than $40k') OR (Income_Category like '$40K - $60K'))
	AND (Card_Category like 'Blue')
	AND (Months_on_book > '35') 
	AND ((Age_categories like 'Over 50') OR (Age_categories like '40 - 50'))


SELECT *
FROM PotentialAttritedClients111