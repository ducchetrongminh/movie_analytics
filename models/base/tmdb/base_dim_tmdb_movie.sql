WITH source AS (
  SELECT *
  FROM {{ source('tmdb', 'tmdb_movie_dataset') }}
)

, rename_column AS (
  SELECT 
    id AS tmdb_movie_id
    , title
    , vote_average AS tmdb_rating_avg
    , vote_count AS tmdb_rating_count
    , status
    , release_date
    , revenue
    , runtime AS runtime_minutes
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
      , CAST(tmdb_rating_avg AS NUMERIC) AS tmdb_rating_avg
      , CAST(tmdb_rating_count AS INTEGER) AS tmdb_rating_count
      , CAST(status AS STRING) AS status
      , CAST(release_date AS DATE) AS release_date
      , CAST(revenue AS NUMERIC) AS revenue
      , CAST(runtime_minutes AS INTEGER) AS runtime_minutes
      , CAST(budget AS NUMERIC) AS budget
      , CAST(imdb_movie_id AS STRING) AS imdb_movie_id
      , CAST(tmdb_popularity AS NUMERIC) AS tmdb_popularity
      , CAST(tmdb_genres AS STRING) AS tmdb_genres
  FROM rename_column
)

, handle_null AS (
  SELECT * 
    EXCEPT (
      tmdb_genres
      , runtime_minutes
      , budget
      , tmdb_rating_avg
      , imdb_movie_id
    )
    , COALESCE(NULLIF(tmdb_genres, ''), 'Undefined') AS tmdb_genres
    , NULLIF(runtime_minutes, 0) AS runtime_minutes
    , NULLIF(budget, 0) AS budget
    , NULLIF(tmdb_rating_avg, 0) AS tmdb_rating_avg
    , COALESCE(NULLIF(imdb_movie_id, ''), 'UNDEFINED') AS imdb_movie_id
  FROM cast_type
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
  , runtime_minutes
  , revenue
  , budget
  , tmdb_rating_avg
  , tmdb_rating_count
  , tmdb_popularity
  -- OTHER DIM
  , imdb_movie_id
FROM handle_null
