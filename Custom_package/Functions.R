## Turning functions into packages

## Writing functions

rm(list = ls())
library(tidyverse)
library(Lahman)

theme_set(theme_light())

batting <- Batting %>%
  filter(yearID >= 2010) %>%
  mutate(batting_avg = H / AB) %>%
  select(playerID, yearID, AB, H, batting_avg)

teams <- Teams %>%
  filter(yearID >= 2010) %>%
  mutate(runs_per_game = R / G) %>%
  select(yearID, teamID, G, R, runs_per_game)

# FUNCTIONNAME <- function(PARAMS/ARGUMENTS){
#   FUNCTION BODY
# }


