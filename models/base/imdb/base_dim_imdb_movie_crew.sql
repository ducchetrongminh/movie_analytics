WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'title_principals') }}
)

, rename_column AS (
  SELECT 
    -- KEY
    tconst AS imdb_movie_id
    , ordering
    , nconst AS imdb_person_id
    -- DIMENSION
    , category AS crew_role
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(imdb_movie_id AS STRING) AS imdb_movie_id
    , CAST(ordering AS INTEGER) AS ordering
    , CAST(imdb_person_id AS STRING) AS imdb_person_id
    , CAST(crew_role AS STRING) AS crew_role
  FROM rename_column
)

SELECT 
  imdb_movie_id
  , ordering
  , imdb_person_id

  , crew_role
FROM cast_type
