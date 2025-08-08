USE Marketing_research;

SELECT * FROM dbo.dim_cities;
SELECT * FROM respondents;
SELECT * FROM survey_responses;

--- Demographic Insights
-- 1. Who prefers energy drink more? (male/female/non-binary?)

SELECT r.Gender,
       COUNT(DISTINCT sr.Respondent_ID) AS respondent_count
FROM survey_responses sr
JOIN respondents r
  ON sr.Respondent_ID = r.Respondent_ID
GROUP BY r.Gender;

-- 2. Which age group prefers energy drinks more?

SELECT r.Age,
       COUNT(*) AS response_count
FROM survey_responses sr
JOIN respondents r
  ON sr.Respondent_ID = r.Respondent_ID
GROUP BY r.Age
ORDER BY response_count DESC;

-- 3. Which type of marketing reaches the most Youth (15-30)?

SELECT sr.Marketing_channels,
       COUNT(*) AS Marketing
FROM survey_responses sr
JOIN respondents r
  ON sr.Respondent_ID = r.Respondent_ID
WHERE r.Age IN ('15-18','19-30')
GROUP BY sr.Marketing_channels
ORDER BY Marketing DESC;

--- CONSUMER Preferences 
--1. What are the preferred ingredients of energy drinks among respondents?

SELECT Ingredients_expected,
       COUNT(*) AS votes
FROM survey_responses
GROUP BY Ingredients_expected
ORDER BY votes DESC;

-- 2. What packaging preferences do respondents have for energy drinks?

SELECT Packaging_preference,
COUNT(*) AS Votes
FROM survey_responses
GROUP BY Packaging_preference
ORDER BY Votes DESC;


--- Competition Analysis 
-- 1. Who are the current market leaders?

SELECT Current_brands,
       COUNT(*) AS share
FROM survey_responses
GROUP BY Current_brands
ORDER BY share DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;  -- top 5

-- 2. What are the primary reasons consumers prefer those brands over ours?

SELECT
	Reasons_preventing_trying,
	COUNT(*) AS Votes
FROM survey_responses
GROUP BY Reasons_preventing_trying
ORDER BY Votes DESC;

--- Marketing Channels & Brand Awareness
-- 1. Which marketing channel can be used to reach more customers?

SELECT Marketing_channels,
       COUNT(*) AS Votes
FROM survey_responses 
GROUP BY Marketing_channels
ORDER BY Votes DESC;

-- 2. How effective are different marketing strategies and channels in reaching our customers?

SELECT Brand_perception, COUNT(*) AS Votes
FROM survey_responses
GROUP BY Brand_perception
ORDER BY Votes DESC;


--- Brand Penetration:
-- 1. Which cities do we need to focus more on?

SELECT c.city,COUNT(Respondent_ID) AS Response
FROM cities c
JOIN respondents r
ON c.City_ID = r.City_ID
GROUP BY c.city
ORDER BY Response DESC;

SELECT c.City,
       SUM(CASE WHEN sr.Heard_before = 'Yes' THEN 1 ELSE 0 END) * 100.0
         / COUNT(*) AS pct_heard
FROM survey_responses sr
JOIN respondents r ON sr.Respondent_ID = r.Respondent_ID
JOIN cities c      ON r.City_ID       = c.City_ID
GROUP BY c.City
ORDER BY pct_heard DESC;


--- Purchase Behavior
-- 1.Where do respondents prefer to purchase energy drinks?

SELECT Purchase_location,
	COUNT(*) AS Votes
FROM survey_responses
GROUP BY Purchase_location
ORDER BY Votes DESC;

-- 2. What are the typical consumption situations for energy drinks among respondents?

SELECT Typical_consumption_situations, COUNT(*) AS Votes
FROM survey_responses
GROUP BY Typical_consumption_situations
ORDER BY votes DESC;

-- 3. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?

SELECT Price_range, COUNT(*) AS Votes
FROM survey_responses
GROUP BY Price_range
ORDER BY votes DESC;

