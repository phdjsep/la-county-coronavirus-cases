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
total_merge <- multmerge(here("data/total"))
age_merge <- multmerge(here("data/age"))
community_merge <- multmerge(here("data/community"))

# Grab latest date from data
latest_date <- max(total_merge$case_date)

# Let's write out the tables
write_rds(total_merge, path = here::here("data/total/", "total-merged.rds"))
write_rds(age_merge, path = here::here("data/age/", "age-merged.rds"))
write_rds(community_merge, path = here::here("data/community/", "community-merged.rds"))
