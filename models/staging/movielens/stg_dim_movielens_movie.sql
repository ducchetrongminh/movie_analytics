WITH join_data AS (
  SELECT 
    dim_movielens_movie.*
    , dim_movielens_movie__link.imdb_movie_id
    , dim_movielens_movie__link.tmdb_movie_id
  FROM {{ ref('base_dim_movielens_movie') }} AS dim_movielens_movie 
  JOIN {{ ref('base_dim_movielens_movie__link') }} AS dim_movielens_movie__link 
    USING (movielens_movie_id)
)

SELECT 
  movielens_movie_id
  , movielens_genres

  , imdb_movie_id
  , tmdb_movie_id
FROM join_data
