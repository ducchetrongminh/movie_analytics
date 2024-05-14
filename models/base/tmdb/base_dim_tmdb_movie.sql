SELECT *
FROM {{ source('tmdb', 'tmdb_movie_dataset') }}
