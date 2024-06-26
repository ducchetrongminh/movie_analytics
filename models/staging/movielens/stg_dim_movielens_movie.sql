WITH dim_movielens_movie__rating AS (
  SELECT 
    movielens_movie_id
    , AVG(rating) AS movielens_rating_avg
    , COUNT(*) AS movielens_rating_count
  FROM {{ ref('base_fact_movielens_rating') }}
  GROUP BY 1
)

, join_data AS (
  SELECT 
    dim_movielens_movie.*
    , dim_movielens_movie__link.imdb_movie_id
    , dim_movielens_movie__link.tmdb_movie_id
    , dim_movielens_movie__rating.movielens_rating_avg
    , dim_movielens_movie__rating.movielens_rating_count
  FROM {{ ref('base_dim_movielens_movie') }} AS dim_movielens_movie 
  JOIN {{ ref('stg_dim_movielens_movie__link') }} AS dim_movielens_movie__link 
    USING (movielens_movie_id)
  LEFT JOIN dim_movielens_movie__rating
    USING (movielens_movie_id)
)

SELECT 
  movielens_movie_id
  , title
  , movielens_genres

  , movielens_rating_avg 
  , movielens_rating_count

  , imdb_movie_id
  , tmdb_movie_id
FROM join_data
