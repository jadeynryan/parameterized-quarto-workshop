## Header ======================================================================
##
## Script name: data.R
##
## Purpose: Get fun data about cats and dogs registered in Switzerland for
## R-Ladies workshop.
##
## Data source: Identitas AG, Animal statistics
## https://tierstatistik.identitas.ch/en/cats.html
##
## Author: Jadey Ryan
##
## Date created: 2024-01-14
##
## Notes:
##

# Attach packages ==============================================================

library(readr)
library(janitor)
library(lubridate)
library(purrr)
library(tidyr)
library(dplyr)
library(stringr)

# Load data ====================================================================

read_data <- function(pet) {
  read_delim(
    paste0("https://tierstatistik.identitas.ch/data/", pet, "-breeds.csv"),
    delim = ";",
    skip = 1,
    show_col_types = FALSE
  ) |>
    clean_names() |>
    mutate(
      pet_type = pet,
      date = make_date(year, month),
      .before = year
    )
}

pets <- c("cats", "dogs") |>
  set_names() |>
  map(read_data)

# Tidy data ====================================================================

tidy_breeds <- function(data) {
  data |>
    pivot_longer(
      cols = !matches(c("pet_type|date|year|month")),
      names_to = "breed",
      values_to = "count"
    ) |>
    mutate(
      breed = str_to_title(str_replace_all(breed, "_", " "))
    )
}

pets <- pets |>
  map(tidy_breeds) |>
  list_rbind()

# Save data ====================================================================

saveRDS(pets, "data/pets.RDS")
