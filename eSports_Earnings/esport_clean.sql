--Check each table to get a glimpse of them

--country & continent
SELECT TOP (100) 
    [Continent_Name],
    [Continent_Code],
    [Country_Name],
    [Two_Letter_Country_Code],
    [Three_Letter_Country_Code],
    [Country_Number]
FROM 
    [eSports_Earnings].[dbo].['country-and-continent-codes-lis$'];

--players earning
SELECT TOP (100) 
    [PlayerId],
    [NameFirst],
    [NameLast],
    [CurrentHandle],
    [CountryCode],
    [TotalUSDPrize],
    [Game],
    [Genre]
FROM 
    [eSports_Earnings].[dbo].[highest_earning_players$];

--team earnings
SELECT TOP (100) 
    [TeamId],
    [TeamName],
    [TotalUSDPrize],
    [TotalTournaments],
    [Game],
    [Genre]
FROM 
    [eSports_Earnings].[dbo].[highest_earning_teams$];

--Next I want to search if their is any values that are null per table

SELECT 
    SUM(total_nulls) AS total_nulls_in_table 
FROM
    (
    SELECT
        (CASE WHEN Continent_Name IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Continent_Code IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN Country_Name IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Two_Letter_Country_Code IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN Three_Letter_Country_Code IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Country_Number IS NULL THEN 1 ELSE 0 END)  
        AS total_nulls
    FROM
        [eSports_Earnings].[dbo].['country-and-continent-codes-lis$']
    ) AS subquery;

--Got a count of 8, will be going through each column until I figure out which has a null value

SELECT
    COUNT(*)
FROM 
    [eSports_Earnings].[dbo].['country-and-continent-codes-lis$']
WHERE
    Three_Letter_Country_Code IS NULL;

--Got 4, will be checking which records are null
--Disputed Territory,Iraq-Saudi Arabia Neutral Zone,United Nations Neutral Zone, Spratly Islands
--Those areas are missing three letter country codes and country number as well

SELECT
    *
FROM
    [eSports_Earnings].[dbo].['country-and-continent-codes-lis$']
WHERE
    Three_Letter_Country_Code IS NULL;

--Repeat the process for the other tables on earnings players and teams

SELECT 
    SUM(total_nulls) AS total_nulls_in_table 
FROM
    (
    SELECT
        (CASE WHEN PlayerId IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN NameFirst IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN NameLast IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN CurrentHandle IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN CountryCode IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN TotalUSDPrize IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Game IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Genre IS NULL THEN 1 ELSE 0 END)  
        AS total_nulls
    FROM
        [eSports_Earnings].[dbo].[highest_earning_players$]
    ) AS subquery;

--Got a count of 5, will be going through each column

SELECT
    *
FROM
    [eSports_Earnings].[dbo].[highest_earning_players$]
WHERE
    CurrentHandle IS NULL;

--Null values of 5 are CurrentHandle
--Player ID 56731, 13186, 3651 uses their name to be identified
--PlayerID 60434 & 69797 does not have any name nor currenthandle, will be updating table to remove these two records

DELETE FROM [eSports_Earnings].[dbo].[highest_earning_players$]
WHERE PlayerId IN (60434,69797);

--Check if the two records are removed
--Good, continue to the last table with team earnings

SELECT
    *
FROM
    [eSports_Earnings].[dbo].[highest_earning_players$]
WHERE
    CurrentHandle IS NULL;

--Check teams earnings

SELECT 
    SUM(total_nulls) AS total_nulls_in_table 
FROM
    (
    SELECT
        (CASE WHEN TeamId IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN TeamName IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN TotalUSDPrize IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN TotalTournaments IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Game IS NULL THEN 1 ELSE 0 END) +
        (CASE WHEN Genre IS NULL THEN 1 ELSE 0 END)
        AS total_nulls
    FROM
         [eSports_Earnings].[dbo].[highest_earning_teams$]
    ) AS subquery;

--End of this SQL Query, we checked for nulls and removed 2 entries of players