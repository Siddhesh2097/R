#Building a data package

library(tidyverse)
library(rvest) ### Helps for web scraping


#F1 racing statistics
## https://www.racing-statistics.com/

x <- read_html("https://www.racing-statistics.com/en/seasons/2023")

year_tables <- x %>% html_nodes(".blocks") %>% html_table

Championship_tables <- year_tables[[1]] %>%  janitor::clean_names() %>% select(-driver, -driver_3) %>% rename(driver = driver_2)

Event_tables <- year_tables[[2]] %>%  janitor::clean_names() %>% select(-winning_driver) %>% rename(driver = winning_driver_2)

## time to functionalize this

f1_season_records <- function(year) {
  x <- read_html(file.path("https://www.racing-statistics.com/en/seasons",year))
  
  year_tables <- x %>% html_nodes(".blocks") %>% html_table
  
  Championship_tables <- year_tables[[1]] %>%  janitor::clean_names() %>% select(-driver, -driver_3) %>% rename(driver = driver_2)
  
  Event_tables <- year_tables[[2]] %>%  janitor::clean_names() %>% select(-winning_driver) %>% rename(driver = winning_driver_2)
  
  list(year=year, Championship_tables=Championship_tables , Event_tables=Event_tables)
}

f1_season_records(2021)

##Map all together

historical_f1_data <- 1950:2023 %>% 
  map(f1_season_records)

library(ggplot2)

##winning constructor over the years

constructors <- historical_f1_data %>% 
  map(function(year_data){
    year_data[["Championship_tables"]] %>% ### same as historical_f1_data[[1]][[2]] --> map opens up the list
      group_by(constructor) %>% 
      summarize(points = sum(points), .groups = "drop") %>% 
      arrange(desc(points)) %>% 
      slice(1) %>% 
      mutate(year = year_data[["year"]] )
  }) %>% 
  bind_rows() %>% 
  arrange(year)

## make a waffle
theme_set(theme_void())

n_col = 10

dat <- constructors %>% 
  arrange(as.numeric(year)) %>% 
  mutate(
    col_idx = (row_number()-1) %% (n_col),
    row_idx = -floor((row_number()-1)/(n_col))
  )

constructors %>% 
  arrange(as.numeric(year)) %>% 
  mutate(
    col_idx = (row_number()-1) %% (n_col),
    row_idx = -floor((row_number()-1)/(n_col))
  ) %>% 
  ggplot(
    aes(
      x = col_idx,
      y = row_idx
    )
  ) +
  geom_tile(
    aes(
      fill = constructor
    )
  ) +
  geom_text(
    aes(
      label=year
    )
  ) +
  scale_fill_manual(
    name = NULL,
    labels = c("Alfa Romeo", "Benetton", "Brabham-Repco","Brawn", "BRM",
               "Cooper-Climax", "Ferrari", "Lotus-Climax", "Lotus-Ford", "Maserati",
               "Matra-Ford", "McLaren", "Mercedes", "Red Bull", "Renault", "Team Lotus",
               "Tyrrell", "Williams"),
    ## Hex Codes based on Asking ChatGPT for hex codes best representative of
    ## the livery of the team
    values = c("#9B0000", "#0066CC", "#006600", "#C30000", "#FF0000",
               "#003399", "#DC0000", "#006400", "#0000CD", "#1F4096",
               "#FFD700", "#FF8700", "#00D2BE", "#0800FF", "#F9FF00",
               "#006400", "#002055", "#FFFFFF")
  ) +
  labs(
    title = "Eras of Dominance",
    subtitle = "F1 Constructors Champions from 1950 to 2023"
  )















