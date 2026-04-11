WITH source AS (
  SELECT *
  FROM {{ source('movielens', 'movies') }}
)

, rename_column AS (
  SELECT 
    movieId AS movielens_movie_id
    , title AS movielens_title
    , genres AS movielens_genres
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(movielens_movie_id AS INTEGER) AS movielens_movie_id
    , CAST(movielens_title AS STRING) AS movielens_title 
    , CAST(movielens_genres AS STRING) AS movielens_genres
  FROM rename_column
)

, handle_null AS (
  SELECT 
    movielens_movie_id
    , movielens_title
    , COALESCE(NULLIF(movielens_genres, '(no genres listed)'), 'Undefined') AS movielens_genres
  FROM cast_type
)

SELECT 
  movielens_movie_id
  , movielens_title
  , movielens_genres
FROM handle_null
