WITH source AS (
  SELECT *
  FROM {{ source('movielens', 'links') }}
)

, rename_column AS (
  SELECT 
    movieId AS movielens_movie_id
    , imdbId AS imdb_movie_integer_id
    , tmdbId AS tmdb_movie_id
  FROM source 
)

, cast_type AS (
  SELECT 
    CAST(movielens_movie_id AS INTEGER) AS movielens_movie_id
    , CAST(imdb_movie_integer_id AS INTEGER) AS imdb_movie_integer_id
    , CAST(tmdb_movie_id AS INTEGER) AS tmdb_movie_id
  FROM rename_column
)

, handle_null AS (
  SELECT 
    movielens_movie_id 
    , COALESCE(imdb_movie_integer_id, 0) AS imdb_movie_integer_id
    , COALESCE(tmdb_movie_id, 0) AS tmdb_movie_id
  FROM cast_type
)

SELECT 
  movielens_movie_id
  , imdb_movie_integer_id
  , tmdb_movie_id
FROM handle_null
