WITH cleanse AS (
  SELECT *
  FROM {{ ref("base_dim_imdb_movie") }}
  WHERE 
    -- 20240516 remove 4 cases that title is null
    title IS NOT NULL 

    -- These are the types of movies/tv series
    AND title_type IN ('movie', 'tvMiniSeries', 'tvMovie', 'tvSeries')
)

, join_data AS (
  SELECT 
    dim_imdb_movie.*
    , dim_imdb_movie__rating.imdb_rating_avg
    , dim_imdb_movie__rating.imdb_rating_count
  FROM cleanse AS dim_imdb_movie 
  /*
  CONTEXT: There are lots of movies that have no IMDb rating (nearly 60%).
  PROBLEM: We can assume that non-rating movies are not suitable for recommendation.
  SOLUTION: Remove non-rating movies to lighten the dataset.
  */
  JOIN {{ ref("base_dim_imdb_movie__rating") }} AS dim_imdb_movie__rating
    USING (imdb_movie_id)
)

SELECT 
  imdb_movie_id
  , title

  , title_type
  , imdb_genres

  , start_year
  , end_year

  , runtime_minutes
  , imdb_rating_avg
  , imdb_rating_count
FROM join_data
