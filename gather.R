# Gather the written files into a dataset to be used by the dashboard
# Author: Sep Dadsetan
# March 23, 2020

library(here)
library(lubridate)

# Handy merging function
multmerge <- function(mypath) {
  filenames = list.files(path = mypath, full.names = TRUE)
  datalist = lapply(filenames, function(x) { read_rds(path = x)})
  bind_rows(datalist)
}

# Let's merge the data we gather each day
total_merge <- multmerge(here::here("data/total"))
age_merge <- multmerge(here::here("data/age"))
death_merge <- multmerge(here::here("data/deaths"))
hospitalization_merge <- multmerge(here::here("data/hospitalizations"))
community_merge <- multmerge(here::here("data/community"))

# Grab latest date from data
latest_date <- max(total_merge$case_date)

# Let's write out the tables
write_rds(total_merge, path = here::here("data/merged/", "total-merged.rds"))
write_rds(age_merge, path = here::here("data/merged/", "age-merged.rds"))
write_rds(death_merge, path = here::here("data/merged/", "death-merged.rds"))
write_rds(hospitalization_merge, path = here::here("data/merged/", "hospitalization-merged.rds"))
write_rds(community_merge, path = here::here("data/merged/", "community-merged.rds"))
