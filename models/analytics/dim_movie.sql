WITH join_data AS (
  SELECT 
    -- KEY
    dim_movielens_movie.movielens_movie_id
    , dim_tmdb_movie.tmdb_movie_id
    , dim_imdb_movie.imdb_movie_id
    -- TITLE
    , COALESCE(
        dim_imdb_movie.title
        , dim_tmdb_movie.title
        -- Movielens title is at last, because it contains release year
        , dim_movielens_movie.title
      ) AS title
    -- ATTRIBUTES
    , dim_imdb_movie.title_type
    , dim_imdb_movie.imdb_genres
    , dim_tmdb_movie.tmdb_genres
    , dim_movielens_movie.movielens_genres
    -- DATE
    , dim_tmdb_movie.release_date
    , dim_imdb_movie.start_year
    , dim_imdb_movie.end_year
    -- NUMBER ATTRIBUTES
    , COALESCE(dim_imdb_movie.runtime_minutes, dim_tmdb_movie.runtime_minutes) AS runtime_minutes
    , dim_tmdb_movie.budget
    , dim_tmdb_movie.revenue
    , dim_imdb_movie.imdb_rating_avg
    , dim_imdb_movie.imdb_rating_count
    , dim_tmdb_movie.tmdb_rating_avg
    , dim_tmdb_movie.tmdb_rating_count
    , dim_tmdb_movie.tmdb_popularity
    , dim_movielens_movie.movielens_rating_avg
    , dim_movielens_movie.movielens_rating_count

  FROM {{ ref('stg_dim_movielens_movie') }} AS dim_movielens_movie
  FULL OUTER JOIN {{ ref('stg_dim_tmdb_movie') }} AS dim_tmdb_movie
    USING (tmdb_movie_id)
  FULL OUTER JOIN {{ ref('stg_dim_imdb_movie') }} AS dim_imdb_movie 
    ON COALESCE(dim_movielens_movie.imdb_movie_id, dim_tmdb_movie.imdb_movie_id)
      = dim_imdb_movie.imdb_movie_id
)

, add_key AS (
  SELECT 
    *
    , FARM_FINGERPRINT(COALESCE(
      'IMDB' || imdb_movie_id
      , 'TMDB' || tmdb_movie_id
      , 'MOVIELENS' || movielens_movie_id
    )) AS movie_key
  FROM join_data
)

, enrich AS (

  {% set RATING_COUNT %}
    (COALESCE(imdb_rating_count, 0) + COALESCE(tmdb_rating_count, 0) + COALESCE(movielens_rating_count, 0))
  {% endset %}
  
  SELECT 
    *
    -- Note that we convert Movielens rating from 5 to 10 scale
    , (COALESCE(imdb_rating_avg * imdb_rating_count, 0) + COALESCE(tmdb_rating_avg * tmdb_rating_count, 0) + COALESCE(movielens_rating_avg*2 * movielens_rating_count, 0)) / NULLIF({{ RATING_COUNT }}, 0) 
      AS overall_rating_avg 
    , {{ RATING_COUNT }} AS overall_rating_count 
  FROM add_key
)


SELECT 
  -- KEY
  movie_key
  -- TITLE
  , title
  -- ATTRIBUTES
  , title_type
  , imdb_genres
  , tmdb_genres
  , movielens_genres
  -- DATE
  , release_date
  , start_year
  , end_year
  -- NUMBER ATTRIBUTES
  , runtime_minutes
  , budget
  , revenue
  , overall_rating_avg
  , overall_rating_count
  , imdb_rating_avg
  , imdb_rating_count
  , tmdb_rating_avg
  , tmdb_rating_count
  , tmdb_popularity
  , movielens_rating_avg
  , movielens_rating_count
  -- FOREIGN DIM
  , movielens_movie_id
  , tmdb_movie_id
  , imdb_movie_id
FROM enrich
