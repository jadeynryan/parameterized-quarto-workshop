library(readxl)
library(tidyverse)
library(janitor)

df_raw <- read_excel(
  path = "data/messy_uc.xlsx",
  sheet = "Data",
  skip = 5
)

names(df_raw)

df_clean <- df_raw |>
  janitor::clean_names() |>
  mutate(
    ethnic_clean = case_when(
      ethnic %in%  c("hispanic", "Hispanic", "hispamnic") ~ "hispanic",
      ethnic %in%  c("NOT hispanic", "not hispanic") ~ "not hispanic",
    )
  )


names(df_clean)
glimpse(df_clean)

df_clean |> count(ethnic)
df_clean |> count(ethnic_clean, ethnic)
df_clean |> count(ethnic_clean)
