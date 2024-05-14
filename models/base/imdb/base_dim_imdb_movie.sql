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

SELECT *
FROM rename_column
