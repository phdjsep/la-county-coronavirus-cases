# la-county-coronavirus-cases
A dashboard to track case counts provided by LA County Public Health Office

The LA County Public Health office posts the counts of coronavirus cases in both total and by community each day. The goal of this is to capture that the data on that site on a daily basis so that we can visualize a daily trend in total and across communities.

## Rough architecture

**data/** - each days data will end up in this folder with the date prepended to the type of case counts
**la-county-cov-cases/** - this is the shiny app and also where the data scrape and clean script resides. Writing to data when it's complete.
