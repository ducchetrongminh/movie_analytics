SELECT *
FROM {{ source('movielens_25m', 'movies') }}
