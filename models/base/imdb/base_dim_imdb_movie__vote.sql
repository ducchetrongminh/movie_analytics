WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'title_ratings') }}
)

, rename_column AS (
  SELECT 
    -- KEY
    tconst AS imdb_movie_id
    -- NUMBER ATTRIBUTES
    , average_rating AS imdb_rating_avg
    , num_votes AS imdb_rating_count
  FROM source
)

, cast_type AS (
  SELECT 
      CAST(imdb_movie_id AS STRING) AS imdb_movie_id
      , CAST(imdb_rating_avg AS NUMERIC) AS imdb_rating_avg
      , CAST(imdb_rating_count AS INTEGER) AS imdb_rating_count
  FROM rename_column
)

SELECT *
FROM cast_type
