WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'title_ratings') }}
)

, rename_column AS (
  SELECT 
    -- KEY
    tconst AS imdb_movie_id
    -- NUMBER ATTRIBUTES
    , averageRating AS imdb_rating_avg
    , numVotes AS imdb_rating_count
  FROM source
)

, cast_type AS (
  SELECT 
      CAST(imdb_movie_id AS STRING) AS imdb_movie_id
      , CAST(imdb_rating_avg AS NUMERIC) AS imdb_rating_avg
      , CAST(imdb_rating_count AS INTEGER) AS imdb_rating_count
  FROM rename_column
)

SELECT
  imdb_movie_id

  , imdb_rating_avg
  , imdb_rating_count
FROM cast_type
