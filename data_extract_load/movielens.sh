# Create dataset movielens and upload data
# To run this script, on Google Cloud Platform, Activate Cloud Shell
# Activate Cloud Shell: https://cloud.google.com/shell/docs/using-cloud-shell#start_a_new_session

curl -O 'http://files.grouplens.org/datasets/movielens/ml-latest.zip'
unzip ml-latest.zip

bq --location US mk --dataset movielens

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.genome_scores ml-latest/genome-scores.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.genome_tags ml-latest/genome-tags.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.links ml-latest/links.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.movies ml-latest/movies.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.ratings ml-latest/ratings.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens.tags ml-latest/tags.csv
