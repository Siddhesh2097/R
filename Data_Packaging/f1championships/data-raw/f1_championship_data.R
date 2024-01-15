## code to prepare `f1_championship_data` dataset goes here

#Building a data package

library(tidyverse)
library(rvest) ### Helps for web scraping

## F1 Racing Statistics
## https://www.racing-statistics.com/

f1_season_records <- function(year) {
  x <- read_html(file.path("https://www.racing-statistics.com/en/seasons",year))

  year_tables <- x %>% html_nodes(".blocks") %>% html_table

  Championship_tables <- year_tables[[1]] %>%  janitor::clean_names() %>% select(-driver, -driver_3) %>% rename(driver = driver_2)

  Event_tables <- year_tables[[2]] %>%  janitor::clean_names() %>% select(-winning_driver) %>% rename(driver = winning_driver_2)

  list(year=year, Championship_tables=Championship_tables , Event_tables=Event_tables)
}

##Map all together

## just taking few for testing
historical_f1_data <- 1950:2023 %>%
  map(f1_season_records)


usethis::use_data(historical_f1_data, overwrite = TRUE)

## Championship results
f1_championship_data <-  historical_f1_data %>%
  map(\(x) {x$Championship_tables} %>% mutate(year = x$year)) %>% bind_rows()

## Event results
f1_events_data <-  historical_f1_data %>%
  map(\(x) {x$Event_tables} %>% mutate(year = x$year)) %>% bind_rows()


usethis::use_data(f1_championship_data, overwrite = TRUE)
usethis::use_data(f1_events_data, overwrite = TRUE)
