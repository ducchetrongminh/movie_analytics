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

