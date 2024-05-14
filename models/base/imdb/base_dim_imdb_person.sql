WITH source AS (
  SELECT *
  FROM {{ source('imdb', 'name_basics') }}
)

, rename_column AS (
  SELECT 
    nconst AS imdb_person_id
    , primary_name AS person_name
    , birth_year
    , death_year
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(imdb_person_id AS STRING) AS imdb_person_id
    , CAST(person_name AS STRING) AS person_name
    , CAST(birth_year AS INTEGER) AS birth_year
    , CAST(death_year AS INTEGER) AS death_year
  FROM rename_column
)

SELECT 
  imdb_person_id
  , person_name
  , birth_year
  , death_year
FROM cast_type
