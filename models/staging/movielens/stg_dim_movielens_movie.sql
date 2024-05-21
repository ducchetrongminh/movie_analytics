WITH extract_year AS (
  SELECT 
    *
    , REGEXP_REPLACE(movielens_title, r'(\s\([0-9]+\))$', '') AS title
    , CAST(REGEXP_EXTRACT(movielens_title, r'\s\(([0-9]+)\)$') AS INTEGER) AS release_year
  FROM {{ ref('base_dim_movielens_movie') }}
)

, cleanse_title AS (
  /*
  CONTEXT: We want to map movies from different platforms based on (title+year) (see docs\doc_movie_mapping.md for more info).
  PROBLEM: Many Movielens titles are in reversed order (e.g. `Dark Knight Rises, The` instead of `The Dark Knight Rises`)
  SOLUTION: We reverse `The` to the front.
  */
  SELECT 
    * EXCEPT (title)
    , CASE 
      WHEN title LIKE '%, The'
      THEN CONCAT('The ', REGEXP_REPLACE(title, r', The$', ''))
      ELSE title END
    AS title
  FROM extract_year
)

, join_data AS (
  SELECT 
    dim_movielens_movie.*
    , dim_movielens_movie__link.imdb_movie_id
    , dim_movielens_movie__link.tmdb_movie_id
    , dim_movielens_movie__rating.movielens_rating_avg
    , dim_movielens_movie__rating.movielens_rating_count
  FROM cleanse_title AS dim_movielens_movie 
  JOIN {{ ref('stg_dim_movielens_movie__link') }} AS dim_movielens_movie__link 
    USING (movielens_movie_id)
  LEFT JOIN {{ ref('stg_dim_movielens_movie__rating') }} AS dim_movielens_movie__rating
    USING (movielens_movie_id)
)

SELECT 
  movielens_movie_id
  , title
  , movielens_genres

  , release_year

  , movielens_rating_avg 
  , movielens_rating_count

  , imdb_movie_id
  , tmdb_movie_id
FROM join_data
