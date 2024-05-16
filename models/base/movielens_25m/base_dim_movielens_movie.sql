WITH source AS (
  SELECT *
  FROM {{ source('movielens_25m', 'movies') }}
)

, rename_column AS (
  SELECT 
    movieId AS movielens_id
    , genres AS movielens_genres
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(movielens_id AS INTEGER) AS movielens_id
    , CAST(movielens_genres AS STRING) AS movielens_genres
  FROM rename_column
)

, handle_null AS (
  SELECT 
    movielens_id 
    , COALESCE(NULLIF(movielens_genres, '(no genres listed)'), 'Undefined') AS movielens_genres
  FROM cast_type
)

SELECT 
  movielens_id
  , movielens_genres
FROM handle_null
