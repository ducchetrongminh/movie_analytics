WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'name_basics') }}
)

, rename_column AS (
  SELECT 
    nconst AS imdb_person_id
    , primaryName AS person_name
    , birthYear AS birth_year
    , deathYear AS death_year
  FROM source 
)

, handle_null_tsv AS (
  SELECT 
    imdb_person_id
    , person_name
    , NULLIF(birth_year, '\\N') AS birth_year
    , NULLIF(death_year, '\\N') AS death_year
  FROM rename_column
)

, cast_type AS (
  SELECT 
    CAST(imdb_person_id AS STRING) AS imdb_person_id
    , CAST(person_name AS STRING) AS person_name
    , CAST(birth_year AS INTEGER) AS birth_year
    , CAST(death_year AS INTEGER) AS death_year
  FROM handle_null_tsv
)

SELECT 
  imdb_person_id
  , person_name
  , birth_year
  , death_year
FROM cast_type
