-- Final project SQL Analysing Video Games Sales
--





--Sulution to task №2a How many games have been released with 3 or more Platforms?
SELECT COUNT(DISTINCT Name) AS Num_Of_Games_Mult_Consoles
FROM
	(SELECT *
	, ROW_NUMBER() OVER(PARTITION BY Name ORDER BY Name) AS RowNum
	FROM Video_Games) a
WHERE RowNum >= 3

--Solution to task 2b In which year was the number of Genres at their peak?
SELECT Year_of_Release, COUNT(Genre) AS NumOfGenre
FROM
	(SELECT Year_of_Release, Genre, NumOfGames
	FROM
	(SELECT *, ROW_NUMBER() OVER (PARTITION BY Genre ORDER BY NumOfGames DESC) AS NUMROW
	FROM
		(SELECT Year_of_Release, Genre, COUNT(Name) AS NumOfGames
	
		FROM Video_Games
		GROUP BY Year_of_Release, Genre) a 
	) b
WHERE NUMROW = 1 ) c
GROUP BY Year_of_Release
ORDER BY NumOfGenre DESC



--Solution to task 3 Full
--Solution to task 3a Weighted Average
WITH a
AS
(SELECT
Rating
,ROUND(SUM(Critic_Score * Critic_Count)/SUM(Critic_Count), 1) AS Critic_Score_We
FROM Video_Games
GROUP BY Rating) 
,
--Solution to task №3b Average
b
AS
(SELECT *
FROM
	(SELECT
	 Rating
	,ROUND(SUM(Critic_Score) / COUNT(Critic_Score), 1) AS AVGCriticScore
	FROM Video_Games
	GROUP BY Rating) a)
,
c
AS
--Sulution to task №3c Mode
(SELECT Rating, Critic_Score 
FROM
	(SELECT Critic_Score
	, NumOfScores
	, DENSE_RANK() OVER(PARTITION BY Rating ORDER BY NumOfScores DESC) AS NUMOFROW
	, Rating
	FROM
		(SELECT Critic_Score, COUNT(Critic_Score) AS NumOfScores, Rating
		FROM Video_Games
		GROUP BY Rating, Critic_Score) a 
	) b
WHERE NUMOFROW = 1 AND Critic_Score <> 62 AND Critic_Score <>66)

SELECT a.Rating, a.Critic_Score_We, b.AVGCriticScore, c.Critic_Score AS ModeCriticScore
FROM a JOIN b
			ON a.Rating = b.Rating
	   INNER JOIN c
			ON a.Rating = c.Rating
WHERE a.Rating NOT IN ('EC') 
ORDER BY Critic_Score_We DESC




--Solution to task №4 Please provide the global sales by genre, Platform, and Year.
WITH a
AS
--Basically getting Global_Sales per Genre, Platform, Year_of_Release, adding Lead_Year_of_release and getting every date to a decently looking format
(SELECT *, ISNULL(Lead_Year_of_Release, DATEADD(yyyy, 1, Year_of_Release)) AS Year_of_Release1
FROM
		(SELECT *, LEAD(Year_of_Release, 1) OVER (PARTITION BY Genre, Platform ORDER BY Year_of_Release) AS Lead_Year_of_Release
		FROM
			(SELECT SUM(Global_Sales) AS Global_Sales
			, Genre
			, Platform
			, CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
			FROM Video_Games
			WHERE Year_of_Release IS NOT NULL
			GROUP BY Genre, Platform, Year_of_Release) 
		a) 
b)
,
b
AS
--Getting the timeline for the current dataset with decent looking dates
(SELECT DISTINCT CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
FROM Video_Games
WHERE Year_of_Release IS NOT NULL AND Year_of_Release <> 2020)
,
c
AS
--Getting another table with Global_Sales with the rest of the coloumns with help of which we are connecting Global_Sales to the final full table (where some years were missing)
(SELECT SUM(Global_Sales) AS Global_Sales
, Genre
, Platform
, CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
FROM Video_Games
WHERE Year_of_Release IS NOT NULL
GROUP BY Genre, Platform, Year_of_Release)

--The final querry which connects all the data from all the previous CTSs
SELECT ISNULL(c.Global_Sales, 0) AS Global_Sales
, ab.Genre, ab.Platform
, ab.Year_of_Release
FROM
	(SELECT
	a.Genre
	,a.Platform
	,b.Year_of_Release
	FROM b LEFT JOIN a 
				ON (b.Year_of_Release >= a.Year_of_Release AND b.Year_of_Release < a.Year_of_Release1)) ab
		   LEFT JOIN c
				ON (ab.Genre = c.Genre AND ab.Platform = c.Platform AND ab.Year_of_Release = c.Year_of_Release)
ORDER BY ab.Genre, ab.Platform, ab.Year_of_Release






--Solution to task №5 Year over Year analysis

WITH a
AS
(SELECT *, ISNULL(Lead_Year_of_Release, DATEADD(yyyy, 1, Year_of_Release)) AS Year_of_Release1
FROM
		(SELECT *, LEAD(Year_of_Release, 1) OVER (PARTITION BY Platform ORDER BY Year_of_Release) AS Lead_Year_of_Release
		FROM
			(SELECT SUM(Global_Sales) AS Global_Sales
			, Platform
			, CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
			FROM Video_Games
			WHERE Year_of_Release IS NOT NULL
			GROUP BY Platform, Year_of_Release) 
		a) 
b)
,
b
AS
--Getting the timeline for the current dataset with decently looking dates
(SELECT DISTINCT CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
FROM Video_Games
WHERE Year_of_Release IS NOT NULL AND Year_of_Release <> 2020)
,
c
AS
--Getting ready another set of Data in order to withdraw Global_Sales after joining tables
(SELECT SUM(Global_Sales) AS Global_Sales
, Platform
, CAST(CAST(Year_of_Release AS char(4)) + '-' + '01' + '-' + '01' AS DATE) AS Year_of_Release
FROM Video_Games
WHERE Year_of_Release IS NOT NULL
GROUP BY Platform, Year_of_Release)

--Joining all the CTEs and final calculations in order to get the final results
SELECT ROUND(Global_Sales, 2) AS Global_Sales, ROUND(Lead_Global_Sales, 2) AS Lead_Global_Sales, ISNULL(YoY, 0) AS YoY, Platform, Year_of_Release, RowNumber
FROM
		(SELECT Global_Sales
		, ISNULL(Lead_Global_Sales, 0) AS Lead_Global_Sales
		--Creating CASE for counting all YoY not including the very 1 year of companies' existance
		, CASE WHEN RowNumber > 1 THEN 
											CASE WHEN Global_Sales <> 0 THEN ROUND((Global_Sales/Lead_global_Sales) -1, 4) * 100 ELSE 0 END										 									 
		ELSE 0
		END AS YoY 
		, Platform
		, Year_of_Release
		, RowNumber
		FROM
		--Making a column with previous Global sales with help of the Lag Function
				(SELECT ISNULL(c.Global_Sales, 0) AS Global_Sales
				, LAG(c.Global_Sales, 1, 0) OVER (PARTITION BY ab.Platform ORDER BY ab.Year_of_Release) AS Lead_Global_Sales
				, ab.Platform
				, ab.Year_of_Release
				, ROW_NUMBER() OVER (PARTITION BY ab.Platform ORDER BY ab.Year_of_Release) AS RowNumber
				FROM
						(SELECT
						a.Platform
						,b.Year_of_Release
					--Joining all 3 CTEs
						FROM b LEFT JOIN a 
							ON (b.Year_of_Release >= a.Year_of_Release AND b.Year_of_Release < a.Year_of_Release1)) ab
				LEFT JOIN c
						ON ( ab.Platform = c.Platform AND ab.Year_of_Release = c.Year_of_Release)) abc 
) abcd
	--ORDERING The final final results
ORDER BY /*YoY DESC */abcd.Platform, abcd.Year_of_Release /* to check what YoY was the highest apply YoY DESC*/ 
/*The most significant growth rate of 102600 % within the Dataset was recorded in 2001 for GB Platform. */

















