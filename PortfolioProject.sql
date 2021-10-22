/*AS the Data Files are stored by month, I had to download and unite all of them.
There were 8 files (months) which I couldn't unite because of some data type mistake.
So I had to find them by hand and find out what the problem was.
The coloumn BirthDate held NULL values in those files. So, by using MS Excel, 
I found those cells and replaced NULL with blank spaces. Everything worked OK after that
https://www.citibikenyc.com/system-data*/

--So lets creat a new table with all the Data over all of the months
--1
SELECT *   INTO  All_Rides
FROM [201509]    
UNION SELECT * FROM [201510]
UNION SELECT * FROM [201511]
UNION SELECT * FROM [201512]
UNION SELECT * FROM [201601]
UNION SELECT * FROM [201602]
UNION SELECT * FROM [201603]
UNION SELECT * FROM [201604]
UNION SELECT * FROM [201605]
UNION SELECT * FROM [201606]
UNION SELECT * FROM [201607]
UNION SELECT * FROM [201608]
UNION SELECT * FROM [201609]
UNION SELECT * FROM [201610]
UNION SELECT * FROM [201611]
UNION SELECT * FROM [201612]
UNION SELECT * FROM [201701]
UNION SELECT * FROM [201702]
UNION SELECT * FROM [201703]
UNION SELECT * FROM [201704]
UNION SELECT * FROM [201705]
UNION SELECT * FROM [201706]
UNION SELECT * FROM [201707]
UNION SELECT * FROM [201708]
UNION SELECT * FROM [201709]
UNION SELECT * FROM [201710]
UNION SELECT * FROM [201711]
UNION SELECT * FROM [201712]
UNION SELECT * FROM [201801]
UNION SELECT * FROM [201802]
UNION SELECT * FROM [201803]
UNION SELECT * FROM [201804]
UNION SELECT * FROM [201805]
UNION SELECT * FROM [201806]
UNION SELECT * FROM [201807]
UNION SELECT * FROM [201808]
UNION SELECT * FROM [201809]
UNION SELECT * FROM [201810]
UNION SELECT * FROM [201811]
UNION SELECT * FROM [201812]
UNION SELECT * FROM [201901]
UNION SELECT * FROM [201902]
UNION SELECT * FROM [201903]
UNION SELECT * FROM [201904]
UNION SELECT * FROM [201905]
UNION SELECT * FROM [201906]
UNION SELECT * FROM [201907]
UNION SELECT * FROM [201908]
UNION SELECT * FROM [201909]
UNION SELECT * FROM [201910]
UNION SELECT * FROM [201911]
UNION SELECT * FROM [201912]
UNION SELECT * FROM [202001]
UNION SELECT * FROM [202002]
UNION SELECT * FROM [202003]
UNION SELECT * FROM [202004]
UNION SELECT * FROM [202005]
UNION SELECT * FROM [202006]
UNION SELECT * FROM [202007]
UNION SELECT * FROM [202008]
UNION SELECT * FROM [202009]
UNION SELECT * FROM [202010]
UNION SELECT * FROM [202011]
UNION SELECT * FROM [202012]
UNION SELECT * FROM [202101]



--Let's explore our Data
SELECT Trip_Duration
, Start_Time
, Stop_Time
, Start_Station_ID
, Start_Station_Name
, Start_Station_Latitude
, Start_Station_Longitude
, End_Station_ID
, End_Station_Name
, End_Station_Latitude
, End_Station_Longitude
, Bike_ID
, User_Type
, Birth_Year
, Gender
FROM All_Rides
ORDER BY Start_Time ASC


--2 Let's find 10 most popular start station over all months
SELECT TOP 10 Start_Station_ID
, Start_Station_Name
, Amount_of_Starts
FROM
	(SELECT Distinct Start_Station_ID
	, Start_Station_Name
	, COUNT(Start_Time) AS 'Amount_of_Starts'
	FROM All_Rides
	GROUP BY Start_Station_Name, Start_Station_ID) a
ORDER BY Amount_of_Starts DESC



--3 Let's find out what the percentage of all the starts per each station overall

SELECT Start_Station_ID
, Start_Station_Name
, ROUND(Amount_of_Starts/CAST((SELECT COUNT(Start_Time) FROM ALL_Rides) AS FLOAT) * 100, 3) AS Percentage_STarts_Per_Station
FROM
	(SELECT Distinct Start_Station_ID
	, Start_Station_Name
	, COUNT(Start_Time) AS 'Amount_of_Starts'
	FROM All_Rides
	GROUP BY Start_Station_Name, Start_Station_ID) a
ORDER BY Amount_of_Starts DESC



--4 Let's find out how the amount of rides of all the stations changed in all the years
WITH a 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2015%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
b 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2016%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
c 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2017%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
d 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2018%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
e 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2019%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
f 
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2020%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
g
AS
(SELECT Distinct Start_Station_ID
, Start_Station_Name
, COUNT(Start_Time) AS 'Amount_of_Starts'
FROM All_Rides
WHERE Start_Time LIKE'%2021%'
GROUP BY Start_Station_ID, Start_Station_Name)
,
k
AS
(SELECT DISTINCT Start_Station_ID
, Start_Station_Name
FROM ALL_Rides)

SELECT k.Start_Station_ID
, k.Start_Station_Name
, a.Amount_of_Starts AS '2015'
, b.Amount_of_Starts AS '2016'
, c.Amount_of_Starts AS '2017'
, d.Amount_of_Starts AS '2018'
, e.Amount_of_Starts AS '2019'
, f.Amount_of_Starts AS '2020'
, g.Amount_of_Starts AS '01.2021'

FROM k FULL JOIN a
				ON k.Start_Station_ID = a.Start_Station_ID
	FULL JOIN b
				ON k.Start_Station_ID = b.Start_Station_ID
	FULL JOIN c
				ON k.Start_Station_ID = c.Start_Station_ID
	FULL JOIN d 
				ON k.Start_Station_ID = d.Start_Station_ID
	FULL JOIN e
				ON k.Start_Station_ID = e.Start_Station_ID
	FULL JOIN f
				ON k.Start_Station_ID = f.Start_Station_ID
	FULL JOIN g 
				ON k.Start_Station_ID = g.Start_Station_ID
ORDER BY f.Amount_of_Starts DESC


--5
--Lets check how the amount of bikes in use grew (if so) over years
WITH a
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2015%'
GROUP BY DATEPART(yyyy, Start_Time))
,
b
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2016%'
GROUP BY DATEPART(yyyy, Start_Time))
,
c
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2017%'
GROUP BY DATEPART(yyyy, Start_Time))
,
d
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2018%'
GROUP BY DATEPART(yyyy, Start_Time))
,
e
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2019%'
GROUP BY DATEPART(yyyy, Start_Time))
,
f
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2020%'
GROUP BY DATEPART(yyyy, Start_Time))
,
i
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, COUNT(DISTINCT Bike_ID) AS Amount_of_Bikes
FROM All_Rides
WHERE Start_Time LIKE '2021%'
GROUP BY DATEPART(yyyy, Start_Time))

SELECT Year_Time, Amount_of_Bikes
FROM a
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM b
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM c
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM d
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM e
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM f
UNION ALL
SELECT Year_Time, Amount_of_Bikes
FROM i
ORDER BY Year_Time ASC



--6 Lets count the average trip duration per year and see if it grows or goes down
WITH a
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2015%'
GROUP BY DATEPART(yyyy, Start_Time))
,
b
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2016%'
GROUP BY DATEPART(yyyy, Start_Time))
,
c
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2017%'
GROUP BY DATEPART(yyyy, Start_Time))
,
d
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2018%'
GROUP BY DATEPART(yyyy, Start_Time))
,
e
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2019%'
GROUP BY DATEPART(yyyy, Start_Time))
,
f
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2020%'
GROUP BY DATEPART(yyyy, Start_Time))
,
g
AS
(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
, SUM(Trip_Duration)/COUNT(Trip_Duration) AS AVG_Trip_Duration
FROM All_Rides
WHERE Start_Time LIKE '2021%'
GROUP BY DATEPART(yyyy, Start_Time))

SELECT *
FROM a
UNION ALL
SELECT *
FROM b
UNION ALL
SELECT *
FROM c
UNION ALL
SELECT *
FROM d
UNION ALL
SELECT *
FROM e
UNION ALL
SELECT *
FROM g
ORDER BY Year_Time ASC

--7 Lets check the amount of Customers and Subscribers per year

SELECT *
FROM
		(SELECT DATEPART(yyyy, Start_Time) AS Year_Time
		, User_Type
		, count(*) AS Amount_of_Starts
		  FROM All_Rides
		 GROUP BY DATEPart(yyyy, Start_Time), User_Type) a
WHERE User_type IS NOT NULL AND Amount_of_Starts <> 30
ORDER BY YEAR_TIME, USER_Type ASC


 --8 Lets take a look at all rides per month per year

 SELECT DATEPART(yyyy, Start_Time) AS Year_
 , DATENAME(Month, Start_Time) AS Month_
 , COUNT(Start_TIME) Amount_Of_Rides
 FROM ALL_Rides
 GROUP BY DATEPART(yyyy, Start_Time), DATENAME(Month, Start_Time)
 ORDER BY 1



 -- 9 Lets find top 4 months every year with most of rides
 SELECT *
 FROM
		 (SELECT *
		 , ROW_NUMBER () OVER (PARTITION BY Year_ ORDER BY Amount_of_Rides DESC) AS Row_NUM
		 FROM 
				 (SELECT DATEPART(yyyy, Start_Time) AS Year_
				 , DATENAME(Month, Start_Time) AS Month_
				 , COUNT(Start_TIME) Amount_Of_Rides
				 FROM ALL_Rides
				 GROUP BY DATEPART(yyyy, Start_Time)
				 , DATENAME(Month, Start_Time)) a
		) b
WHERE Row_NUM BETWEEN 1 AND 4


--10 Lets find the busiest bike in NYC over all period of time and how many times it was used
--a) The bike that was the longest time in use is ID 24502 BIKE
SELECT Bike_ID
, Count(Start_Time) AS Times_in_Use
, SUM(Trip_Duration)/60 AS Mins_in_USE
FROM All_Rides
GROUP BY Bike_ID
ORDER BY Mins_in_USE DESC


--b) The bike that was most of all times in use is ID 26269 Bike
SELECT Bike_ID
, Count(Start_Time) AS Times_in_Use
, SUM(Trip_Duration)/60 AS Mins_in_USE
FROM All_Rides
GROUP BY Bike_ID
ORDER BY Times_in_USE DESC

--11 Lets count TOP 10 most popular trips (based on start station and stop station) per Year
SELECT YYear
, Trip
, Amount_of_Trips
, ROW_Num
FROM
		(SELECT *
		, ROW_NUMBER() OVER (PARTITION BY YYEAR ORDER BY YYear, Amount_of_Trips DESC) AS ROW_Num
		FROM
			(SELECT YYear
			, Trip
			, COUNT(Trip) AS Amount_of_Trips
			FROM
				(SELECT DATEPART(yyyy, Start_Time) AS YYear
				, Start_Station_Name+'-'+End_Station_Name AS Trip
				FROM All_Rides) a
			GROUP BY YYear, Trip
			) b
)c
WHERE ROW_NUM BETWEEN 1 AND 10
ORDER BY 1, 3 DESC