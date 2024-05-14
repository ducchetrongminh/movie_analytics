# Create dataset tmdb and upload data
# To run this script, on Google Cloud Platform, Activate Cloud Shell
# Activate Cloud Shell: https://cloud.google.com/shell/docs/using-cloud-shell#start_a_new_session

wget https://zoomchartswebstorage.blob.core.windows.net/contest/Onyx_Data_DataDNA_Challenge_April_2024.zip

unzip Onyx_Data_DataDNA_Challenge_April_2024.zip -d Onyx_Data_DataDNA_Challenge_April_2024

bq --location US mk --dataset tmdb

bq load --source_format=CSV --autodetect --skip_leading_rows=1 --allow_quoted_newlines \
  tmdb.tmdb_movie_dataset Onyx_Data_DataDNA_Challenge_April_2024/Onyx_Data_DataDNA_Challenge_April_2024/TMDB_Movies_dataset.csv

bq update \
  --description "Source of the dataset: https://zoomcharts.com/en/microsoft-power-bi-custom-visuals/challenges/onyx-data-april-2024" \
  tmdb.tmdb_movie_dataset
