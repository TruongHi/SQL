-- SELECT ALL from 5 tables
SELECT * FROM branches;
SELECT * FROM commits;
SELECT * FROM file_commits;
SELECT * FROM projects;
SELECT * FROM users;

-- Name of projects
SELECT DISTINCT name, id
FROM projects;

-- Count the number of projects
SELECT COUNT(*) from projects;

-- User name
SELECT Distinct name FROM users;

-- Count the number of users
SELECT COUNT(*) FROM users;

-- Number of lines modifed of users
SELECT user_name, SUM(line_added), SUM(line_removed)
FROM commits
GROUP BY user_name
ORDER BY user_name;

-- Number of lines modifed of users over time
WITH temp AS 
(
SELECT user_name, 
line_added,
line_removed,
EXTRACT(YEAR FROM commit_date) AS year,
EXTRACT(MONTH FROM commit_date) as month,
EXTRACT(DAY FROM commit_date) as day
FROM commits
ORDER BY year
)
SELECT
year, month, day, user_name,
SUM(line_added) AS total_added,
SUM(line_removed) AS total_removed
FROM temp
GROUP BY year, month, day, user_name
ORDER BY year;

-- Daytime extracted from commits
SELECT 
EXTRACT (HOUR FROM commit_date) AS hour,
EXTRACT (MINUTE FROM0909099999999999999999999 commit_date) AS minute,
EXTRACT(YEAR FROM commit_date) AS year,
user_name,
line_added,
line_removed
FROM commits
Where EXTRACT(YEAR FROM commit_date) = 2023;

-- Status of projects
SELECT status, COUNT(status) AS count
FROM file_commits
GROUP BY status;

-- User name that has not commited anything
WITH temp AS
(
SELECT user_name
FROM commits
INTERSECT
SELECT name
FROM users
),
temp2 AS
(
SELECT name 
FROM users
WHERE name NOT IN 
(SELECT user_name FROM temp)
)
SELECT name
FROM temp2

SELECT user_name, line_added, line_removed,
commit_date
FROM commits;