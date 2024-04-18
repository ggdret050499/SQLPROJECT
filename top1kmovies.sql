-- I got the data from Kaggle This is the link: https://www.kaggle.com/datasets/arthurchongg/imdb-top-1000-movies
-- Before I jump into sql and started querying, I cleaned the data and added some columns in order for it to be easier for me to analyze.
-- These prompts that I used are practice prompts in order for me to showcase my knowledge in SQL.
SELECT * FROM topmovies1;

--Firstly, I cleaned the data to make it easier and presentable.
UPDATE topmovies1
SET release_year = replace(release_year, '-','')
WHERE release_year LIKE '%-%';

--The first prompt that I used for this dataset is to identify the top 10 movies which had the highest gross.
SELECT * 
FROM topmovies1
ORDER BY gross_clean DESC
LIMIT 10;

--The second prompt was for me to identify the common genre in the list.
SELECT genre, COUNT(*) AS num_movies
FROM (
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',', n.digit+1), ',', -1) AS genre
    FROM topmovies1
    JOIN (
        SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    ) AS n
    WHERE LENGTH(genre) - LENGTH(REPLACE(genre, ',', '')) >= n.digit
) AS genres
GROUP BY genre
ORDER BY num_movies DESC;

SELECT genre, COUNT(*) AS frequency
FROM topmovies1
GROUP BY genre
ORDER BY frequency DESC;

-- Third prompt was to find the directors who appeared frequently in the list.
SELECT director, COUNT(*) AS common_director
FROM topmovies1
GROUP BY director
ORDER BY common_director DESC
LIMIT 20;
-- I tried to find the highest rating which also has the highest gross sales
SELECT * FROM topmovies1
WHERE genre LIKE '%Drama%'
ORDER BY rating DESC, gross_clean DESC
LIMIT 1;
-- In this prompt, I wanted to figure out the average runtime of the different genres.
SELECT genre, SUM(runtime) / COUNT(*) AS average_runtime
FROM (
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',', n.digit+1), ',', -1) AS genre, runtime
    FROM topmovies1
    JOIN (
        SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    ) AS n
    WHERE LENGTH(genre) - LENGTH(REPLACE(genre, ',', '')) >= n.digit
) AS distinct_genres
GROUP BY genre;

SELECT genre,
       SUM(runtime) / COUNT(*) AS average_runtime_per_genre
FROM (
    SELECT REPLACE(TRIM(genre), ' ', '') AS genre,
           runtime
    FROM topmovies1
) AS preprocessed_movies
GROUP BY genre;
-- I also tried to find the average rating of each director but I only limited it to the top 20
SELECT director, AVG(rating) AS average_rating
FROM topmovies1
GROUP BY director
ORDER BY average_rating DESC
LIMIT 20;
-- I also look into the data and look for the highest number released in a year
SELECT release_year, COUNT(*) AS num_movies
FROM topmovies1
GROUP BY release_year 
ORDER BY num_movies DESC
LIMIT 1;
-- I also wanted to see if there are directors who released 2 movies in a year.
SELECT director, release_year, COUNT(*) as num_moviesrelease
FROM topmovies1
GROUP BY director, release_year
ORDER BY num_moviesrelease;
-- Lastly, I wanted to figure out the gross sales of each year.
SELECT release_year,
	SUM(gross_clean) AS total_gross
FROM topmovies1
group by release_year
order by total_gross DESC;

-- This is where I end my first SQL PROJECT in the next post I will try to visualize the dataset in a dashboard using POWERBI.
