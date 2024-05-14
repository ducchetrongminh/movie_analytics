WITH source AS (
  SELECT *
  FROM {{ source('tmdb', 'tmdb_movie_dataset') }}
)

, rename_column AS (
  SELECT 
    id AS tmdb_movie_id
    , title
    , vote_average AS tmdb_vote_avg
    , vote_count AS tmdb_vote_count
    , status
    , release_date
    , revenue
    , runtime
    , budget
    , imdb_id AS imdb_movie_id
    , popularity AS tmdb_popularity
    , genres AS tmdb_genres
  FROM source
)

, cast_type AS (
  SELECT 
      CAST(tmdb_movie_id AS INTEGER) AS tmdb_movie_id
      , CAST(title AS STRING) AS title
      , CAST(tmdb_vote_avg AS NUMERIC) AS tmdb_vote_avg
      , CAST(tmdb_vote_count AS INTEGER) AS tmdb_vote_count
      , CAST(status AS STRING) AS status
      , CAST(release_date AS DATE) AS release_date
      , CAST(revenue AS NUMERIC) AS revenue
      , CAST(runtime AS INTEGER) AS runtime
      , CAST(budget AS NUMERIC) AS budget
      , CAST(imdb_movie_id AS STRING) AS imdb_movie_id
      , CAST(tmdb_popularity AS NUMERIC) AS tmdb_popularity
      , CAST(tmdb_genres AS STRING) AS tmdb_genres
  FROM rename_column
)

SELECT
  -- KEY
  tmdb_movie_id
  -- NAME
  , title
  -- DIMENSION
  , status
  , tmdb_genres
  -- DATE
  , release_date
  -- NUMBER ATTRIBUTES
  , runtime
  , revenue
  , budget
  , tmdb_vote_avg
  , tmdb_vote_count
  , tmdb_popularity
  -- OTHER DIM
  , imdb_movie_id
FROM cast_type
