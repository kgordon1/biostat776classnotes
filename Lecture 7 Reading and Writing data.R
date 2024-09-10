library(here)
library(tidyverse)

list.files(here::here())

list.files(here("data"))

#Using 2 R Functions directly (composition)
read.csv(here::here("data", "team_standings.csv"))

#Using the same functions with an intermediary
#object called standing_file
standings_file <- read.csv(here("data", "team_standings.csv"))
standings_file

standings_file$Team

here("data", "team_standings.csv")

x <- 1:5
save(x, file = here::here("data", "x.Rda"))

list.files(path = here("data"))

x <- rnorm(5)
load(here::here("data", "x.Rda"), verbose = TRUE)

library(readr)
teams <- read_csv(here("data", "team_standings.csv"))
teams
