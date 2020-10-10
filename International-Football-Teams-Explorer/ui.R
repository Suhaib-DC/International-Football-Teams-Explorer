#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(plotly)
library(shiny)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("National Football Teams Explorer"),
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(
                sidebarPanel(
                        sliderInput("era",
                                    "Era: Years within your intrest",
                                    min = 1872,
                                    max = 2020,
                                    value = c(2000,2010)),
                        
                        radioButtons("rb",
                                     "Type of Exploring",
                                     choices = list("Top 10" = 1,
                                                    "One Team" = 2),
                                     selected = 1),
                        
                        selectInput("tm",
                                    "Your Team",
                                    choices = NMR$team,
                                    selected = "Germany")
                        
                        
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        tabsetPanel(type = "tabs",
                                    tabPanel("How it Works", 
                                             h1("How it Works"),
                                             h5("This app is to provide a simple statistics about National teams results within a specific era."),
                                             h3("First Step: Chose an era"),
                                             h5("Move the slider to chose the years that you want to explor."),
                                             h3("Second Step: Type of exploring"),
                                             h5("You can see a specific team within the era or you can just see the best and worst teams."),
                                             h3("Last step: Your Team"),
                                             h5("If you chose one team from above then just select your team.")
                                             ),
                                    tabPanel("Matches Results",plotlyOutput("myPlot")))
                        
                )
        )
))
