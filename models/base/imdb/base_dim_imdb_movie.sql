SELECT *
FROM {{ source('imdb', 'title_basics') }}
