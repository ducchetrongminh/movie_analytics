WITH 

-- This part has no effect so we temporarilt remove it
-- cleanse AS (
--   SELECT *
--   FROM {{ ref('base_fact_movielens_rating') }} AS fact_movielens_rating
--   WHERE EXISTS (
--     SELECT 1 
--     FROM {{ ref('dim_movie') }} AS dim_movie 
--     WHERE 
--       dim_movie.movielens_movie_id = fact_movielens_rating.movielens_movie_id
--   )
-- )

add_key AS (
  SELECT
    fact_movielens_rating.*
    , dim_movie.movie_key
  FROM {{ ref('base_fact_movielens_rating') }} AS fact_movielens_rating
  LEFT JOIN {{ ref('dim_movie') }} AS dim_movie 
    USING (movielens_movie_id)
)

, enrich AS (
  SELECT 
    *
    , DATE(TIMESTAMP_SECONDS(rated_at_unix)) AS rated_date
  FROM add_key
)

SELECT 
  movie_key
  , movielens_user_id
  , rating
  , rated_date
FROM enrich
