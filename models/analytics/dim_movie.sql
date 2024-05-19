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

  FROM {{ ref('stg_dim_movielens_movie') }} AS dim_movielens_movie
  FULL OUTER JOIN {{ ref('stg_dim_tmdb_movie') }} AS dim_tmdb_movie
    USING (tmdb_movie_id)
  FULL OUTER JOIN {{ ref('stg_dim_imdb_movie') }} AS dim_imdb_movie 
    ON COALESCE(dim_movielens_movie.imdb_movie_id, dim_tmdb_movie.imdb_movie_id)
      = dim_imdb_movie.imdb_movie_id
)


SELECT 
  -- KEY
  movielens_movie_id
  , tmdb_movie_id
  , imdb_movie_id
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
  , imdb_rating_avg
  , imdb_rating_count
  , tmdb_rating_avg
  , tmdb_rating_count
  , tmdb_popularity
FROM join_data
