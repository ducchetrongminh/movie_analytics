# Create dataset movielens_25m and upload data
# To run this script, on Google Cloud Platform, Activate Cloud Shell
# Activate Cloud Shell: https://cloud.google.com/shell/docs/using-cloud-shell#start_a_new_session

curl -O 'http://files.grouplens.org/datasets/movielens/ml-25m.zip'
unzip ml-25m.zip

bq --location US mk --dataset movielens_25m

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.genome_scores ml-25m/genome-scores.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.genome_tags ml-25m/genome-tags.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.links ml-25m/links.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.movies ml-25m/movies.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.ratings ml-25m/ratings.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  movielens_25m.tags ml-25m/tags.csv
