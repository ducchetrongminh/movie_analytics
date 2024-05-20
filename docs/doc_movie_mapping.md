# Movie Mapping

This document explains how we do the mapping of movies from different platforms.

# The problems

Context: We have movie data from IMDB, TMDB, Movielens. We want to connect data from these platforms, so that we can have a overview of movies.

Problem: There is no universal key. Instead, each platform has their own surrogate key. Luckily, Movielens has linking to IMDB and TMDB. TMDB also has linking to IMDB. However, these linkings are not complete, therefore we need to improve on this issue.

# Problem breakdowns

## How to map movie from different platform?

The initial idea was to use the combination of movie title + release year. We run a query to test the duplication of (title + release year).

## How to determine the performance of the mapping?

