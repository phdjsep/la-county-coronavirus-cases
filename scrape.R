# Scrape the website, clean up the result, and save the files
# Author: Sep Dadsetan
# March 23, 2020

library(tidyverse)
library(lubridate)
library(janitor)
library(rvest)

# Read LA County PH Coronavirus Site
cases_html <- read_html("http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm")

# grab date of update
date_string <- cases_html %>% 
  rvest::html_node(css = "p#dte") %>% 
  rvest::html_text(trim = T) %>% 
  str_replace(pattern = "[\n\r\t]+", replacement = "") %>% 
  str_extract(pattern = "\\d+/\\d+") %>% 
  paste("/2020", sep =  "") %>% 
  lubridate::mdy()

# Grab html table
cases_table <- cases_html %>% 
  rvest::html_node("table") %>% 
  rvest::html_table() %>% 
  as_tibble() %>% 
  janitor::clean_names()

# replace empty strings with NA
cases_table[cases_table == ""] <- NA

# Remove the damn asterisks and make integer
cases_table$total_cases <- stringr::str_remove(cases_table$total_cases, pattern = "[*]+")
cases_table$locations <- stringr::str_remove(cases_table$locations, pattern = "[*]+")
cases_table <- type_convert(cases_table,col_types = cols(total_cases = col_integer()))
cases_table <- mutate(cases_table, case_date = date_string)

# Grab total case numbers and convert column to int
total_case_numbers <- slice(cases_table, 1:4)  
total_case_numbers$locations <- stringr::str_remove(total_case_numbers$locations, pattern = "[\\- ]") %>% 
  stringr::str_trim()

# Grab deaths
death_numbers <- slice(cases_table, 6:9)
death_numbers$locations <- stringr::str_remove(death_numbers$locations, pattern = "[\\- ]") %>% 
  stringr::str_trim()

# Grab cases by age and convert column to int
age_case_numbers <- slice(cases_table, 13:16) 

# Grab hospitalizations
hospitalization_case_numbers <- slice(cases_table, 19)

# Grab cases by community and convert column to int
community_case_numbers <- slice(cases_table, 23:nrow(cases_table)) 

# Write data
write_rds(total_case_numbers, path = here::here("data/total/", paste(date_string, "total-case-numbers.rds", sep = "-")))
write_rds(death_numbers, path = here::here("data/deaths/", paste(date_string, "death-case-numbers.rds", sep = "-")))
write_rds(age_case_numbers, path = here::here("data/age/", paste(date_string, "age-case-numbers.rds", sep = "-")))
write_rds(hospitalization_case_numbers, path = here::here("data/hospitalizations/", paste(date_string, "hospitalization-case-numbers.rds", sep = "-")))
write_rds(community_case_numbers, path = here::here("data/community/", paste(date_string, "community-case-numbers.rds", sep = "-")))

