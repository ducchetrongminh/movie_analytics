# Create dataset imdb and upload data
# To run this script, on Google Cloud Platform, Activate Cloud Shell
# Activate Cloud Shell: https://cloud.google.com/shell/docs/using-cloud-shell#start_a_new_session

curl -O 'https://datasets.imdbws.com/name.basics.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.akas.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.basics.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.crew.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.episode.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.principals.tsv.gz'

curl -O 'https://datasets.imdbws.com/title.ratings.tsv.gz'


bq --location US mk --dataset imdb

bq load --source_format=CSV --field_delimiter=tab --quote= \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.name_basics name.basics.tsv.gz

bq load --source_format=CSV --field_delimiter=tab --quote= \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_akas title.akas.tsv.gz

bq load --source_format=CSV --field_delimiter=tab --quote= \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_basics title.basics.tsv.gz

bq load --source_format=CSV --field_delimiter=tab \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_crew title.crew.tsv.gz

bq load --source_format=CSV --field_delimiter=tab \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_episode title.episode.tsv.gz

bq load --source_format=CSV --field_delimiter=tab  --quote= \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_principals title.principals.tsv.gz

bq load --source_format=CSV --field_delimiter=tab \
  --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  imdb.title_ratings title.ratings.tsv.gz
