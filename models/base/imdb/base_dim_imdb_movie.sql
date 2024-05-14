WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'title_basics') }}
)

, rename_column AS (
  SELECT 
    -- KEY
    tconst AS imdb_movie_id
    -- NAME
    , primary_title AS title
    -- DIMENSION
    , title_type
    , genres AS imdb_genres
    -- DATETIME
    , start_year
    , end_year
    -- NUMBER ATTRIBUTES
    , runtime_minutes
  FROM source
)

, cast_type AS (
  SELECT 
      CAST(imdb_movie_id AS STRING) AS imdb_movie_id
      , CAST(title AS STRING) AS title
      , CAST(title_type AS STRING) AS title_type
      , CAST(imdb_genres AS STRING) AS imdb_genres
      , CAST(start_year AS INTEGER) AS start_year
      , CAST(end_year AS INTEGER) AS end_year
      , CAST(runtime_minutes AS INTEGER) AS runtime_minutes
  FROM rename_column
)

, handle_null AS (
  SELECT *
    EXCEPT (
      imdb_genres
    )

    , COALESCE(imdb_genres, 'Undefined') AS imdb_genres
  FROM cast_type
)

SELECT
  imdb_movie_id
  , title

  , title_type
  , imdb_genres

  , start_year
  , end_year
  
  , runtime_minutes
FROM handle_null
