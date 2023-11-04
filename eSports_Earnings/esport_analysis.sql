--country & continent
-- SELECT TOP (100) 
--     [Continent_Name],
--     [Continent_Code],
--     [Country_Name],
--     [Two_Letter_Country_Code],
--     [Three_Letter_Country_Code],
--     [Country_Number]
-- FROM 
--     [eSports_Earnings].[dbo].['country-and-continent-codes-lis$'];

-- --players earning
-- SELECT TOP (100) 
--     [PlayerId],
--     [NameFirst],
--     [NameLast],
--     [CurrentHandle],
--     [CountryCode],
--     [TotalUSDPrize],
--     [Game],
--     [Genre]
-- FROM 
--     [eSports_Earnings].[dbo].[highest_earning_players$];

-- --team earnings
-- SELECT TOP (100) 
--     [TeamId],
--     [TeamName],
--     [TotalUSDPrize],
--     [TotalTournaments],
--     [Game],
--     [Genre]
-- FROM 
--     [eSports_Earnings].[dbo].[highest_earning_teams$];

--What are the games being analyzed? 10 count

SELECT
    DISTINCT Game
FROM
    [eSports_Earnings].[dbo].[highest_earning_players$];

--Analyst 1: What are the top 10 earning players?

SELECT TOP 10
    *
FROM
    [eSports_Earnings].[dbo].[highest_earning_players$]
ORDER BY
    TotalUSDPrize DESC;

--Analyst 2: What countries are those players from?

SELECT TOP 10
    PlayerId,
    NameFirst,
    NameLast,
    CurrentHandle,
    TotalUSDPrize,
    Game,
    Continent_Name,
    Country_Name
FROM
    [eSports_Earnings].[dbo].[highest_earning_players$] AS player
JOIN
    [eSports_Earnings].[dbo].['country-and-continent-codes-lis$'] AS country
    ON player.CountryCode = country.Two_Letter_Country_Code
ORDER BY
    TotalUSDPrize DESC;

--Notice that Dota 2 is domininant with players making over millions, We see 7 of the 10 top earners from Europe.

--Setup a CTE for Dota 2 from the teams table

With dota 
AS(
    SELECT
        *
    FROM
        [eSports_Earnings].[dbo].[highest_earning_teams$]
    WHERE
        Game = 'Dota 2'
)


--Analyst 3: What are the top teams for Dota 2?

SELECT TOP 10
    [TeamId],
    [TeamName],
    [TotalUSDPrize],
    [TotalTournaments],
    [Game],
    [Genre]
FROM 
    dota
ORDER BY 
    TotalUSDPrize DESC;

--Notice that some teams were placed high due to the amount of tournaments they have been involved with.
--We should consider Total USD per tournament to compute for their average earnings.
--But we want to have the team at least make $5 million and partcipated in 15 tournaments for experience.

--Analyst 4: Compute Avg team earnings with at least $5 million earned and participated in 15 tournaments.
With dota 
AS(
    SELECT
        *
    FROM
        [eSports_Earnings].[dbo].[highest_earning_teams$]
    WHERE
        Game = 'Dota 2'
)

SELECT TOP 10
    [TeamId],
    [TeamName],
    [TotalUSDPrize],
    [TotalTournaments],
    (TotalUSDPrize/TotalTournaments) AS AVG_Earnings
FROM 
    dota
WHERE
    TotalUSDPrize >= 5000000
    AND 
    TotalTournaments >= 15
ORDER BY 
    AVG_Earnings DESC;

--Analyst 5 on average what do Dota 2 players make?

With dota 
AS(
    SELECT
        *
    FROM
        [eSports_Earnings].[dbo].[highest_earning_teams$]
    WHERE
        Game = 'Dota 2'
)

SELECT
    Game,
    AVG(TotalUSDPrize) AS avg_dota
FROM
    dota
GROUP BY
    Game;

