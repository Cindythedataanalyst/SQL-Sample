/**Background:
This Capstone Project marks the culmination of completing the Google Data Analytics Professional Certificate. As a junior data analyst at 
Cyclistic, my task involves analyzing historical bike trip data to inform marketing strategies, specifically targeting the conversion of 
casual riders to annual members. Working alongside the marketing director, our objective is to understand the behaviors and preferences
of these rider segments through thorough data analysis and visualization, paving the way for targeted marketing campaigns and strategic
decision-making.**/

--Step 1: Ask

--Target question: How do annual members and casual riders use Cyclistic bikes differently?

--Step 2: Prepare

/**Target question: How do annual members and casual riders use Cyclistic bikes differently?
The analysis relies on Cyclistic's historical trip data, covering the last six months, sourced from Motivate International Inc. under a 
specific license. **/

/**Data cleaning was partially completed in Excel before importing the data. This process involved making copy from raw 
data for data cleaning, removing irrelevant and duplicate data, fixing structural errors, and handling missing data.**/

--Import the Cyclistic's historical trip data of the previous 6 months.
--Combining the last 6 months Cyclistic's historical trip data.

SELECT * INTO joined_data
FROM (
    SELECT * FROM [Casestudy].[dbo].[202312-divvy-tripdata]
    UNION ALL
    SELECT * FROM [Casestudy].[dbo].[202311-divvy-tripdata]
	union all
	 SELECT * FROM [Casestudy].[dbo].[202401-divvy-tripdata]
    UNION ALL
    SELECT * FROM [Casestudy].[dbo].[202310-divvy-tripdata]
	  UNION ALL
    SELECT * FROM [Casestudy].[dbo].[202309-divvy-tripdata]
	  UNION ALL
    SELECT * FROM [Casestudy].[dbo].[202308-divvy-tripdata]
) AS combined_data;

Select *
From [Casestudy].[dbo].[joined_data];

--Continue data clean in SQL.

--Data cleaning: convert data types.Convert ride_length_mn data to decimal for future calculation.

ALTER TABLE [Casestudy].[dbo].[joined_data]
ALTER COLUMN ride_length_mn DECIMAL(10, 2);

/**Data cleaning: standardize and validate data. the combined data covered the bike share history in the last 12 months,
the data followed the constraints for its feild.the data makes sense for analysis. **/


Select 
	sum(Cast(ride_length_mn as decimal(10,2))) as total_ride_length_mn,
	member_casual
FROM [Casestudy].[dbo].[202302-divvy-tripdata]
Group By
	member_casual;

--Select data we are going to be using.

/**Looking at the frequency of rides for each group, to see if one group tends to use the bikes more frequently than 
the other, which showed members use the bike more frequently.**/

SELECT 
    member_casual,
    COUNT(*) AS ride_count
FROM 
    [Casestudy].[dbo].[joined_data]
GROUP BY 
    member_casual;

--Analyzing difference in average ride length between members and casual riders.

SELECT 
    member_casual,
    COUNT(*) AS total_rides,
    AVG(ride_length_mn)
	AS average_ride_duration
FROM [Casestudy].[dbo].[joined_data]
GROUP BY 
    member_casual;

--Analyzing the percentage of members and casual riders.

Select 
	member_casual,
	COUNT (member_casual) AS member_casual_count
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual;

SELECT 
    member_casual,
    COUNT(*) AS member_casual_count,
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS percentage
FROM [Casestudy].[dbo].[joined_data]
GROUP BY member_casual;

--Analyzing the average ride length on different days of the week for both member and casual riders.

Select 
	top 3
	member_casual,
	COUNT (member_casual) AS member_casual_count,
	day_of_week
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual,
	day_of_week
Order by 
	day_of_week;

--Analyzing the longest ride length, and the shortest ride length.

Select 
	member_casual,
	max (ride_length_mn) AS longest_ride_length,
	min (ride_length_mn) as shortest_ride_length
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual;

--Analyzing the difference of rideable type between members and casual riders.

Select 
	member_casual,
	rideable_type,
	Count (*) As ride_count
From [Casestudy].[dbo].[joined_data]
Where rideable_type <>'docked_bike'
Group by
	member_casual,
	rideable_type;

--Analyzing the longest and shortest ride lengths of the month.

Select 
	member_casual,
	ride_date,
	max (ride_length_mn) AS longest_ride_length,
	min (ride_length_mn) as shortest_ride_length
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual,
	ride_date
Order by
	ride_date;

--Analyzing the total ride length by month for both member and casual riders.

Select 
	member_casual,
	ride_date,
	SUM (ride_length_mn) AS total_ride_length
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual,
	ride_date
Order by
	ride_date;

--Analyzing the difference in average ride length between members and casual riders across different months.

Select 
	member_casual,
	ride_date,
	avg (ride_length_mn) AS average_ride_length
From [Casestudy].[dbo].[joined_data]
Group by
	member_casual,
	ride_date
Order by
	ride_date;

--Displaying the top 3 months with the longest average ride length for both members and casual riders.

SELECT 
    TOP 3
    ride_date,
	member_casual,
    AVG(ride_length_mn) AS average_ride_length
FROM [Casestudy].[dbo].[joined_data]
GROUP BY
	member_casual,
    ride_date
ORDER BY
    average_ride_length DESC;

--Calculating the average ride length in different days of the week between members and casual riders.

Select 
	day_of_week,
	avg(ride_length_mn) as average_ride_length
FROM 
	[Casestudy].[dbo].[joined_data]
Group By
	day_of_week
Order by
	average_ride_length desc;

Select 
	day_of_week,
	member_casual,
	avg(ride_length_mn) as average_ride_length,
	Count(*) as ride_count
FROM 
	[Casestudy].[dbo].[joined_data]
Where 
	day_of_week IN (1,7)
Group By
	day_of_week,
	member_casual
Order by 
	day_of_week;

--Analyzing ride patterns during weekdays vs. weekends by segmentation by time periods.

SELECT
    CASE
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        WHEN day_of_week = 7 THEN 'Saturday'
    END AS day_of_week_name,
    COUNT(*) AS total_rides
FROM
    [Casestudy].[dbo].[joined_data]
GROUP BY
    CASE
        WHEN day_of_week IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END,
    day_of_week
Order by
	total_rides desc; 

/**Through meticulous SQL analysis amalgamating six datasets, I delineated the divergent riding behaviors of Cyclistic's members and casual
riders, revealing members' higher ride frequency and casual riders' penchant for longer journeys. Surprisingly, both groups converge on 
Wednesdays as their peak riding day, with August 2023 standing out as the pinnacle of ridership, laying a compelling foundation for 
strategic marketing initiatives.**/
