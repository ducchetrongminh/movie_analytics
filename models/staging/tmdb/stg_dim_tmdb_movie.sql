WITH cleanse AS (
  SELECT *
  FROM {{ ref("base_dim_tmdb_movie") }}
  WHERE 
    status = 'Released' -- keep Released movie only
    /*
    CONTEXT: There are lots of movies that have no rating. This is similar to IMDB dataset.
    PROBLEM: We can assume that non-rating movies are not suitable for recommendation.
    SOLUTION: Remove non-rating movies to lighten the dataset.
    */
    AND tmdb_rating_avg IS NOT NULL 
)

SELECT 
  -- KEY
  tmdb_movie_id
  -- NAME
  , title
  -- DIMENSION
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
FROM cleanse 
