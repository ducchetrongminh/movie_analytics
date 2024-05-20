WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'title_basics') }}
)

, rename_column AS (
  SELECT 
    -- KEY
    tconst AS imdb_movie_id
    -- NAME
    , primaryTitle AS title
    -- DIMENSION
    , titleType AS title_type
    , genres AS imdb_genres
    -- DATETIME
    , startYear AS start_year
    , endYear AS end_year
    -- NUMBER ATTRIBUTES
    , runtimeMinutes AS runtime_minutes
  FROM source
)

, handle_null_tsv AS (
  SELECT 
    imdb_movie_id
    , title

    , title_type
    , NULLIF(imdb_genres, '\\N') AS imdb_genres

    , NULLIF(start_year, '\\N') AS start_year
    , NULLIF(end_year, '\\N') AS end_year

    , NULLIF(runtime_minutes, '\\N') AS runtime_minutes
  FROM rename_column
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
  FROM handle_null_tsv
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
