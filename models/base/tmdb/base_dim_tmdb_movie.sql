WITH source AS (
  SELECT *
  FROM {{ source('tmdb', 'tmdb_movie_dataset') }}
)

, rename_column AS (
  SELECT 
    id AS tmdb_movie_id
    , title AS tmdb_movie_title
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

SELECT *
FROM rename_column
