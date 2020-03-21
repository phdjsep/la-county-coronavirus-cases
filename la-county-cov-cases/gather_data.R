library(tidyverse)
library(lubridate)
library(janitor)
library(rvest)

# Read LA County PH Coronavirus Site
cases_html <- read_html("http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm")

# grab date of update
date_string <- cases_html %>% 
  rvest::html_nodes(css = "small") %>% 
  rvest::html_text(trim = T) %>% 
  str_replace(pattern = "[\n\r\t]+", replacement = "") %>% 
  str_extract(pattern = "\\d+/\\d+") %>% 
  paste("/2020", sep =  "") %>% 
  lubridate::mdy()

# Make string a character rather than date object?
# date_string <- as.character(date_string)
 
# Number of cases
# Number of deaths
# rvest::html_nodes(x = cases_html, css = ".counter-block") %>% 
#   rvest::html_text()

# Grab html table
cases_table <- cases_html %>% 
  rvest::html_node("table") %>% 
  rvest::html_table() %>% 
  as_tibble() %>% 
  janitor::clean_names()

# rename data column with date reported
# colnames(cases_table)[colnames(cases_table) == "total_cases"] <- date_string

# replace empty strings with NA
cases_table[cases_table == ""] <- NA

# Remove the damn asterisk and make integer
cases_table$total_cases <- stringr::str_remove(cases_table$total_cases, pattern = "[*]+")
cases_table <- type_convert(cases_table,col_types = cols(total_cases = col_integer()))

# Grab total case numbers and convert column to int
total_case_numbers <- slice(cases_table, 1:4)  
total_case_numbers$locations <- stringr::str_remove(total_case_numbers$locations, pattern = "[\\- ]") %>% 
  stringr::str_trim()
# Grab cases by age and convert column to int
age_case_numbers <- slice(cases_table, 7:10) 
# Grab cases by community and convert column to int
community_case_numbers <- slice(cases_table, 13:nrow(cases_table)) 

# Append columns when we get new dates

# Write data
write_rds(total_case_numbers, path = here::here("data", paste(date_string, "total-case-numbers.rds", sep = "-")))
write_rds(age_case_numbers, path = here::here("data", paste(date_string, "age-case-numbers.rds", sep = "-")))
write_rds(community_case_numbers, path = here::here("data", paste(date_string, "community-case-numbers.rds", sep = "-")))


ggplot(community_case_numbers, aes(x = date_string, y = total_cases, color = locations)) + 
  geom_point(stat = "identity", position = "jitter", show.legend = F) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
