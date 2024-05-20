WITH source AS (
  SELECT *
  FROM {{ source('movielens', 'ratings') }}
)

, rename_column AS (
  SELECT 
    movieId AS movielens_movie_id
    , userId AS movielens_user_id
    , rating
    , timestamp AS rated_at_unix
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(movielens_movie_id AS INTEGER) AS movielens_movie_id
    , CAST(movielens_user_id AS INTEGER) AS movielens_user_id
    , CAST(rating AS NUMERIC) AS rating
    , CAST(rated_at_unix AS INTEGER) AS rated_at_unix
  FROM rename_column
)


SELECT 
  movielens_movie_id
  , movielens_user_id
  , rating
  , rated_at_unix
FROM cast_type
