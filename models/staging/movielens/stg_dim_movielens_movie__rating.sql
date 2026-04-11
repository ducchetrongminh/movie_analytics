SELECT 
  movielens_movie_id
  , AVG(rating) AS movielens_rating_avg
  , COUNT(*) AS movielens_rating_count
FROM {{ ref('base_fact_movielens_rating') }}
GROUP BY 1
