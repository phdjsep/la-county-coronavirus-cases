#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ggthemes)
library(plotly)
library(dplyr)
library(readr)
library(here)

total_merge <- read_rds(path = here::here("data/total/", "total-merged.rds"))
age_merge <- read_rds(path = here::here("data/age/", "age-merged.rds"))
community_merge <- read_rds(path = here::here("data/community/", "community-merged.rds"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Novel Coronavirus Counts in LA County"),

    fillRow(),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            wellPanel("Total Coronavirus Cases", 
                      h1(max(total_merge$total_cases))),
            selectInput("select", h3("Choose Community"), 
                        choices = community_merge$locations, selected = 1)
        ),

        # Show a plot of the total case count
        mainPanel(
           plotlyOutput("totalPlot"),
           plotlyOutput("communityPlot"),
           plotlyOutput("agePlot"),
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$totalPlot <- renderPlotly({
        # PLOT TOTAL CASES
        p <- ggplot(total_merge, aes(x = case_date, y = total_cases, group = locations, color = locations)) + 
            geom_line() + 
            geom_point() +
            theme_calc()
        ggplotly(p)
    })
    
    output$communityPlot <- renderPlotly({
        # PLOT COMMUNITY CASES
        p <- ggplot(filter(community_merge, locations == input$select), aes(x = case_date, y = total_cases, group = locations, color = locations)) +
            geom_line() +
            geom_point() +
            theme_calc()
        ggplotly(p)
    })
      
    output$agePlot <- renderPlotly({
        # PLOT AGE CASES
        p <- ggplot(age_merge, aes(x = case_date, y = total_cases, group = locations, color = locations)) +
            geom_line() +
            geom_point() +
            theme_calc()
        ggplotly(p)
    })  
        
}

# Run the application 
shinyApp(ui = ui, server = server)
