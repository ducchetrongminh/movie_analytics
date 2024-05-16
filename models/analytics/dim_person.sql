WITH cleanse AS (
  SELECT *
  FROM {{ ref("base_dim_imdb_person") }}
  WHERE 
    person_name IS NOT NULL -- 20240516 remove 12 cases that person_name is null
)

, add_key AS (
  SELECT 
    *
    , FARM_FINGERPRINT(imdb_person_id) AS person_key
  FROM cleanse
)

SELECT 
  person_key

  , person_name

  , birth_year
  , death_year

  , imdb_person_id
FROM add_key
