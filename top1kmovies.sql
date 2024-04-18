DROP TABLE topmovies1;

SELECT * FROM topmovies1;

UPDATE topmovies1
SET release_year = replace(release_year, '-','')
WHERE release_year LIKE '%-%';

SELECT * 
FROM topmovies1
ORDER BY gross_clean DESC
LIMIT 10;

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


SELECT director, COUNT(*) AS common_director
FROM topmovies1
GROUP BY director
ORDER BY common_director DESC
LIMIT 20;

SELECT * FROM topmovies1
WHERE genre LIKE '%Drama%'
ORDER BY rating DESC, gross_clean DESC
LIMIT 1;

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

SELECT director, AVG(rating) AS average_rating
FROM topmovies1
GROUP BY director
ORDER BY average_rating DESC
LIMIT 20;

SELECT release_year, COUNT(*) AS num_movies
FROM topmovies1
GROUP BY release_year 
ORDER BY num_movies DESC
LIMIT 1;

SELECT director, release_year, COUNT(*) as num_moviesrelease
FROM topmovies1
GROUP BY director, release_year
ORDER BY num_moviesrelease;

SELECT release_year,
	SUM(gross_clean) AS total_gross
FROM topmovies1
group by release_year
order by total_gross DESC;