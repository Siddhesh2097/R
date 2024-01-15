

#Packages -----------------------------------------------
library(tidyverse)
library(rvest)
library(dbplyr)
library(RSQLite)
# install.packages("RSQLite")
library(DBI)



#Get Data -----------------------------------------------
combine2023_raw <- read_html(
  "https://www.pro-football-reference.com/draft/2023-combine.htm"
) %>%
  html_table() %>% #Parse an html table into a dataframe
  as.data.frame() %>% 
  filter(Player != "Player") #remove repeated headers

## Create position groupings
combine2023_pos <- combine2023_raw %>% 
  mutate(Position = case_when(
    Pos %in% c("OT","OG","C") ~ "OL",
    Pos %in% c("ILB", "OLB") ~ "LB",
    Pos %in% c("S","CB") ~ "DB",
    Pos %in% c("EDGE") ~ "DE",
    Pos %in% c("DT") ~ "DL",
    TRUE ~ as.character(Pos) ## default case
  )
  )

##Cleaning data  -----------------------------------------------

combine2023_clean <- combine2023_pos %>% 
  separate_wider_delim(Drafted..tm.rnd.yr., names = c("Tm", "Rd", "Pick", "Yr"), delim = "/",
                       too_few = "align_end") %>%
  mutate(
    Rd = case_when(
      is.na(Rd) ~ "FA",
      TRUE ~ as.character(readr::parse_number(Rd)) #parse :- just pull out the number
    )
  ) %>%
  mutate(across(.cols = c(Wt:Shuttle), ~as.numeric(.x)))

combine2023_clean %>%  head()

### Write to database -----------------------------------------------

db_con <- dbConnect(
  drv = RSQLite::SQLite(),
  dbname = ":memory:"   # Create in memory, db_con is not created anywhere
)

dbWriteTable(db_con, name = "combine2023", value = combine2023_clean)
dbListTables(db_con)

#disconnect
dbDisconnect(db_con)

###Interact with DB
db_con <- dbConnect(
  RSQLite::SQLite(),
  database = "comnbine.db"
)

Position_counts <- dbGetQuery(db_con, 
                              statement = "
                                SELECT Position, COUNT (*) As N 
                                FROM combine2023
                                WHERE School = 'Alabama'
                                GROUP BY Position
                                ORDER BY N desc")

### Write a query

alabama_draft_picks <- tbl(db_con, "combine2023") %>%
  filter(School == "Alabama") %>%
  count(Position) %>%
  arrange(desc(n))

## see results
alabama_draft_picks %>% 
  collect()

### see the actual SQL query
alabama_draft_picks %>% show_query()

##disconnect
dbDisconnect(db_con)

