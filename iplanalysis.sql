USE ipl;


# Saving current status of database incase we need to rollback. 
COMMIT;


-- --------------------------------------------------------------------------------------
# DATA CLEANING 
-- --------------------------------------------------------------------------------------



# Looking at each table, checking data types and changing

SELECT 
    *
FROM
    bowling_economy_innings
LIMIT 50;

DESC
	bowling_economy_innings;


-- Getting rid of an unknown column that we will not be using for analysis.
ALTER TABLE 
	bowling_economy_innings
DROP COLUMN MyUnknownColumn;

-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE bowling_economy_innings
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');

-- 

SELECT 
    *
FROM
    bowling_strikerate;

-- Getting rid of an unknown column that we will not be using for analysis.    
ALTER TABLE 
	bowling_strikerate
DROP COLUMN MyUnknownColumn;

-- Getting rid of an unknown column that we will not be using for analysis.
ALTER TABLE 
	bowling_strikerate
DROP COLUMN `Unnamed: 0`;
-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE bowling_strikerate
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');


-- 


SELECT 
    *
FROM
    fast_centuries;
    
-- Getting rid of an unknown column that we will not be using for analysis.   
ALTER TABLE 
	fast_centuries
DROP COLUMN MyUnknownColumn;

-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE fast_centuries
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');


-- 


SELECT 
    *
FROM
    fast_fifties;

-- -- Getting rid of an unknown column that we will not be using for analysis.      
ALTER TABLE 
	fast_fifties
DROP COLUMN MyUnknownColumn;

-- -- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE fast_fifties
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');


--


SELECT 
    *
FROM
    dotballs_innings;
 
-- Getting rid of an unknown column that we will not be using for analysis.  
ALTER TABLE 
	dotballs_innings
DROP COLUMN MyUnknownColumn;

-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE dotballs_innings
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');


-- 


SELECT 
    *
FROM
    most_runs;

-- Getting rid of an unknown column that we will not be using for analysis.  
ALTER TABLE 
	most_runs
DROP COLUMN MyUnknownColumn;


--

SELECT 
    *
FROM
    most_runs_per_over;
    
-- Getting rid of an unknown column that we will not be using for analysis.  
ALTER TABLE 
	most_runs_per_over
DROP COLUMN MyUnknownColumn;

-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE most_runs_per_over
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');


--

SELECT 
    *
FROM
    most_sixes_innings;
-- Getting rid of an unknown column that we will not be using for analysis. 
ALTER TABLE 
	most_sixes_innings
DROP COLUMN MyUnknownColumn;

-- Changing the match date from DD MONTH YYYY in string to Datetime format.
UPDATE most_sixes_innings
SET `Match Date`= STR_TO_DATE(`Match Date`, '%d %M %Y');

--


SELECT 
    *
FROM
    most_wickets;
-- Getting rid of an unknown column that we will not be using for analysis. 
ALTER TABLE 
	most_wickets
DROP COLUMN MyUnknownColumn;



-- ----------------------------------------------------------------------------------------------------

 #  DATA ANALYSIS

-- ----------------------------------------------------------------------------------------------------


# Displaying the top 10 batsmen with the most runs across all seasons of IPL, along with the matches and overall average.

SELECT 
    *
FROM
    most_runs;
    

SELECT 
    Player,
    SUM(Mat) as Matches,
    SUM(Inns) as Innings, 
    SUM(Runs) as Total_Runs,
    ROUND((SUM(Runs)/SUM(Inns)),2) as Overall_Bat_Average
FROM
    most_runs
GROUP BY Player
ORDER BY Total_Runs DESC
LIMIT 10;



# Displaying the top 10 bowlers with the most wickets across all seasons of IPL, along with the matches and overall bowling average.


SELECT 
    Player,
    SUM(Mat) as Matches,
    SUM(Inns) as Innings, 
    SUM(Wkts) as Total_Wickets,
    ROUND((SUM(Runs)/SUM(Wkts)),2) as Overall_Bowl_Average
FROM
    most_wickets
GROUP BY Player
ORDER BY Total_Wickets DESC
LIMIT 10;



# 20 Most Economical Bowlers of all time in the IPL who have bowled atleast 100 overs or more.

SELECT 
    Player,
    ROUND((SUM(Ov)),1) AS Total_Overs,
    ROUND((AVG(Econ)),2) AS Overall_Economy
FROM
    bowling_economy_innings
GROUP BY Player
HAVING Total_Overs >= 100
ORDER BY Overall_Economy
LIMIT 20;


# Which players scored the quickest centuries but with the least amount of overall boundaries.

SELECT 
    Player,
    Runs,
    BF AS Balls_Faced,
    (4s +6s) AS Overall_boundaries
FROM
    fast_centuries
ORDER BY Overall_boundaries;



# Who has been the most economical bowler in the last two seasons of the IPL with a minimum overs bowled of 25.

SELECT 
    *
FROM
    bowling_economy_innings
ORDER BY `Match Date` DESC;


WITH CTE as 
(
SELECT 
    Player,
    SUM(Ov) AS Total_Overs,
    SUM(Runs) AS Total_Runs,
    ROUND(AVG(Econ),2) AS Avg_Bowl_Econ
FROM
    bowling_economy_innings
WHERE
    `Match Date` >= 2020
GROUP BY Player
) 
SELECT 
	Player,
	Avg_Bowl_Econ
FROM 
	CTE
WHERE 
	Total_Overs >= 25
ORDER BY Avg_Bowl_Econ
LIMIT 10;


# What % of runs does Virat Kohli score in boundaries compared to Rohit Sharma in IPL?

WITH CTE AS 
(
SELECT 
    Player,
    SUM(Runs) AS Total_Runs,
    (SUM(4s) * 4) + (SUM(6s) * 6) AS boundary_runs,
    ROUND((((SUM(4s) * 4) + (SUM(6s) * 6)) / SUM(Runs)) * 100,
            2) AS boundary_pct
FROM
    most_runs
GROUP BY Player
)
SELECT 
	Player,
    boundary_pct
from CTE
WHERE Player LIKE ('Virat Kohli%') OR Player LIKE ('Rohit Sharma%')
ORDER BY boundary_pct DESC;









