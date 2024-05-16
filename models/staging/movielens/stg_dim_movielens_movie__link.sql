WITH add_imdb_id AS (
  SELECT 
    *
    , CONCAT('tt', imdb_movie_integer_id) AS imdb_movie_id
  FROM {{ ref("base_dim_movielens_movie__link") }}
)

SELECT 
  movielens_movie_id
  , imdb_movie_id
  , tmdb_movie_id
FROM add_imdb_id 
