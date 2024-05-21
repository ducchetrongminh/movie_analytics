# Movie Mapping

This document explains how we do the mapping of movies from different platforms.

# The problems

Context: We have movie data from IMDB, TMDB, Movielens. We want to connect data from these platforms, so that we can have a overview of movies.

Problem: There is no universal key. Instead, each platform has their own surrogate key. Luckily, Movielens has linking to IMDB and TMDB. TMDB also has linking to IMDB. However, these linkings are not complete, therefore we need to improve on this issue.

# Problem breakdowns

## How to map movie from different platform?

The initial idea was to use the combination of movie title + release year. 

<details>

<summary>We run a query to test the duplication of (title + release year). Click here to see the detail tests.</summary>

```sql
-- IMDB
SELECT
  title
  , start_year
  , COUNT(*)
FROM `duc-ctm.movie_analytics_staging.stg_dim_imdb_movie`
GROUP BY 1, 2 
HAVING COUNT(*) > 1 
ORDER BY 3 DESC
```

In IMDB, there are 3606 duplication cases, account for about 1%.

```sql
-- TMDB
SELECT
  title
  , EXTRACT(YEAR FROM release_date)
  , COUNT(*)
FROM `duc-ctm.movie_analytics_staging.stg_dim_tmdb_movie`
WHERE release_date IS NOT NULL
GROUP BY 1, 2 
HAVING COUNT(*) > 1 
ORDER BY 3 DESC
```

In TMDB, there are 2406 duplication cases, account for about 1%.

```sql
SELECT
  title
  , release_year
  , COUNT(*)
FROM `duc-ctm.movie_analytics_staging.stg_dim_movielens_movie`
GROUP BY 1, 2 
HAVING COUNT(*) > 1 
ORDER BY 3 DESC
```

In Movielens, there are 202 duplication cases, account for about 1%.

</details>

<br>

In conclusion, there are about 1% of movies that will be duplicated on (title + release_year). 

We come to a solution that solves the problem in 3 ways:
- For movies that already have the linkings, we will use the inputted linkings.
- For movies that are not duplicated based on (title+year), we will use the (title+year) to map.
- For movies that are duplicated based on (title+year), we will need more special treatment, such as (title + release_year + directors).

## How to determine the performance of the mapping?

<details>

<summary>We will first check the inputted linkings to check whether (title+year) is trustworthy.</summary>

```sql
-- BELOW ARE THE CTES TO ENSURE THE DATA QUALITY. WE DON'T USE STAGING MODELS BECAUSE THESE MODELS ARE REMOVING NON-RATING MOVIES.

WITH dim_movielens_movie AS (
  SELECT *
  FROM `duc-ctm`.`movie_analytics_staging`.`stg_dim_movielens_movie` AS dim_movielens_movie
)

, dim_imdb_movie AS (
  SELECT *
  FROM `duc-ctm`.`movie_analytics_staging`.`base_dim_imdb_movie`
  WHERE 
    -- 20240516 remove 4 cases that title is null
    title IS NOT NULL 

    -- These are the types of movies/tv series
    AND title_type IN ('movie', 'tvMiniSeries', 'tvMovie', 'tvSeries')
)

, dim_tmdb_movie AS (
  SELECT *
  FROM `duc-ctm`.`movie_analytics_staging`.`base_dim_tmdb_movie`
  WHERE 
    status = 'Released' -- keep Released movie only
)
```

A quick test of linking between TMDB and IMDB reveals that about 26% of titles are not matched (97k titles).

```sql
SELECT
  dim_tmdb_movie.title = dim_imdb_movie.title AS is_similar
  , COUNT(*)
FROM dim_tmdb_movie
JOIN dim_imdb_movie USING (imdb_movie_id)
GROUP BY 1 
```

When deep dive, the difference comes from the format of name. For example, `Harry Potter and the Philosopher's Stone vs. Harry Potter and the Sorcerer's Stone`, `Twelve Monkeys vs. 12 Monkeys`, `The 40 Year Old Virgin vs. The 40-Year-Old Virgin`, `Mad Max 2 vs. Mad Max 2: The Road Warrior`. 

```sql
SELECT 
  dim_tmdb_movie.title AS title_from_tmdb
  , dim_imdb_movie.title AS title_from_imdb
  , dim_tmdb_movie.title = dim_imdb_movie.title AS is_similar
FROM dim_tmdb_movie
JOIN dim_imdb_movie USING (imdb_movie_id)
WHERE dim_tmdb_movie.title != dim_imdb_movie.title
ORDER BY tmdb_rating_count DESC
```

From the result, we can expect that the linking between TMDB and TMDB is good. We also expect that about 25% will not be matched based on the title.

Repeat the test for linking between Movielens and IMDB, Movielens and TMDB.

```sql
SELECT
  dim_movielens_movie.title = dim_imdb_movie.title AS is_similar
  , COUNT(*)
FROM dim_movielens_movie
JOIN dim_imdb_movie USING (imdb_movie_id)
GROUP BY 1 
```

```sql
SELECT 
  dim_movielens_movie.title AS title_from_movielens
  , dim_imdb_movie.title AS title_from_imdb
  , dim_movielens_movie.title = dim_imdb_movie.title AS is_similar
FROM dim_movielens_movie
JOIN dim_imdb_movie USING (imdb_movie_id)
WHERE dim_movielens_movie.title != dim_imdb_movie.title
ORDER BY movielens_rating_count DESC
```

Results for linking between Movielens and IMDB:
- 20% of titles are not matched (7k4 titles)
- Deep dive, we found that many Movielens titles are in reversed order (e.g. `Dark Knight Rises, The` instead of `The Dark Knight Rises`)
- Other cases are due to the format of name (e.g. `(500) Days of Summer vs. 500 Days of Summer`)

</details>
